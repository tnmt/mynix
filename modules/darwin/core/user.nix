{ username, ... }:
{
  system.primaryUser = username;
  users.users."${username}".home = "/Users/${username}";
}
