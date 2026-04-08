{ pkgs, theme, ... }:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  home.packages = [ pkgs.vesktop ];

  # Tokyo Night Storm theme via quickCss
  xdg.configFile."vesktop/settings/quickCss.css".source =
    "${themeSrc}/${theme.extras.discord}";
}
