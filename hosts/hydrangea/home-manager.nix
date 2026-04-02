{ ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/devel
    ../../home-manager/darwin
    ../../home-manager/desktop/terminal/alacritty
    ../../home-manager/desktop/terminal/ghostty
  ];

  custom = {
    desktop = true;
    development = true;
    email = ""; # set locally or via sops-nix
    name = "tnmt";
  };
}
