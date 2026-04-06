{ pkgs, terminal, theme, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  programs.ghostty = {
    enable = true;
    package = if isDarwin then null else pkgs.ghostty;
    settings = {
      theme = theme.ghostty;
      font-size = terminal.font.size;
      font-family = [
        terminal.font.name
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
