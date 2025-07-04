{ pkgs, ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/darwin
    ../../home-manager/desktop/terminal/alacritty
  ];

  home.packages = with pkgs; [
    openstackclient
  ];
}
