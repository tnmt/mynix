{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/server
    ../../home-manager/desktop
    ../../home-manager/desktop/hyprland
    ../../home-manager/desktop/terminal/alacritty
  ];
}
