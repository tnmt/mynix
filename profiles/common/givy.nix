# Shared givy bundle: wires per-instance givy user services to a Caddy
# reverse proxy at https://givy-<name>.lvh.me, with optional CA trust
# for the local root. OS entry points at profiles/{nixos,darwin}/givy.nix
# import this together with the matching local-https-proxy backend.
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
  options.mynix.profiles.givy = {
    enable = lib.mkEnableOption "givy + Caddy reverse proxy bundle";

    instances = lib.mkOption {
      type = lib.types.attrsOf instanceType;
      default = { };
      example = lib.literalExpression ''
        {
          github = { root = "/home/me/ghq/github.com"; port = 6271; };
          work   = { root = "/home/me/work";           port = 6272; };
        }
      '';
    };

    trustedRootCAFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Pre-extracted Caddy local root CA (PEM) added to
        `security.pki.certificateFiles`. See
        `local-https-proxy-export-ca` for the bootstrap procedure.
      '';
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
