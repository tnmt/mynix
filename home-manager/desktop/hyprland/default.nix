{
  config,
  pkgs,
  ...
}:
let
  hyprScripts = import ./scripts {
    inherit pkgs;
    noctalia = config.programs.noctalia.package;
  };
in
{
  imports = [
    ./fuzzel.nix
    ./keybinds.nix
    ./settings.nix
    ./hyprdynamicmonitors.nix
    ./hyprsunset.nix
    ./noctalia.nix
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
    findutils
    glib
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
    util-linux
    xdg-utils

    hyprScripts
  ];

}
