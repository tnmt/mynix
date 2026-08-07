{
  lib,
  pkgs,
  theme,
  ...
}:
let
  fonts = import ./fonts.nix;
  # nixpkgs で 'tokyonight-gtk-theme' が削除されたため (gtk-engine-murrine 依存の GTK2 エンジンが
  # unmaintained につき削除). GTK2/murrine 依存部分を除き、上流リポジトリから直接ビルドする。
  # ref: https://github.com/NixOS/nixpkgs/commit/659574ec9405f015bfdf35bd258e586b00d9f7fc
  tokyonightGtkTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "tokyonight-gtk-theme";
    version = "0-unstable-2025-10-23";

    src = pkgs.fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Tokyonight-GTK-Theme";
      rev = "6c340e058e84c1975a038a8e5d1e384477225dc0";
      hash = "sha256-7H2n9wTaW8Db1RejWK071ITV1j5KIuzfql0Tx9WT6zM=";
    };

    nativeBuildInputs = [
      pkgs.gnome-shell
      pkgs.sassc
    ];
    buildInputs = [ pkgs.gnome-themes-extra ];

    dontBuild = true;

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cd themes
      # `--tweaks storm` を付けないと ctype サフィックス (-Storm) が付かず、
      # theme.gtk = "Tokyonight-Dark-Storm" に一致するテーマが生成されない
      # (install.sh の THEME_DIR = name+theme+color+size+ctype)。
      # これを付け忘れるとシステム全体のダークテーマ指定がフォールバックしてしまう。
      ./install.sh -n Tokyonight -c dark --tweaks storm -d "$out/share/themes"
      cd ../icons
      mkdir -p $out/share/icons
      cp -a Tokyonight-Dark Tokyonight-Dark-Cyan Tokyonight-Light Tokyonight-Moon $out/share/icons/
      runHook postInstall
    '';

    meta = {
      description = "GTK theme based on the Tokyo Night colour palette";
      homepage = "https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
    };
  };
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
  # OS 非依存の個別アプリは ./apps.nix に分離し、darwin からも import できるようにした。
  # ここに残すのは Linux 専用のパッケージ・テーマ (qt/gtk/kvantum)・chromium・カーソル等。
  imports = [
    ./dropbox.nix
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
      package = tokyonightGtkTheme;
    };
    gtk4.theme = null;
    iconTheme = {
      name = theme.gtkIcon;
      package = tokyonightGtkTheme;
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
