{
  inputs,
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

    inputs.nixos-hardware.nixosModules.microsoft-surface-go
  ];

  microsoft-surface.surface-control.enable = true;

  users.users.tnmt.extraGroups = [
    "networkmanager"
    "wheel"
    "surface-control"
  ];

  services.xserver.xkb.options = "ctrl:nocaps, ";
}
