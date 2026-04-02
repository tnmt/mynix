{ pkgs, inputs, ... }:
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

  # home.packages = [
  #   inputs.oneaws.packages.${pkgs.stdenv.hostPlatform.system}.default
  # ];
}
