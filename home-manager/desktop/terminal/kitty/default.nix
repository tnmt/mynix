{ pkgs, ... }:
let
  fontSize = if pkgs.stdenv.isDarwin then 16 else 12;
in
{
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_storm";
    font = {
      name = "MesloLGS NF";
      size = fontSize;
    };
  };
}
