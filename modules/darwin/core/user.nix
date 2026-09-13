{
  homeDirectory,
  username,
  ...
}:
{
  system.primaryUser = username;
  users.users."${username}".home = homeDirectory;

  programs.zsh.enable = true;
}
