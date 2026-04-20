{
  pkgs,
  terminal,
  theme,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  programs.ghostty = {
    enable = true;
    package = if isDarwin then null else pkgs.ghostty;
    settings = {
      theme = "tokyonight_storm";
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

  xdg.configFile."ghostty/themes/tokyonight_storm".source = "${themeSrc}/${theme.extras.ghostty}";
}
