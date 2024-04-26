{
  inputs,
  ...
} : {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
    ./lanzaboote.nix
    ./remotebuild.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-go
    inputs.xremap-flake.nixosModules.default
  ];

  microsoft-surface.surface-control.enable = true;

  users.users.tnmt.extraGroups = [
    "networkmanager"
    "wheel"
    "docker"
    "surface-control"
  ];

  services.xserver.xkbOptions = "ctrl:nocaps, ";

  services.xremap = {
    userName = "tnmt";
    serviceMode = "user";
    config = {
       modmap = [
         {
           # CapsLock to Ctrl
           name = "CapsLock is dead";
           remap = {
             CapsLock = "Ctrl_L";
           };
         }
       ];
    };
  };

  programs.hyprland = {
    enable = true;
  };

  networking.hostName = "sunflower";
}
