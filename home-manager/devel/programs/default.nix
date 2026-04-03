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

    # Google Workspace
    gws

    # Build/lang
    gnumake
    yamlfmt
    nkf
    nixd
  ];
}
