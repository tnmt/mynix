# Hyprland desktop home-manager profile
{ ... }:
{
  imports = [
    ./development.nix
    ../../home-manager/desktop/linux-gui.nix
    ../../home-manager/desktop/apps.nix # OS 非依存の個別アプリ (darwin と共有)
    ../../home-manager/desktop/hyprland
    ../../home-manager/desktop/terminal
    ../../home-manager/desktop/voice-input
  ];
}
