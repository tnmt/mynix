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
    email = "test@example.com";
    name = "tnmt";
  };
}
