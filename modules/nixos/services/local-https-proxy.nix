# NixOS backend for mynix.services.localHttpsProxy: shared options live
# in modules/common/local-https-proxy.nix; this wires `services.caddy`.
{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.services.localHttpsProxy;
in
{
  imports = [ ../../common/local-https-proxy.nix ];

  options.mynix.services.localHttpsProxy.openFirewall = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Open ports 80/443 in the system firewall.";
  };

  config = lib.mkMerge [
    {
      # services.caddy runs with HOME=/var/lib/caddy, so the internal CA
      # lands under its XDG data dir.
      mynix.services.localHttpsProxy.caddyRootCA = "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt";
    }

    (lib.mkIf cfg.enable {
      services.caddy = {
        enable = true;
        virtualHosts = lib.mapAttrs (_name: vh: {
          extraConfig = ''
            tls internal
            reverse_proxy ${vh.upstream}
            ${vh.extraConfig}
          '';
        }) cfg.virtualHosts;
      };

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [
          80
          443
        ];
      };
    })
  ];
}
