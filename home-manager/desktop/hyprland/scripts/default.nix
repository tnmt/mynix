{
  noctalia,
  pkgs,
}:
let
  mkScript =
    name: runtimeInputs:
    pkgs.writeShellApplication {
      inherit name runtimeInputs;
      text = builtins.readFile ./${name};
    };
in
pkgs.symlinkJoin {
  name = "hypr-scripts";
  paths = [
    (mkScript "launch-browser" [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.util-linux
      pkgs.xdg-utils
    ])
    (mkScript "switch-audio" [
      pkgs.coreutils
      pkgs.fuzzel
      pkgs.gawk
      pkgs.gnused
      pkgs.jq
      pkgs.libnotify
      pkgs.pulseaudio
      pkgs.pulsemixer
    ])
    (mkScript "brightness-adjust" [
      pkgs.brightnessctl
      pkgs.coreutils
      noctalia
    ])
    (mkScript "window-pop" [
      pkgs.hyprland
      pkgs.jq
    ])
    (mkScript "ocr-selection" [
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
    ])
    (mkScript "terminal-cwd" [
      pkgs.coreutils
      pkgs.hyprland
      pkgs.jq
      pkgs.procps
    ])
    (mkScript "launch-or-focus" [
      pkgs.hyprland
      pkgs.jq
      pkgs.util-linux
    ])
    (mkScript "toggle-workspace-layout" [
      pkgs.hyprland
      pkgs.jq
      pkgs.libnotify
    ])
    # gsr-kms-server の setcap wrapper は modules/programs/gpu-screen-recorder.nix
    # (NixOS 側) で設定している。
    (mkScript "screen-record" [
      pkgs.coreutils
      pkgs.fuzzel
      pkgs.gpu-screen-recorder
      pkgs.hyprland
      pkgs.hyprpicker
      pkgs.jq
      pkgs.libnotify
      pkgs.slurp
    ])
    (mkScript "toggle-presentation-mode" [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.hyprland
      pkgs.libnotify
      pkgs.util-linux
      pkgs.wlinhibit
      noctalia
    ])
    (mkScript "switch-audio-input" [
      pkgs.fuzzel
      pkgs.gawk
      pkgs.gnused
      pkgs.jq
      pkgs.libnotify
      pkgs.pulseaudio
      pkgs.wiremix
      noctalia
    ])
    (mkScript "open-latest-capture" [
      pkgs.coreutils
      pkgs.findutils
      pkgs.libnotify
      pkgs.xdg-utils
    ])
    (mkScript "toggle-nightlight" [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.hyprland
      pkgs.libnotify
    ])
    (mkScript "quick-reminder" [
      pkgs.coreutils
      pkgs.libnotify
      pkgs.systemd
      noctalia
    ])
  ];
}
