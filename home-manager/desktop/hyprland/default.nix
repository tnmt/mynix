{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./mako.nix
    ./settings.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./kanshi.nix
    ./waybar.nix
    ./walker.nix
    ./swayosd.nix
    ./wlogout.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
  };

  home.packages = with pkgs; [
    brightnessctl
    bluetui
    swayosd
    grim
    slurp
    hyprpicker
    pavucontrol
    pulseaudio
    pamixer
    playerctl
    wiremix
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
        (pkgs.writeShellScriptBin "switch-audio" (builtins.readFile ./scripts/switch-audio))
        (pkgs.writeShellScriptBin "launch-settings" (builtins.readFile ./scripts/launch-settings))
        (pkgs.writeShellScriptBin "launch-webapp" (builtins.readFile ./scripts/launch-webapp))
        (pkgs.writeShellScriptBin "window-pop" (builtins.readFile ./scripts/window-pop))
      ];
    })
  ];

  systemd.user.services.swayosd = {
    Unit = {
      Description = "SwayOSD OSD server";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.desktopEntries.amazon-music = {
    name = "Amazon Music";
    comment = "Amazon Music Web App";
    exec = "launch-webapp https://music.amazon.co.jp/";
    icon = builtins.toString (pkgs.fetchurl {
      url = "https://www.google.com/s2/favicons?domain=music.amazon.co.jp&sz=128";
      name = "amazon-music-icon.png";
      hash = "sha256-9RKGPm7JTy3vzzqnBQjITtcWZVvyuUze6Ms/rzMRCSc=";
    });
    terminal = false;
    categories = [ "Audio" "Music" ];
  };

  xdg.desktopEntries.wiremix = {
    name = "Wiremix";
    comment = "PipeWire TUI mixer";
    exec = "alacritty --class tui-float -e wiremix -v output";
    icon = "audio-volume-high";
    terminal = false;
    categories = [ "Audio" "Mixer" ];
  };

}
