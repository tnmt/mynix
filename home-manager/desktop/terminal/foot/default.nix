{ lib, theme, ... }:
let
  # foot uses hex without '#' prefix
  strip = s: lib.removePrefix "#" s;
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "MesloLGS NF:size=12";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors-dark = {
        alpha = 0.8;

        foreground = strip theme.foreground;
        background = strip theme.background;
        selection-foreground = strip theme.selection_foreground;
        selection-background = strip theme.selection_background;
        urls = "73daca";

        regular0 = strip theme.color0;
        regular1 = strip theme.color1;
        regular2 = strip theme.color2;
        regular3 = strip theme.color3;
        regular4 = strip theme.color4;
        regular5 = strip theme.color5;
        regular6 = strip theme.color6;
        regular7 = strip theme.color7;

        bright0 = strip theme.color8;
        bright1 = strip theme.color9;
        bright2 = strip theme.color10;
        bright3 = strip theme.color11;
        bright4 = strip theme.color12;
        bright5 = strip theme.color13;
        bright6 = strip theme.color14;
        bright7 = strip theme.color15;

        "16" = "ff9e64";
        "17" = "db4b4b";
      };
    };
  };
}
