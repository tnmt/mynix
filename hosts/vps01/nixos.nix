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

  ];

  # Boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.supportedFilesystems = [ "lvm2" ];

  # Networking
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall.enable = true;

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
      trusted_ip_home = { };
      trusted_ip_homelab = { };
      trusted_ip_office = { };
    };
    templates."cloudflare-credentials" = {
      content = ''
        CLOUDFLARE_EMAIL=${config.sops.placeholder.cloudflare_email}
        CLOUDFLARE_API_KEY=${config.sops.placeholder.cloudflare_api_key}
      '';
    };
    templates."nginx-trusted-ips" = {
      content = ''
        allow ${config.sops.placeholder.trusted_ip_home};
        allow ${config.sops.placeholder.trusted_ip_homelab};
        allow ${config.sops.placeholder.trusted_ip_office};
        allow 100.64.0.0/10;
        deny all;
      '';
      owner = "nginx";
    };
    templates."firewall-trusted-ips" = {
      content = ''
        ${config.sops.placeholder.trusted_ip_home}
        ${config.sops.placeholder.trusted_ip_homelab}
        ${config.sops.placeholder.trusted_ip_office}
      '';
    };
    templates."fail2ban-ignoreip" = {
      content = "${config.sops.placeholder.trusted_ip_home} ${config.sops.placeholder.trusted_ip_homelab} ${config.sops.placeholder.trusted_ip_office} 100.64.0.0/10";
    };
  };

  users.users."${username}".extraGroups = [
    "wheel"
    "networkmanager"
  ];

  home-manager.users."${username}" = import ./home-manager.nix;
}
