{
  pkgs,
  theme,
  ...
}:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  programs.eza = {
    enable = true;
  };

  xdg.configFile."eza/theme.yml".source = "${themeSrc}/${theme.extras.eza}";
}
