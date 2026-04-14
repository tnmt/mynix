{ pkgs, theme, ... }:
{
  xdg.configFile."swayosd/style.css".text = ''
    @define-color background-color ${theme.background};
    @define-color border-color ${theme.color8};
    @define-color label ${theme.foreground};
    @define-color image ${theme.foreground};
    @define-color progress ${theme.accent};
  '';
}
