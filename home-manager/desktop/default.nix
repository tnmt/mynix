{
  lib,
  pkgs,
  theme,
  ...
}:
let
  fonts = import ./fonts.nix;
  chromiumFlags = ''
    --enable-wayland-ime
    --wayland-text-input-version=3
  '';
  chromiumApps = [
    "brave-origin"
    "microsoft-edge"
    "chromium"
    "electron"
    "code"
    "obsidian"
    "slack"
    "discord"
    "vesktop"
    "element-desktop"
    "1password"
  ];
in
{

  imports = [
    ./dropbox.nix
    ./vesktop.nix
    ./vimiv.nix
    ./yazi.nix
    ./zathura.nix
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

    # pdf
    pdfarranger

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
  }
  // lib.genAttrs (map (app: "${app}-flags.conf") chromiumApps) (_: {
    text = chromiumFlags;
  });

  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
  };

  gtk = {
    enable = true;
    font = {
      name = fonts.sans;
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

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

}
