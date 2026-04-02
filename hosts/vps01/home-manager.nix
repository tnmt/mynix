{
  inputs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/base/nixos-hm.nix
  ];

  custom = {
    email = "";
    name = "tnmt";
  };

  home.stateVersion = "25.11";
}
