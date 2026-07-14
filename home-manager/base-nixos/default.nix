# Common home-manager baseline for NixOS-integrated hosts.
# Standalone home-manager hosts get the baseline via
# mkHomeManagerConfiguration instead.
{ username, ... }:
{
  imports = [
    ../base
    (import ../common-init.nix {
      homeDirectory = "/home/${username}";
      inherit username;
    })
  ];
}
