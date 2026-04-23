# Common home-manager settings for NixOS-integrated hosts.
# Standalone home-manager hosts get these via mkHomeManagerConfiguration instead.
{
  homeSopsFile,
  inputs,
  lib,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    (import ../common-init.nix {
      homeDirectory = "/home/${username}";
      inherit homeSopsFile username;
    })
  ];

  home.stateVersion = lib.mkDefault "25.05";

  sops.secrets = {
    voice_input_openrouter_api_key = {
      sopsFile = ../../secrets/common.yaml;
    };
  };
}
