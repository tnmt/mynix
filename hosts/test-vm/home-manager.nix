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

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;
}
