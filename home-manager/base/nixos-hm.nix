# Common home-manager settings for NixOS-integrated hosts.
# Standalone home-manager hosts get these via mkHomeManagerConfiguration instead.
{
  inputs,
  lib,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = lib.mkDefault "25.05";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  sops = {
    defaultSopsFile = ../../secrets/default.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets = {
      git_email = { };
      git_name = { };
      atuin_sync_address = {
        sopsFile = ../../secrets/common.yaml;
      };
    };
  };
}
