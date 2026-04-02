{ pkgs, ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/darwin
    ../../home-manager/desktop/terminal/alacritty
    ../../home-manager/desktop/terminal/ghostty
    ../../home-manager/work
  ];

  custom = {
    desktop = true;
    development = true;
    email = ""; # set locally or via sops-nix
    name = "tsunematsu";
  };

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
    google-cloud-sdk
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
