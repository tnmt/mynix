{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./mako.nix
    ./settings.nix
    ./swaylock.nix
    ./waybar.nix
    ./walker.nix
    ./wofi.nix

    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
  };

  home.packages = with pkgs; [
    brightnessctl
    bluetui
    grim
    slurp
    hyprpicker
    impala
    pavucontrol
    pulseaudio
    pamixer
    playerctl
    swww
    wayvnc
    wev
    wf-recorder
    wl-clipboard
    wlogout

    (pkgs.symlinkJoin {
      name = "hypr-scripts";
      paths = [
        (pkgs.writeShellScriptBin "launch-or-focus" (builtins.readFile ./scripts/launch-or-focus))
        (pkgs.writeShellScriptBin "launch-browser" (builtins.readFile ./scripts/launch-browser))
        (pkgs.writeShellScriptBin "launch-bluetooth" (builtins.readFile ./scripts/launch-bluetooth))
        (pkgs.writeShellScriptBin "launch-wifi" (builtins.readFile ./scripts/launch-wifi))
        (pkgs.writeShellScriptBin "launch-audio" (builtins.readFile ./scripts/launch-audio))
        (pkgs.writeShellScriptBin "launch-walker" (builtins.readFile ./scripts/launch-walker))
      ];
    })
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
