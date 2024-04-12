{ ... }: {
  imports = [ ../../modules/darwin ];

  users.users.tsunematsu = {
    home = "/Users/tsunematsu";
    shell = "zsh";
  };

  nix.settings.trusted-users = [ "tsunematsu" ];
}
