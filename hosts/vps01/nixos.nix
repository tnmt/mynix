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
    ../../modules/services/mackerel-agent.nix
    ./services

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
      trusted_ip_home = { };
      trusted_ip_homelab = { };
      trusted_ip_office = { };
    };
    templates."firewall-trusted-ips" = {
      content = ''
        ${config.sops.placeholder.trusted_ip_home}
        ${config.sops.placeholder.trusted_ip_homelab}
        ${config.sops.placeholder.trusted_ip_office}
      '';
    };
  };

  users.users."${username}".extraGroups = [
    "wheel"
    "networkmanager"
  ];

  home-manager.users."${username}" = import ./home-manager.nix;
}
