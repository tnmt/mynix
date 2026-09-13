# Common home-manager baseline for NixOS-integrated hosts.
# Standalone home-manager hosts get the baseline via
# mkHomeManagerConfiguration instead.
{
  homeDirectory,
  username,
  ...
}:
{
  imports = [
    ../base
    (import ../common-init.nix {
      inherit homeDirectory username;
    })
  ];
}
