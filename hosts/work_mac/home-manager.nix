{ pkgs, ... }:
{
  imports = [
    ../../profiles/home-manager/darwin-development.nix
    ../../home-manager/work
  ];

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
    yq-go
  ];
}
