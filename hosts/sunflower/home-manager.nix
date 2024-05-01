{ ... }: {
  imports = [
    ../../home-manager/base
    ../../home-manager/desktop
    ../../home-manager/desktop/terminal
    ../../home-manager/desktop/hyprland
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1280, 0x0, 1"
      "DP-1, 3840x2160@60, 1920x0, 2"
    ];
    env = [
      "GDK_SCALE, 2"
    ];
    env = [
      "GDK_DPI_SCALE, 0.7"
    ];
    input = {
      touchpad.natural_scroll = true;
    };
    workspace = [
      "1,monitor:eDP-1"
      "2,monitor:eDP-1"
      "3,monitor:eDP-1"
      "4,monitor:eDP-1"
      "5,monitor:eDP-1"
      "6,monitor:eDP-1"
      "7,monitor:eDP-1"
      "8,monitor:eDP-1"
      "9,monitor:eDP-1"
      "10,monitor:eDP-1"
    ];
    input.kb_layout = "us";
  };
}
