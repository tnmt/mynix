{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/programs/shell.nix
    ../../modules/programs/openssh.nix
    ../../modules/selfhosted

    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  # Boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.supportedFilesystems = [ "lvm2" ];

  # Networking
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall.enable = true;


  # PHP-FPM pools for web apps
  services.phpfpm.pools = {
    freshrss = {
      user = "nginx";
      group = "nginx";
      phpPackage = pkgs.php83;
      settings = {
        "listen" = "/run/phpfpm/freshrss.sock";
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "pm" = "dynamic";
        "pm.max_children" = 10;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 5;
      };
    };
    wallabag = {
      user = "nginx";
      group = "nginx";
      phpPackage = pkgs.php83;
      settings = {
        "listen" = "/run/phpfpm/wallabag.sock";
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "pm" = "dynamic";
        "pm.max_children" = 10;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 5;
      };
    };
    ***REDACTED*** = {
      user = "nginx";
      group = "nginx";
      phpPackage = pkgs.php83;
      settings = {
        "listen" = "/run/phpfpm/***REDACTED***.sock";
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "pm" = "dynamic";
        "pm.max_children" = 10;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 5;
      };
    };
  };

  # Secrets
  sops = {
    defaultSopsFile = ../../secrets/vps01.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets = {
      couchdb_admin_password = { };
      cloudflare_api_key = { };
      cloudflare_email = { };
      forgejo_lfs_jwt_secret = {
        owner = "forgejo";
      };
      forgejo_db_password = {
        owner = "forgejo";
      };
    };
    templates."cloudflare-credentials" = {
      content = ''
        CLOUDFLARE_EMAIL=${config.sops.placeholder.cloudflare_email}
        CLOUDFLARE_API_KEY=${config.sops.placeholder.cloudflare_api_key}
      '';
    };
  };

  # User
  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # home-manager as NixOS module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs username;
      theme = (import ../../themes) "tokyonight-storm";
      pkgs-stable = pkgs;
    };
    users."${username}" = import ./home-manager.nix;
  };
}
