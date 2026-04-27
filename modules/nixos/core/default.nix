{
  imports = [
    ./firewall.nix
    ./home-manager.nix
    ./i18n.nix
    ./kernel-hardening.nix
    ./network.nix
    ./nix.nix
    ./sops.nix
    ./sudo.nix
    ./user.nix
    ./user-templates-link.nix
    ../../../profiles/common/user-sops.nix
  ];

  programs.zsh.enable = true;
}
