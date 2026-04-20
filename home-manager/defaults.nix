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
  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  nix.package = lib.mkDefault pkgs.nix;
  programs.home-manager.enable = true;
  programs.git.enable = true;

  sops = {
    defaultSopsFile = homeSopsFile;
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      git_email = { };
      git_name = { };
      atuin_sync_address = {
        sopsFile = ../secrets/common.yaml;
      };
    };
  };
}
