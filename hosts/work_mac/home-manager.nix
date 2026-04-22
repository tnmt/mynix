{ pkgs, ... }:
{
  imports = [
    # Shared darwin user profile for development hosts.
    ../../profiles/home-manager/darwin-development.nix
    ../../home-manager/work
  ];

  # Work-machine-only CLI packages that do not belong in shared profiles.
  home.packages = with pkgs; [
    oneaws
    ccusage
    aws-sam-cli
    awscli2
    coreutils
    curl
    duckdb
    exiftool
    git-filter-repo
    hugo
    imagemagick
    kubernetes-helm
    libffi
    libidn
    luarocks
    lynx
    mariadb
    minikube
    ncdu
    fastfetch
    wget
  ];
}
