# Renders ~/.ssh/conf.d/private.config via sops-nix template.
# The home-manager ssh module already `Include`s conf.d/private.config,
# so this file being present is enough to wire it up. For WSL hosts,
# profiles/home-manager/wsl.nix clears home-manager sops; those hosts
# get an equivalent system-level template in profiles/nixos/wsl.nix.
{
  config,
  lib,
  ...
}:
let
  cfg = config.profiles.sshPrivate;
in
{
  options.profiles.sshPrivate.includeTailscale = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Include Tailscale -ts host aliases (requires MagicDNS on this host).";
  };

  config = {
    # Parent directory for Include target. sops-nix creates parents for
    # template output paths, but this guards the case where ssh reads
    # the config before activation completes.
    home.file.".ssh/conf.d/.keep".text = "";

    sops.secrets = {
      lan_prefix = {
        sopsFile = ../../../secrets/roles/personal.yaml;
        key = "lan_prefix";
      };
      vps01_host = {
        sopsFile = ../../../secrets/roles/personal.yaml;
        key = "vps01_host";
      };
    };

    sops.templates."ssh-private-config" = {
      path = "${config.home.homeDirectory}/.ssh/conf.d/private.config";
      content = import ../../../profiles/common/ssh-private-content.nix {
        lanPrefix = config.sops.placeholder.lan_prefix;
        vps01Host = config.sops.placeholder.vps01_host;
        inherit (cfg) includeTailscale;
      };
    };
  };
}
