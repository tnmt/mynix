{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
  };
  xdg.configFile."waybar/style.css" = { source = ./waybar/style.css; };
  xdg.configFile."waybar/config" = { source = ./waybar/config; };
}
