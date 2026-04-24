{
  homeDirectory,
  homeSopsFile,
  username,
}:
let
  sopsShared = import ../profiles/common/sops-shared.nix;
in
{
  home = {
    inherit username homeDirectory;
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  sops = {
    defaultSopsFile = homeSopsFile;
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    secrets =
      sopsShared.mkCoreSecrets {
        commonSopsFile = ../secrets/common.yaml;
      }
      // sopsShared.mkPersonalGitSecrets {
        personalSopsFile = ../secrets/roles/personal.yaml;
      };
  };
}
