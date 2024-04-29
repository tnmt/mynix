{
  inputs,
  username,
  pkgs,
  ...
} : {
  imports = [
    ./hardware-configuration.nix
    ./remotebuild.nix

    ../../modules/core
    ../../modules/desktop
    ../../modules/programs/hyprland.nix
    ../../modules/programs/openssh.nix
    ../../modules/programs/secureboot.nix
    ../../modules/programs/shell.nix
    ../../modules/programs/virtualisation.nix
    ../../modules/programs/xserver.nix

    inputs.nixos-hardware.nixosModules.microsoft-surface-go
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.hardwareClockInLocalTime = true;

  # Don't touch this
  system.stateVersion = "22.11";

  microsoft-surface.surface-control.enable = true;

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "surface-control"
    ];
  };

  services.xserver.xkb.options = "ctrl:nocaps, ";
}
