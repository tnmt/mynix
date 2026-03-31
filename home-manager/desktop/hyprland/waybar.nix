{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };
  xdg.configFile."waybar/style.css" = {
    source = ./waybar/style.css;
  };
  xdg.configFile."waybar/config" = {
    source = ./waybar/config;
  };
}
