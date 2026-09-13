{
  lib,
  homeDirectory,
  pkgs,
  username,
  ...
}:
{
  users.users."${username}" = {
    isNormalUser = true;
    home = homeDirectory;
    shell = pkgs.zsh;
    group = "users";
    extraGroups = lib.mkDefault [ "wheel" ];
  };

  programs.zsh.enable = true;
}
