{
  inputs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base-nixos
  ];

  custom = {
    email = "test@example.com";
    name = "tnmt";
  };
}
