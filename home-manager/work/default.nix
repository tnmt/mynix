{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openstackclient
  ];
}
