{
  pkgs,
  theme,
  ...
}:
let
  fonts = import ../fonts.nix;
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        include = "${theme.srcDrv pkgs}/${theme.extras.fuzzel}";
        font = "${fonts.sans}:size=13";
        icon-theme = theme.gtkIcon;
        width = 40;
        lines = 8;
        horizontal-pad = 20;
        vertical-pad = 12;
        inner-pad = 8;
      };
      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
