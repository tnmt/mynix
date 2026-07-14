# Home Manager baseline shared by every path (NixOS-integrated,
# nix-darwin-integrated, and standalone). stateVersion lives here only.
{
  homeDirectory,
  username,
}:
{ lib, ... }:
{
  home = {
    inherit username homeDirectory;
    stateVersion = lib.mkDefault "26.05";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
}
