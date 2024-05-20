{ pkgs, lib, inputs, ... } :
{
  imports = [
    ./dunst.nix
    ./keybinds.nix
    ./settings.nix
    ./swaylock.nix
    ./wofi.nix
    #./waybar.nix

    inputs.hyprland.homeManagerModules.default
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
      pulseaudio # pulseaudio
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

  home.file = {
    "abstract-purple-background.jpg" = {
      target = ".config/hypr/wallpaper/abstract-purple-background.jpg";
      source = pkgs.fetchurl {
        url = "https://img.freepik.com/free-photo/abstract-purple-background-gradient-transition-generative-ai_169016-30644.jpg";
        sha256 = "sha256-bf4REJJ/2ZsBwrq3/SLOua3dwkgd2rQaJVsZPpEL9y4=";
      };
    };
    "abstract-black-background.jpg" = {
      target = ".config/hypr/wallpaper/abstract-black-background.jpg";
      source = pkgs.fetchurl {
        url = "https://www.baltana.com/files/wallpapers-13/Abstract-Black-Background-HD-Desktop-Wallpapers-34039.jpg";
        sha256 = "sha256-9SsFxvfZqwq2PhQhC5WpAMEUWv+yR59sqpZROySf/2k=";
      };
    };
  };
}
