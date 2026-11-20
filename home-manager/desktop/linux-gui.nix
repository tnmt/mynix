{
  lib,
  pkgs,
  theme,
  ...
}:
let
  fonts = import ./fonts.nix;
  tokyonightIconTheme = import ../../packages/tokyonight-icon-theme.nix { inherit lib pkgs; };
  # adw-gtk3 の GTK3 テーマは、ファイルマネージャ等のリストで選択行の文字が
  # 背景の accent と近い明るさになり(コントラスト比 約1.9:1)、列見出しも
  # 本文と背景の中間色で暗い(約3:1)。noctalia が管理する gtk.css とは別に、
  # テーマ側へ追記して補正する。
  adwGtk3 = pkgs.adw-gtk3.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cat >> $out/share/themes/adw-gtk3-dark/gtk-3.0/gtk.css <<'EOF'
      treeview.view:selected,
      treeview.view:selected:focus,
      treeview.view:selected:backdrop,
      iconview:selected,
      iconview:selected:focus {
        color: @accent_fg_color;
      }
      treeview.view header button {
        color: mix(@view_fg_color, @view_bg_color, 0.2);
      }
      EOF
    '';
  });
  chromiumFlags = ''
    --enable-wayland-ime
    --wayland-text-input-version=3
    --enable-features=TouchpadOverscrollHistoryNavigation
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
  # OS 非依存の個別アプリは ./apps.nix に分離し、darwin からも import できるようにした。
  # ここに残すのは Linux 専用のパッケージ・テーマ (qt/gtk/kvantum)・chromium・カーソル等。
  imports = [
    ./dropbox.nix
    ./newsflash.nix
    ./vimiv.nix
    ./zathura.nix
  ];
  home.packages = with pkgs; [
    # browser
    brave-origin
    microsoft-edge
    firefox

    # essential
    obsidian

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
    euphonica
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

  # adw-gtk3 は libadwaita の名前付き色 (window_bg_color 等) を読むので、
  # Noctalia の gtk3 テンプレートが生成する noctalia.css の Tokyo Night Storm が配色になる。
  gtk = {
    enable = true;
    font = {
      name = fonts.sans;
      size = 11;
    };
    theme = {
      name = theme.gtk;
      package = adwGtk3;
    };
    gtk4.theme = null;
    iconTheme = {
      name = theme.gtkIcon;
      package = tokyonightIconTheme;
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
