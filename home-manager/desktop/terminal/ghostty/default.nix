{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  themeName = if isDarwin then "TokyoNight Storm" else "tokyonight-storm";
in
{
  # Ghostty config via xdg.configFile (no home-manager module yet)
  xdg.configFile."ghostty/config".text = ''
    theme = ${themeName}
    font-size = 16
    font-family = MesloLGS NF
    font-family = Hiragino Kaku Gothic ProN
    copy-on-select = clipboard
    window-save-state = always
    background-opacity = 0.95
    background-blur-radius = 20
    window-padding-x = 5
    window-padding-y = 5
    macos-titlebar-style = transparent
    term = xterm-256color
  '';
}
