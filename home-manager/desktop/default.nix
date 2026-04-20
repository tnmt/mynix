{ pkgs, theme, ... }:
{

  imports = [
    ./vesktop.nix
    ./yazi.nix
  ];
  home.packages = with pkgs; [
    # browser
    brave
    microsoft-edge
    firefox

    # essential
    obsidian
    _1password-gui

    # chat
    slack

    # wine
    #wine-wayland
    #winetricks

    # filer
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

  xdg.configFile."Kvantum/Tokyo-Night-Storm/Tokyo-Night-Storm.kvconfig".source =
    ./kvantum/Tokyo-Night-Storm.kvconfig;
  xdg.configFile."Kvantum/Tokyo-Night-Storm/Tokyo-Night-Storm.svg".source =
    ./kvantum/Tokyo-Night-Storm.svg;
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Tokyo-Night-Storm
  '';

  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans CJK JP";
      size = 10;
    };
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
