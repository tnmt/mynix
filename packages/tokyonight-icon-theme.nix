{
  lib,
  pkgs,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "tokyonight-icon-theme";
  version = "0-unstable-2025-10-23";

  src = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyonight-GTK-Theme";
    rev = "6c340e058e84c1975a038a8e5d1e384477225dc0";
    hash = "sha256-7H2n9wTaW8Db1RejWK071ITV1j5KIuzfql0Tx9WT6zM=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -a icons/Tokyonight-Dark icons/Tokyonight-Dark-Cyan icons/Tokyonight-Light icons/Tokyonight-Moon $out/share/icons/
    runHook postInstall
  '';

  meta = {
    description = "Tokyo Night icon themes from Fausto-Korpsvart/Tokyonight-GTK-Theme";
    homepage = "https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
