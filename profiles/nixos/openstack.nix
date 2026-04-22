# Base NixOS profile for OpenStack instances (qcow2 images booted on Nova).
# Inherits cloud-init / serial / fstab from nixpkgs' openstack-config module
# and layers on the shared mynix core.
{
  lib,
  modulesPath,
  pkgs,
  username,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/openstack-config.nix"

    ../../modules/nixos/core
    ../../modules/services/openssh.nix
  ];

  # cloud-init (bundled with openstack-config) sets the hostname from
  # OpenStack metadata at boot; clear the NixOS-managed value so it
  # doesn't fight the runtime source.
  networking.hostName = lib.mkForce "";

  users.users."${username}".extraGroups = [ "wheel" ];

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "25.05";
}
