{ pkgs, ... }: {
  imports = [ ../../modules/darwin ];

  users.users.tsunematsu = {
    home = "/Users/tsunematsu";
    shell = "zsh";
    packages = with pkgs; [
      colima
      docker
      docker-compose
      hugo
      lima
      qemu
      sshuttle
      openstackclient
    ];
  };

  nix.settings.trusted-users = [ "tsunematsu" ];
}
