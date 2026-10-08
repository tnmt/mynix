{
  pkgs,
  terminal,
  theme,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  themeSrc = theme.srcDrv pkgs;
  fonts = import ../../fonts.nix;
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
        fonts.sans
      ];
      font-codepoint-map = [
        "U+3000-U+30FF=${fonts.sans}"
        "U+4E00-U+9FFF=${fonts.sans}"
        "U+FF00-U+FFEF=${fonts.sans}"
      ];
      copy-on-select = "clipboard";
      window-save-state = "always";
      background-opacity = 0.95;
      background-blur-radius = 20;
      window-padding-x = 5;
      window-padding-y = 5;
      macos-titlebar-style = "transparent";
      term = "xterm-256color";
      shell-integration-features = "ssh-env";
      # デフォルトの ctrl+enter=toggle_fullscreen を解除し、アプリ側(herdr等)へキーを渡す
      keybind = [
        "ctrl+enter=unbind"
      ];
    };
  };

  xdg.configFile."ghostty/themes/${theme.ghostty}".source = "${themeSrc}/${theme.extras.ghostty}";
}
