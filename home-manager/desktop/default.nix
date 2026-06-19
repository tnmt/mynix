{ pkgs, theme, ... }:
let
  chromiumFlags = ''
    --enable-wayland-ime
    --wayland-text-input-version=3
  '';
in
{

  imports = [
    ./dropbox.nix
    ./vesktop.nix
    ./vimiv.nix
    ./yazi.nix
  ];
  home.packages = with pkgs; [
    # browser
    brave-origin
    microsoft-edge
    firefox

    # essential
    obsidian
    _1password-gui

    # chat
    slack
    element-desktop

    # wine
    #wine-wayland
    #winetricks

    # filer
    ranger

    # cui image viewer
    chafa

    # gui image viewer
    vimiv-qt
    mcomix

    # screenshot
    flameshot

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

    # cloud storage
    rclone

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

  xdg.configFile = {
    "Kvantum/Tokyo-Night-Storm/Tokyo-Night-Storm.kvconfig".source =
      ./kvantum/Tokyo-Night-Storm.kvconfig;
    "Kvantum/Tokyo-Night-Storm/Tokyo-Night-Storm.svg".source = ./kvantum/Tokyo-Night-Storm.svg;
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Tokyo-Night-Storm
    '';
    "brave-origin-flags.conf".text = chromiumFlags;
    "microsoft-edge-flags.conf".text = chromiumFlags;
    "chromium-flags.conf".text = chromiumFlags;
    "electron-flags.conf".text = chromiumFlags;
    "code-flags.conf".text = chromiumFlags;
    "obsidian-flags.conf".text = chromiumFlags;
    "slack-flags.conf".text = chromiumFlags;
    "discord-flags.conf".text = chromiumFlags;
    "vesktop-flags.conf".text = chromiumFlags;
    "element-desktop-flags.conf".text = chromiumFlags;
    "1password-flags.conf".text = chromiumFlags;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans CJK JP";
      size = 11;
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
