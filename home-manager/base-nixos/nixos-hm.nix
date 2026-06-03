# Common home-manager settings for NixOS-integrated hosts.
# Standalone home-manager hosts get these via mkHomeManagerConfiguration instead.
{
  lib,
  username,
  ...
}:
{
  imports = [
    (import ../common-init.nix {
      homeDirectory = "/home/${username}";
      inherit username;
    })
  ];

  home.stateVersion = lib.mkDefault "26.05";
}
