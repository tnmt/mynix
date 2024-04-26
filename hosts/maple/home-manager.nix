{ ... }: {
  imports = [
    ../../home/base
    ../../home/desktop
  ];

  wayland.windowManager.hyprland.settings = {
    monitor=",highres,auto,1.5";
    workspace = [
      "1,monitor:DP-1"
      "2,monitor:DP-1"
      "3,monitor:DP-1"
      "4,monitor:DP-1"
      "5,monitor:DP-1"
      "6,monitor:DP-1"
      "7,monitor:DP-1"
      "8,monitor:DP-1"
      "9,monitor:DP-1"
      "10,monitor:DP-1"
    ];
    input.kb_layout = "us";
  };

}
