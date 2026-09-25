# wayvnc: VNC server for the active Hyprland/wlroots session on dahlia.
# Unlike X11 VNC servers, wayvnc attaches to the already-running compositor
# via wlr-screencopy + virtual-input protocols instead of spinning up a
# separate session, so a remote client sees and controls the real desktop.
#
# Reachable only via the NetBird mesh: modules/nixos/core/firewall.nix
# already trusts all NetBird interfaces, so no firewall rule is added here.
# `enable_auth` adds a password (+ self-signed TLS) as defense-in-depth on
# top of that network-level trust.
#
# wayvnc shares a dedicated headless output (not the real monitor) because
# the real monitor is 3840x2160 and VNC clients (TigerVNC in particular)
# have no client-side downscaling, forcing remote users to scroll. The
# headless output gets its own workspace (99, outside the SUPER+1..0 range)
# so it never steals focus from or reflows the real desktop's workspaces.
{
  config,
  homeDirectory,
  pkgs,
  username,
  ...
}:
let
  stateDir = "${homeDirectory}/.local/state/wayvnc";
  vncOutputName = "VNC-1";
  # Matches hydrangea's logical desktop resolution (1680x1050) since
  # TigerVNC draws 1 remote pixel per point with no client-side downscaling.
  # TigerVNC runs fullscreen there, so no allowance for a title/menu bar.
  vncMode = "1680x1050@60";
  vncWorkspace = "99";

  ensureVncOutput = pkgs.writeShellApplication {
    name = "wayvnc-ensure-output";
    runtimeInputs = [
      pkgs.hyprland
      pkgs.jq
    ];
    text = ''
      # Hyprland 0.55+'s Lua config dropped `hyprctl keyword`; runtime changes
      # go through `hyprctl eval`, calling the same hl.* functions config.lua uses.
      #
      # The workspace rule must be registered BEFORE the output is created:
      # Hyprland assigns a newly-created monitor's initial workspace (consulting
      # any monitor-bound "default" rule) at creation time, not retroactively.
      # Registering the rule first means VNC-1 opens directly on workspace 99
      # instead of an auto-picked one that might collide with a SUPER+1..9 slot.
      hyprctl eval 'hl.workspace_rule({ workspace = "${vncWorkspace}", monitor = "${vncOutputName}", default = true })'

      existing=$(hyprctl monitors -j | jq -r '.[].name' | grep -Fx "${vncOutputName}" || true)
      if [ -z "$existing" ]; then
        hyprctl output create headless "${vncOutputName}"
      fi
      hyprctl eval 'hl.monitor({ output = "${vncOutputName}", mode = "${vncMode}", position = "auto", scale = 1 })'
    '';
  };

  # TLS/RSA key material is regenerated locally on first start rather than
  # kept in sops: it only needs to exist, not be escrowed, and self-signed
  # certs don't benefit from git history.
  ensureTls = pkgs.writeShellApplication {
    name = "wayvnc-ensure-tls";
    runtimeInputs = [ pkgs.openssl ];
    text = ''
      mkdir -p "${stateDir}"
      [ -f "${stateDir}/tls_cert.pem" ] || openssl req -x509 -newkey rsa:4096 -nodes \
        -keyout "${stateDir}/tls_key.pem" -out "${stateDir}/tls_cert.pem" \
        -days 36500 -subj "/CN=wayvnc-dahlia"
      # -traditional: OpenSSL 3.x's genrsa defaults to PKCS#8 output, but
      # wayvnc's RSA-AES security type loads the key via nettle directly,
      # which only understands the legacy PKCS#1 format and segfaults on
      # PKCS#8 instead of failing cleanly.
      [ -f "${stateDir}/rsa_key.pem" ] || openssl genrsa -traditional -out "${stateDir}/rsa_key.pem" 2048
    '';
  };
in
{
  sops.secrets.wayvnc_password = { };

  sops.templates.wayvncConfig = {
    owner = username;
    content = ''
      address=0.0.0.0
      port=5900
      enable_auth=true
      username=${username}
      password=${config.sops.placeholder.wayvnc_password}
      certificate_file=${stateDir}/tls_cert.pem
      private_key_file=${stateDir}/tls_key.pem
      rsa_private_key_file=${stateDir}/rsa_key.pem
    '';
  };

  systemd.user.services.wayvnc = {
    description = "wayvnc VNC server for the active Hyprland session";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "exec";
      # A separate oneshot unit for ensureVncOutput, ordered before this one,
      # was tried first but NixOS switch-to-configuration stops a unit whose
      # Requires= target changed without restarting it, leaving wayvnc dead
      # after every switch. Running it as a second ExecStartPre keeps this a
      # single unit, so a changed derivation just restarts wayvnc normally;
      # ensureVncOutput's own existence check keeps output creation idempotent
      # across wayvnc's Restart=on-failure retries.
      ExecStartPre = [
        "${ensureTls}/bin/wayvnc-ensure-tls"
        "${ensureVncOutput}/bin/wayvnc-ensure-output"
      ];
      # wayvnc's config file has no `output=` keyword; restricting capture to
      # the headless output is CLI-only (-o/--output).
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc -C ${config.sops.templates.wayvncConfig.path} -o ${vncOutputName}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
