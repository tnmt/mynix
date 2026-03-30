{ ... }:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/server
  ];

  custom = {
    email = ""; # set locally or via sops-nix
    name = "tnmt";
  };
}
