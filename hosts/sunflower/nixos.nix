{
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/core
    ../../modules/programs/shell.nix
    ../../modules/programs/openssh.nix

    inputs.nixos-wsl.nixosModules.default
  ];

  boot.loader.grub.enable = false;

  fileSystems."/" = {
    device = "/dev/sdd";
    fsType = "ext4";
  };

  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [ "wheel" ];
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";

  wsl.defaultUser = "${username}";

  # WSL uses Windows networking, no need for NetworkManager or wpa_supplicant
  networking.networkmanager.enable = lib.mkForce false;

  services.openssh.ports = [ 2222 ];
}
