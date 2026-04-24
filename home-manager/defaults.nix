{
  homeDirectory,
  homeSopsFile,
  sopsShared,
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
        homeSopsFile
        sopsShared
        username
        ;
    })
  ];

  home.stateVersion = "25.05";
  nix.package = lib.mkDefault pkgs.nix;
}
