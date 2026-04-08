{
  pkgs,
  lib,
  terminal,
  theme,
  ...
}:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.foot ];

  xdg.configFile."foot/foot.ini" = {
    enable = pkgs.stdenv.isLinux;
    text = ''
      [main]
      font=${terminal.font.name}:size=${toString terminal.font.size}

      [mouse]
      hide-when-typing=yes
    ''
    + builtins.readFile "${themeSrc}/${theme.extras.foot}";
  };
}
