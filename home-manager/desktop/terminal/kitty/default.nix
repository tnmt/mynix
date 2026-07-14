{
  pkgs,
  terminal,
  theme,
  ...
}:
let
  themeSrc = theme.srcDrv pkgs;
in
{
  programs.kitty = {
    enable = true;
    font = {
      inherit (terminal.font) name;
      inherit (terminal.font) size;
    };
    extraConfig = "include ${theme.kitty}.conf";
  };

  xdg.configFile."kitty/${theme.kitty}.conf".source = "${themeSrc}/${theme.extras.kitty}";
}
