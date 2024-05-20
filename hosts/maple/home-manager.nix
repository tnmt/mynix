{ ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/desktop
    ../../home-manager/desktop/terminal
    ../../home-manager/desktop/hyprland
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [ "DP-1, 3840x2160@60, 0x0, 2" ];
    env = [ "GDK_SCALE, 2" ];
    input.kb_layout = "us";
  };
}
