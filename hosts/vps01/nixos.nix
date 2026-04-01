{
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

    inputs.home-manager.nixosModules.home-manager
  ];

  # Boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.supportedFilesystems = [ "lvm2" ];

  # Networking
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall.enable = true;

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
