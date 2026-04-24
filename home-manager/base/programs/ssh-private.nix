# Renders ~/.ssh/conf.d/private.config via sops-nix template.
# The home-manager ssh module already `Include`s conf.d/private.config,
# so this file being present is enough to wire it up. For WSL hosts,
# profiles/home-manager/wsl.nix clears home-manager sops; those hosts
# get an equivalent system-level template in profiles/nixos/wsl.nix.
#
# role: "client" renders private.config. "server" is a receive-only host
#   that neither needs outbound jump config nor should shadow Tailscale
#   MagicDNS names with LAN-only HostName overrides.
# tier (client only): "laptop" sees the public path to sunflower (github,
#   vps01, sunflower, rdp-sunflower). "workstation" also gets the LAN-hub
#   view (dahlia + obsync + silvea). Keeping LAN topology on workstation
#   only scopes the blast radius: laptops leak nothing beyond "there is a
#   sunflower behind vps01".
{
  config,
  lib,
  sopsShared,
  ...
}:
let
  cfg = config.profiles.sshPrivate;
in
{
  options.profiles.sshPrivate = {
    role = lib.mkOption {
      type = lib.types.enum [
        "client"
        "server"
      ];
      description = ''
        "client": render ~/.ssh/conf.d/private.config from the sops-nix template.
        "server": receive-only host — no private.config, no sops secrets for it.
        No default on purpose: new hosts must declare intent.
      '';
    };
    tier = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "laptop"
          "workstation"
        ]
      );
      default = null;
      description = ''
        Required when role = "client". "laptop" limits the config to the
        public sunflower-facing path. "workstation" adds the LAN hub view
        (dahlia, obsync, silvea). Ignored when role = "server".
      '';
    };
    includeTailscale = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include Tailscale -ts host aliases (requires MagicDNS on this host).";
    };
  };

  config = lib.mkIf (cfg.role == "client") {
    assertions = [
      {
        assertion = cfg.tier != null;
        message = ''profiles.sshPrivate.tier must be set when role = "client"'';
      }
    ];

    # Parent directory for Include target. sops-nix creates parents for
    # template output paths, but this guards the case where ssh reads
    # the config before activation completes.
    home.file.".ssh/conf.d/.keep".text = "";

    sops.secrets = sopsShared.mkSshPrivateSecrets {
      personalSopsFile = ../../../secrets/roles/personal.yaml;
    };

    sops.templates."ssh-private-config" = {
      path = "${config.home.homeDirectory}/.ssh/conf.d/private.config";
      content = sopsShared.mkSshPrivateTemplate {
        lanPrefixPlaceholder = config.sops.placeholder.lan_prefix;
        vps01HostPlaceholder = config.sops.placeholder.vps01_host;
        inherit (cfg) tier includeTailscale;
      };
    };
  };
}
