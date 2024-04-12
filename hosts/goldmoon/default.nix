{ ... }: {
  imports = [ ../../modules/darwin ];

  users.users.tnmt = {
    home = "/Users/tnmt";
    shell = "zsh";
  };

  nix.settings.trusted-users = [ "tnmt" ];
}
