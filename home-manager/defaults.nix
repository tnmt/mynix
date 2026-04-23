{
  homeDirectory,
  homeSopsFile,
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
      inherit homeDirectory homeSopsFile username;
    })
  ];

  home.stateVersion = "25.05";
  nix.package = lib.mkDefault pkgs.nix;
}
