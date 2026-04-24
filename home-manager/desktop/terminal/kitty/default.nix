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
      inherit (terminal.font) name;
      inherit (terminal.font) size;
    };
    extraConfig = "include tokyonight_storm.conf";
  };

  xdg.configFile."kitty/tokyonight_storm.conf".source = "${themeSrc}/${theme.extras.kitty}";
}
