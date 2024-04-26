{ pkgs
, ...
}: {

  imports = [
    ../base
    ./terminal
    ./hyprland
  ];

  home = {
    username = "tnmt";
    homeDirectory = "/home/tnmt";

    stateVersion = "22.11";
  };

  home.packages = with pkgs; [
    # browser
    brave
    microsoft-edge
    chromium
    firefox

    # dev
    vscode

    # essential
    obsidian
    _1password-gui

    # chat
    discord
    slack

    # misc
    neofetch

    # container & virtualisation
    docker-compose
    kubectl

    # wine
    wineWowPackages.stable
    winetricks
  ];

  programs.home-manager.enable = true;
}
