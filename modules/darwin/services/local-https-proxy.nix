# Darwin counterpart of modules/nixos/services/local-https-proxy.nix.
# nix-darwin lacks `services.caddy`, so this module wires up a launchd
# daemon directly with a generated Caddyfile.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mynix.services.localHttpsProxy;

  vhostType = lib.types.submodule {
    options = {
      upstream = lib.mkOption {
        type = lib.types.str;
        example = "127.0.0.1:6271";
      };
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };
  };

  stateDir = "/var/lib/caddy";

  caddyfile = pkgs.writeText "Caddyfile" (
    ''
      {
        storage file_system ${stateDir}
      }

    ''
    + lib.concatStringsSep "\n" (
      lib.mapAttrsToList (host: vh: ''
        ${host} {
          tls internal
          reverse_proxy ${vh.upstream}
          ${vh.extraConfig}
        }
      '') cfg.virtualHosts
    )
  );

  caddyRootCA = "${stateDir}/pki/authorities/local/root.crt";
  exportedCAPath = "/var/lib/caddy-local-ca/root.crt";

  exportCaScript = pkgs.writeShellApplication {
    name = "local-https-proxy-export-ca";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      src=${lib.escapeShellArg caddyRootCA}
      dst=${lib.escapeShellArg exportedCAPath}
      if [ ! -r "$src" ]; then
        echo "local-https-proxy: $src is not yet present; start caddy first." >&2
        exit 1
      fi
      install -Dm0644 "$src" "$dst"
      echo "Copied Caddy local root CA to $dst"
      echo "Add it to security.pki.certificateFiles to trust it system-wide."
    '';
  };
in
{
  options.mynix.services.localHttpsProxy = {
    enable = lib.mkEnableOption "local HTTPS reverse proxy via Caddy with an internal CA";

    virtualHosts = lib.mkOption {
      type = lib.types.attrsOf vhostType;
      default = { };
    };

    trustedRootCAFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.caddy
      exportCaScript
    ];

    launchd.daemons.caddy = {
      serviceConfig = {
        Label = "info.tnmt.caddy";
        ProgramArguments = [
          "${pkgs.caddy}/bin/caddy"
          "run"
          "--config"
          "${caddyfile}"
          "--adapter"
          "caddyfile"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/log/caddy.log";
        StandardErrorPath = "/var/log/caddy.err.log";
      };
    };

    # Ensure the state directory exists and is owned by root before launchd
    # starts caddy.
    system.activationScripts.preActivation.text = ''
      mkdir -p ${stateDir}
      chown root:wheel ${stateDir}
      chmod 0750 ${stateDir}
    '';

    security.pki.certificateFiles = lib.mkIf (cfg.trustedRootCAFile != null) [
      cfg.trustedRootCAFile
    ];
  };
}
