{ pkgs, theme, ... }:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  home.packages = [ pkgs.vesktop ];

  # Tokyo Night Storm theme
  xdg.configFile."vesktop/themes/tokyonight-storm.css".source = "${themeSrc}/${theme.extras.discord}";
}
