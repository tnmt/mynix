{ pkgs, theme, ... }:
{
  imports = [
    ./yazi.nix
  ];
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
    thunar
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
    mpc
    cantata
    mmtc
    ncmpcpp

    # remote desktop
    remmina

    # misc
    fastfetch
    cava
    tty-clock
    cmatrix
    htop
    gotop
  ];

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.kdePackages.qtstyleplugin-kvantum;
    };
  };

  xdg.configFile."Kvantum/Tokyo-Night/Tokyo-Night.kvconfig".source =
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/0xsch1zo/Kvantum-Tokyo-Night/main/Kvantum-Tokyo-Night/Kvantum-Tokyo-Night.kvconfig";
      hash = "sha256-kVUFh4i+aQ/tHuyUqoeDeiLNV1zR2Vhf7J2GeU5JLZU=";
    };
  xdg.configFile."Kvantum/Tokyo-Night/Tokyo-Night.svg".source =
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/0xsch1zo/Kvantum-Tokyo-Night/main/Kvantum-Tokyo-Night/Kvantum-Tokyo-Night.svg";
      hash = "sha256-of/VrZxyfKSUSLODoe/GtAOHlpeh43OOG+/lrmrL/gw=";
    };
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Tokyo-Night
  '';

  gtk = {
    enable = true;
    theme = {
      name = theme.gtk;
      package = pkgs.tokyonight-gtk-theme;
    };
    gtk4.theme = null;
    iconTheme = {
      name = theme.gtkIcon;
      package = pkgs.tokyonight-gtk-theme;
    };
  };

}
