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

    # dev
    vscode

    # essential
    obsidian
    _1password-gui

    # chat
    slack

    # container & virtualisation
    docker-compose
    kubectl

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
    pkgs.runCommand "tokyo-night-storm-kvconfig" { }
      ''
        ${pkgs.gnused}/bin/sed \
          -e 's/#1a1b26/#24283b/g' \
          -e 's/#16161e/#1f2335/g' \
          -e 's/#15161E/#1f2335/g' \
          -e 's/#1d1f2b/#292e42/g' \
          -e 's/dark.color=black/dark.color=#1f2335/g' \
          -e 's/#191919/#24283b/g' \
          -e 's/#3e415c/#414868/g' \
          ${
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/0xsch1zo/Kvantum-Tokyo-Night/main/Kvantum-Tokyo-Night/Kvantum-Tokyo-Night.kvconfig";
              hash = "sha256-kVUFh4i+aQ/tHuyUqoeDeiLNV1zR2Vhf7J2GeU5JLZU=";
            }
          } > $out
      '';
  xdg.configFile."Kvantum/Tokyo-Night-Storm/Tokyo-Night-Storm.svg".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/0xsch1zo/Kvantum-Tokyo-Night/main/Kvantum-Tokyo-Night/Kvantum-Tokyo-Night.svg";
    hash = "sha256-of/VrZxyfKSUSLODoe/GtAOHlpeh43OOG+/lrmrL/gw=";
  };
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
