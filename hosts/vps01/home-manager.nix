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
    email = "";
    name = "tnmt";
  };

  home.stateVersion = "25.11";
}
