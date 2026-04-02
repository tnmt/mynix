{
  inputs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base
    inputs.sops-nix.homeManagerModules.sops
  ];

  custom = {
    email = "";
    name = "tnmt";
  };

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

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;
}
