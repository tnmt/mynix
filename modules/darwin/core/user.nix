{ username, ... }:
{
  system.primaryUser = username;
  users.users."${username}".home = "/Users/${username}";

  programs.zsh.enable = true;
}
