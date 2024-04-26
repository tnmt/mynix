{ pkgs, lib, inputs, ... } :
let
  hypr-helper = pkgs.callPackage ./hypr-helper {};
in {
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
    systemd.enable = true;
    systemd.variables = [ "--all" ];
  };

  home.packages =
    (with pkgs; [
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
    ])
    ++ [
      inputs.hyprsome.packages.x86_64-linux.default # workspace manager
    ];
}
