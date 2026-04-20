{
  pkgs,
  terminal,
  theme,
  ...
}:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = terminal.font.name;
      size = terminal.font.size;
    };
    extraConfig = "include tokyonight_storm.conf";
  };

  xdg.configFile."kitty/tokyonight_storm.conf".source = "${themeSrc}/${theme.extras.kitty}";
}
