{
  homeDirectory,
  username,
}:
{
  home = {
    inherit username homeDirectory;
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
}
