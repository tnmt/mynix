{ pkgs, ... }: {

  imports = [
    ../base
    ../desktop/terminal
  ];

  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    envchain
  ];

  programs.home-manager.enable = true;
}
