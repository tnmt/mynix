{ pkgs, ... }: {

  imports = [
    ../base
  ];

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    envchain
  ];

  programs.home-manager.enable = true;
}
