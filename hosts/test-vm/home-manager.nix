{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/server
  ];

  custom = {
    email = "test@example.com";
    name = "tnmt";
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;
}
