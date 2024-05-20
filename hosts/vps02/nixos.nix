{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/programs/shell.nix
    ../../modules/programs/openssh.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.openssh = {
    ports = [ 2222 ];
  };

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
}
