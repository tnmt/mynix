{ pkgs, ... }:
{
  imports = [ ../../modules/darwin ];

  users.users.tsunematsu = {
    home = "/Users/tsunematsu";
    shell = "zsh";
    packages = with pkgs; [
      hugo
      sshuttle
      openstackclient
    ];
  };

  nix.settings.trusted-users = [ "tsunematsu" ];
}
