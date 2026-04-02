{
  inputs,
  username,
  ...
}:
{
  imports = [
    ../../home-manager/base
    ../../home-manager/devel
    ../../home-manager/desktop
    ../../home-manager/desktop/hyprland
    ../../home-manager/desktop/terminal
    inputs.sops-nix.homeManagerModules.sops
  ];

  custom = {
    desktop = true;
    development = true;
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
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;
}
