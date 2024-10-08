{
  inputs,
  username,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/desktop
    ../../modules/remotebuild
    ../../modules/programs/bluetooth.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/mpd.nix
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland
        '';
        user = username;
      };
    };
  };
}
