# Base NixOS profile for OpenStack instances (qcow2 images booted on Nova).
# Inherits cloud-init / serial / fstab from nixpkgs' openstack-config module
# and layers on the shared mynix core (sans sops / home-manager).
{
  modulesPath,
  pkgs,
  username,
  ...
}:
{
  imports = [
    # Also supplies cloud-init which sets the hostname from OpenStack
    # metadata at boot, so we intentionally skip core/network.nix here.
    "${modulesPath}/virtualisation/openstack-config.nix"

    ../../modules/nixos/core/firewall.nix
    ../../modules/nixos/core/i18n.nix
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/user.nix
    ../../modules/services/openssh.nix
  ];

  programs.zsh.enable = true;

  users.users."${username}".extraGroups = [ "wheel" ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "25.05";
}
