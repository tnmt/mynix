{
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./sops.nix
    ./user.nix
  ];

  programs.zsh.enable = true;
}
