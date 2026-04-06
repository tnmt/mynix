{ ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/devel
    ../../home-manager/darwin
    ../../home-manager/desktop/terminal
  ];

  custom = {
    desktop = true;
    development = true;
    email = ""; # set locally or via sops-nix
    name = "tnmt";
  };

}
