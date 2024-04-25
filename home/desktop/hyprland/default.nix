{ pkgs, lib, ... } : {
  imports = [
    ./dunst.nix
    ./keybinds.nix
    ./settings.nix
    ./swaylock.nix
    ./wofi.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home.packages =
    with pkgs; [
      brightnessctl # screen brightness
      grimblast # screenshot
      hyprpicker # color picker
      pamixer # pulseaudio mixer
      playerctl # media player control
      swww # wallpaper
      wayvnc # vnc server
      wev # key event watcher
      wf-recorder # screen recorder
      wl-clipboard # clipboard manager
    ];
}
