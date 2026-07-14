# Darwin backend for mynix.services.localHttpsProxy: shared options live
# in modules/common/local-https-proxy.nix. nix-darwin lacks
# `services.caddy`, so this module wires up a launchd daemon directly
# with a generated Caddyfile.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mynix.services.localHttpsProxy;

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
in
{
  imports = [ ../../common/local-https-proxy.nix ];

  config = lib.mkMerge [
    {
      mynix.services.localHttpsProxy.caddyRootCA = "${stateDir}/pki/authorities/local/root.crt";
    }

    (lib.mkIf cfg.enable {
      environment.systemPackages = [ pkgs.caddy ];

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
    })
  ];
}
