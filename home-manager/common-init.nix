{
  homeDirectory,
  homeSopsFile,
  username,
}:
{
  home = {
    inherit username homeDirectory;
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  sops = {
    defaultSopsFile = homeSopsFile;
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      git_email = { };
      git_name = { };
      git_personal_email = {
        sopsFile = ../secrets/roles/personal.yaml;
        key = "git_email";
      };
      git_personal_name = {
        sopsFile = ../secrets/roles/personal.yaml;
        key = "git_name";
      };
      atuin_sync_address = {
        sopsFile = ../secrets/common.yaml;
      };
    };
  };
}
