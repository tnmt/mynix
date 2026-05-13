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

    setupKeySopsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Override the sops YAML file that holds `netbird_setup_key`.
        Useful when a fleet shares one multi-use key from a common
        secrets file instead of carrying a per-host secret.
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

    # Daemon picks up NB_MANAGEMENT_URL via its systemd unit, but the
    # `netbird-<name>` CLI wrapper does not. Set it in the shell env and
    # whitelist it through sudo so `sudo netbird-<name> login` targets
    # the self-hosted control plane without an explicit flag.
    environment.variables = {
      NB_MANAGEMENT_URL = cfg.managementUrl;
      NB_ADMIN_URL = cfg.managementUrl;
    };

    security.sudo-rs.extraConfig = ''
      Defaults env_keep += "NB_MANAGEMENT_URL NB_ADMIN_URL"
    '';

    sops.secrets.netbird_setup_key = lib.optionalAttrs (cfg.setupKeySopsFile != null) {
      sopsFile = cfg.setupKeySopsFile;
    };
  };
}
