# Hyprland desktop home-manager profile
{ ... }:
{
  imports = [
    ../../../home-manager/base-nixos
    ../../../home-manager/devel
    ../../../home-manager/desktop
    ../../../home-manager/desktop/hyprland
    ../../../home-manager/desktop/terminal
    ../../../home-manager/desktop/voice-input
  ];
}
