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

    # misc
    neofetch

    # container & virtualisation
    docker-compose
    kubectl

    # wine
    wine-wayland
    winetricks

    # filer
    xfce.thunar

    # video player
    mpv

    # music player
    mpc-cli
    cantata
  ];

}
