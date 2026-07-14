{
  homeDirectory,
  username,
}:
{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (import ./common-init.nix {
      inherit
        homeDirectory
        username
        ;
    })
  ];

  nix.package = lib.mkDefault pkgs.nix;
}
