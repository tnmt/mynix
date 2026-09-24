{
  pkgs,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./settings.nix
    ./hyprdynamicmonitors.nix
    ./noctalia.nix
    ./webapps.nix
    ./zen-browser.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    configType = "lua";
  };

  home.packages = with pkgs; [
    brightnessctl
    bluetui
    fuzzel
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

    (pkgs.symlinkJoin {
      name = "hypr-scripts";
      paths = [
        (pkgs.writeShellScriptBin "launch-or-focus" (builtins.readFile ./scripts/launch-or-focus))
        (pkgs.writeShellScriptBin "launch-browser" (builtins.readFile ./scripts/launch-browser))
        (pkgs.writeShellScriptBin "launch-bluetooth" (builtins.readFile ./scripts/launch-bluetooth))
        (pkgs.writeShellScriptBin "launch-wifi" (builtins.readFile ./scripts/launch-wifi))
        (pkgs.writeShellScriptBin "launch-audio" (builtins.readFile ./scripts/launch-audio))
        (pkgs.writeShellScriptBin "switch-audio" (builtins.readFile ./scripts/switch-audio))
        (pkgs.writeShellScriptBin "brightness-adjust" (builtins.readFile ./scripts/brightness-adjust))
        (pkgs.writeShellScriptBin "launch-webapp" (builtins.readFile ./scripts/launch-webapp))
        (pkgs.writeShellScriptBin "window-pop" (builtins.readFile ./scripts/window-pop))
      ];
    })
  ];

}
