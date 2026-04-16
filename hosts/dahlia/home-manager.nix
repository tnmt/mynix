{
  ...
}:
let
  services = import ../../home-manager/services;
in
{
  imports = [
    ../../profiles/home-manager/desktop-hyprland.nix
    services."ccpocket-bridge"
  ];
}
