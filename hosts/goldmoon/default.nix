{ ... }: {
  imports = [ ../../modules/darwin ];

  users.users.tnmt = {
    home = "/Users/tnmt";
    shell = "zsh";
  };
}
