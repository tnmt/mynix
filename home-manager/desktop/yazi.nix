{ pkgs, theme, ... }:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
    theme = builtins.fromTOML (builtins.readFile "${themeSrc}/${theme.extras.yazi}");
  };
}
