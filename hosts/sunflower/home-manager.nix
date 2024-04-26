{ ... }: {
  imports = [
    ../../home/base
    ../../home/desktop
  ];

  wayland.windowManager.hyprland.settings = {
    monitor=",highres,auto,1.6";
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
