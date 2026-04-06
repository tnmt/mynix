{ pkgs, theme, ... }:
let
  fontSize = if pkgs.stdenv.isDarwin then 16 else 12;
in
{
  programs.kitty = {
    enable = true;
    themeFile = theme.kitty;
    font = {
      name = "MesloLGS NF";
      size = fontSize;
    };
  };
}
