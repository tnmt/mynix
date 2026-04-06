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
    ./waybar.nix
    ./walker.nix
    ./wofi.nix
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

}
