{
  lib,
  pkgs,
  username,
  ...
}:
{
  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = lib.mkDefault [ "wheel" ];
  };
}
