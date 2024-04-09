{ ... }: {
  imports = [ ../../modules/darwin ];

  users.users.tsunematsu = {
    home = "/Users/tsunematsu";
    shell = "zsh";
  };
}
