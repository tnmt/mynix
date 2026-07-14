{ pkgs, theme, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = theme.bat.name;
    };
    themes = {
      ${theme.bat.name} = {
        src = theme.srcDrv pkgs;
        inherit (theme.bat) file;
      };
    };
  };
}
