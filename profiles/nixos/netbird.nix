# NixOS profile: NetBird client enrolment.
# Wraps the boilerplate of `services.netbird.clients.<host>` so the
# host only needs `mynix.profiles.netbird.enable = true;` plus the
# matching sops secret. Defaults assume the self-hosted control plane
# at netbird.tnmt.info; override `managementUrl` to retarget.
{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.profiles.netbird;
  clientName = config.networking.hostName;
in
{
  options.mynix.profiles.netbird = {
    enable = lib.mkEnableOption "NetBird client with project defaults";

    managementUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://netbird.tnmt.info";
      description = "NetBird management/admin URL used by this client.";
    };

    setupKeyFile = lib.mkOption {
      type = lib.types.path;
      default = config.sops.secrets.netbird_setup_key.path;
      defaultText = lib.literalExpression ''
        config.sops.secrets.netbird_setup_key.path
      '';
      description = ''
        Path to a file containing the NetBird setup key. Defaults to the
        sops secret declared by this profile.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.netbird.clients.${clientName} = {
      port = 51820;
      hardened = true;
      openFirewall = true;
      openInternalFirewall = true;
      environment = {
        NB_MANAGEMENT_URL = cfg.managementUrl;
        NB_ADMIN_URL = cfg.managementUrl;
      };
      login = {
        enable = true;
        inherit (cfg) setupKeyFile;
      };
    };

    sops.secrets.netbird_setup_key = { };
  };
}
