{ pkgs, ... }: {

  imports = [
    ../base
    ../desktop
  ];

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    envchain
  ];

  programs.home-manager.enable = true;
}
