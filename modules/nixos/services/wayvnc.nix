# wayvnc: VNC server for the active Hyprland/wlroots session on dahlia.
# Unlike X11 VNC servers, wayvnc attaches to the already-running compositor
# via wlr-screencopy + virtual-input protocols instead of spinning up a
# separate session, so a remote client sees and controls the real desktop.
#
# Reachable only via the NetBird mesh: modules/nixos/core/firewall.nix
# already trusts all NetBird interfaces, so no firewall rule is added here.
# `enable_auth` adds a password (+ self-signed TLS) as defense-in-depth on
# top of that network-level trust.
{
  config,
  pkgs,
  username,
  ...
}:
let
  stateDir = "/home/${username}/.local/state/wayvnc";

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

  sops.templates."wayvnc-config" = {
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
      ExecStartPre = "${ensureTls}/bin/wayvnc-ensure-tls";
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc -C ${config.sops.templates."wayvnc-config".path}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
