{ theme, ... }:
{
  xdg.configFile = {
    "vimiv/vimiv.conf".text = ''
      [GENERAL]
      style = tokyonight-storm
    '';

    "vimiv/styles/tokyonight-storm".text = ''
      [STYLE]
      base00 = ${theme.background}
      base01 = ${theme.bg_dark}
      base02 = ${theme.bg_highlight}
      base03 = ${theme.comment}
      base04 = ${theme.color7}
      base05 = ${theme.foreground}
      base06 = ${theme.foreground}
      base07 = #ffffff
      base08 = ${theme.color1}
      base09 = ${theme.orange}
      base0a = ${theme.color3}
      base0b = ${theme.color2}
      base0c = ${theme.color6}
      base0d = ${theme.color4}
      base0e = ${theme.color5}
      base0f = ${theme.magenta}
    '';
  };
}
