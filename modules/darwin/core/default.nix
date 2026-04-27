{
  imports = [
    ./home-manager.nix
    ./nix.nix
    ./sops.nix
    ./user.nix
    ./user-templates-link.nix
    ../../../profiles/common/user-sops.nix
  ];

  programs.zsh.enable = true;
}
