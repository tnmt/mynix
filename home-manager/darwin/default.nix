{ pkgs, ... }:
{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [ envchain ];

  programs.home-manager.enable = true;
}
