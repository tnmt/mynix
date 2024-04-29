{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../modules/core
      ../../modules/base
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  programs.zsh.enable = true;
  users.users.tnmt = {
    isNormalUser = true;
    description = "Shinya Tsunematsu";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 2222 ];
  };

  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.secret-key-files = "/etc/remotebuild/cache-priv-key.pem";
  nix.settings.trusted-users = [
    "root"
    "nixremote"
  ];
}

