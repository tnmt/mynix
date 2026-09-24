{
  pkgs,
  ...
}:
{
  imports = [
    ./keybinds.nix
    ./settings.nix
    ./hyprdynamicmonitors.nix
    ./hyprsunset.nix
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
        (pkgs.writeShellScriptBin "launch-browser" (builtins.readFile ./scripts/launch-browser))
        (pkgs.writeShellScriptBin "switch-audio" (builtins.readFile ./scripts/switch-audio))
        (pkgs.writeShellScriptBin "brightness-adjust" (builtins.readFile ./scripts/brightness-adjust))
        (pkgs.writeShellScriptBin "window-pop" (builtins.readFile ./scripts/window-pop))
        (pkgs.writeShellApplication {
          name = "ocr-selection";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.grim
            pkgs.hyprpicker
            pkgs.libnotify
            pkgs.slurp
            (pkgs.tesseract.override {
              enableLanguages = [
                "eng"
                "jpn"
              ];
            })
            pkgs.wl-clipboard
          ];
          text = builtins.readFile ./scripts/ocr-selection;
        })
        (pkgs.writeShellApplication {
          name = "terminal-cwd";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.hyprland
            pkgs.jq
            pkgs.procps
          ];
          text = builtins.readFile ./scripts/terminal-cwd;
        })
      ];
    })
  ];

}
