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
    findutils
    fuzzel
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
        (pkgs.writeShellApplication {
          name = "launch-or-focus";
          runtimeInputs = [
            pkgs.hyprland
            pkgs.jq
            pkgs.util-linux
          ];
          text = builtins.readFile ./scripts/launch-or-focus;
        })
        (pkgs.writeShellApplication {
          name = "toggle-workspace-layout";
          runtimeInputs = [
            pkgs.hyprland
            pkgs.jq
            pkgs.libnotify
          ];
          text = builtins.readFile ./scripts/toggle-workspace-layout;
        })
        # gsr-kms-server の setcap wrapper は modules/programs/gpu-screen-recorder.nix
        # (NixOS 側) で設定している。
        (pkgs.writeShellApplication {
          name = "screen-record";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.fuzzel
            pkgs.gpu-screen-recorder
            pkgs.hyprland
            pkgs.hyprpicker
            pkgs.jq
            pkgs.libnotify
            pkgs.slurp
          ];
          text = builtins.readFile ./scripts/screen-record;
        })
        (pkgs.writeShellApplication {
          name = "toggle-presentation-mode";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.gnugrep
            pkgs.hyprland
            pkgs.libnotify
            pkgs.util-linux
            pkgs.wlinhibit
          ];
          text = builtins.readFile ./scripts/toggle-presentation-mode;
        })
        (pkgs.writeShellApplication {
          name = "switch-audio-input";
          runtimeInputs = [
            pkgs.fuzzel
            pkgs.gawk
            pkgs.jq
            pkgs.libnotify
            pkgs.pulseaudio
            pkgs.gnused
          ];
          text = builtins.readFile ./scripts/switch-audio-input;
        })
        (pkgs.writeShellApplication {
          name = "open-latest-capture";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.findutils
            pkgs.libnotify
            pkgs.xdg-utils
          ];
          text = builtins.readFile ./scripts/open-latest-capture;
        })
        (pkgs.writeShellApplication {
          name = "toggle-nightlight";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.gnugrep
            pkgs.hyprland
            pkgs.libnotify
          ];
          text = builtins.readFile ./scripts/toggle-nightlight;
        })
        (pkgs.writeShellApplication {
          name = "quick-reminder";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.libnotify
            pkgs.systemd
          ];
          text = builtins.readFile ./scripts/quick-reminder;
        })
      ];
    })
  ];

}
