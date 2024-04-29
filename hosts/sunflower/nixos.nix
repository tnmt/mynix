{
  inputs,
  username,
  pkgs,
  ...
} : {
  imports = [
    ./hardware-configuration.nix
    ./lanzaboote.nix
    ./remotebuild.nix

    ../../modules/core
    ../../modules/desktop
    ../../modules/nixos
    ../../modules/programs/hyprland.nix
    ../../modules/programs/openssh.nix
    ../../modules/programs/shell.nix
    ../../modules/programs/virtualisation.nix
    ../../modules/programs/xserver.nix

    inputs.nixos-hardware.nixosModules.microsoft-surface-go
  ];

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
