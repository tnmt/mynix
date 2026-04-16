{
  ...
}:
let
  services = import ../../home-manager/services;
in
{
  imports = [
    # Shared desktop profile for the Hyprland workstation.
    ../../profiles/home-manager/desktop-hyprland.nix

    # Host-local user services.
    services."ccpocket-bridge"
  ];
}
