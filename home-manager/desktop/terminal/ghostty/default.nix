{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  themeName = if isDarwin then "TokyoNight Storm" else "tokyonight-storm";
in
{
  programs.ghostty = {
    enable = true;
    package = if isDarwin then null else pkgs.ghostty;
    settings = {
      theme = themeName;
      font-size = 16;
      font-family = [
        "MesloLGS NF"
        "Hiragino Kaku Gothic ProN"
      ];
      copy-on-select = "clipboard";
      window-save-state = "always";
      background-opacity = 0.95;
      background-blur-radius = 20;
      window-padding-x = 5;
      window-padding-y = 5;
      macos-titlebar-style = "transparent";
      term = "xterm-256color";
    };
  };
}
