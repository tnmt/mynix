{ pkgs, theme, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = theme.bat.name;
    };
    themes = {
      ${theme.bat.name} = {
        src = pkgs.fetchFromGitHub theme.src;
        inherit (theme.bat) file;
      };
    };
  };
}
