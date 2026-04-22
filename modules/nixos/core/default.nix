{
  imports = [
    ./firewall.nix
    ./home-manager.nix
    ./i18n.nix
    ./network.nix
    ./nix.nix
    ./sops.nix
    ./sudo.nix
    ./user.nix
  ];

  programs.zsh.enable = true;
}
