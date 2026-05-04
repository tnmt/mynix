# Darwin profile: givy bundle.
# Counterpart of profiles/nixos/givy.nix.
{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.mynix.profiles.givy;

  instanceType = lib.types.submodule {
    options = {
      root = lib.mkOption {
        type = lib.types.str;
        description = "Directory served by this givy instance.";
      };
      port = lib.mkOption {
        type = lib.types.port;
        description = "TCP port the instance listens on.";
      };
    };
  };
in
{
  imports = [
    ../../modules/darwin/services/local-https-proxy.nix
  ];

  options.mynix.profiles.givy = {
    enable = lib.mkEnableOption "givy + Caddy reverse proxy bundle";

    instances = lib.mkOption {
      type = lib.types.attrsOf instanceType;
      default = { };
    };

    trustedRootCAFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    mynix.services.localHttpsProxy = {
      enable = true;
      virtualHosts = lib.mapAttrs' (
        name: inst:
        lib.nameValuePair "givy-${name}.lvh.me" {
          upstream = "127.0.0.1:${toString inst.port}";
        }
      ) cfg.instances;
      inherit (cfg) trustedRootCAFile;
    };

    home-manager.users.${username}.programs.givy.instances = cfg.instances;
  };
}
