{ pkgs, inputs, ... }:
{
  imports = [
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    # Infra
    kubectl
    krew
    tenv
    sshuttle

    # Build/lang
    gnumake
    yamlfmt
    nkf
    nixd
  ];
}
