{ pkgs
, ...
}: {

  imports = [
    ../base
    ./terminal
  ];

  home = {
    username = "tnmt";
    homeDirectory = "/home/tnmt";

    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    # browser
    brave

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
  ];

  programs.home-manager.enable = true;
}
