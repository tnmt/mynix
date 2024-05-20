{ ... }: {
  imports = [
    ../../home-manager/base
    ../../home-manager/desktop
    ../../home-manager/desktop/terminal
    ../../home-manager/desktop/hyprland
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1280, 0x0, 2"
      "DP-1, 3840x2160@60, 1920x0, 2"
    ];
    env = [
      #"GDK_DPI_SCALE, 1.0"
      #"QT_SCALE_FACTOR, 1.0"
      #"QT_AUTO_SCREEN_SCALE_FACTOR, 0"
    ];
    input = {
      touchpad.natural_scroll = true;
    };
    input.kb_layout = "us";
  };
}
