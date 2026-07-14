{
  pkgs,
  theme,
  ...
}:
let
  themeSrc = theme.srcDrv pkgs;
in
{
  programs.eza = {
    enable = true;
  };

  xdg.configFile."eza/theme.yml".source = "${themeSrc}/${theme.extras.eza}";
}
