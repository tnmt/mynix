{ ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/server
    ../../home-manager/work
  ];

  custom = {
    development = true;
    email = ""; # set locally or via sops-nix
    name = "tnmt";
  };
}
