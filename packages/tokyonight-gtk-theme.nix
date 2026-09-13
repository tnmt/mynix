{
  lib,
  pkgs,
}:
pkgs.stdenvNoCC.mkDerivation {
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
    # `--tweaks storm` adds the -Storm suffix expected by theme.gtk.
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
}
