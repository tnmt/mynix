{ pkgs
, ...
}: {
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


    # container & virtualisation
    docker-compose
    kubectl

    # wine
    #wine-wayland
    #winetricks

    # filer
    xfce.thunar
    yazi
    ranger

    # cui image viewer
    chafa

    # video player
    mpv

    # sound control
    qpwgraph

    # audio tag editor
    kid3

    # music player
    mpc-cli
    cantata
    mmtc
    ncmpcpp

    # misc
    neofetch
    cava
    tty-clock
    cmatrix
    htop
    gotop
  ];

}
