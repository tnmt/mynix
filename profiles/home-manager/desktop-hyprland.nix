# Hyprland desktop home-manager profile
{ ... }:
{
  imports = [
    ./development.nix
    ../../home-manager/desktop
    ../../home-manager/desktop/hyprland
    ../../home-manager/desktop/terminal
    ../../home-manager/desktop/voice-input
  ];
}
