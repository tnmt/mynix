{ pkgs, inputs, ... }:
{
  imports = [
    ./atuin.nix
    ./git.nix
    ./neovim.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd" "j" ];
    };

    bat = {
      enable = true;
      config = {
        theme = "tokyonight_storm";
      };
    };
  };

  home.packages = with pkgs; [
    # nix
    cachix
    nh

    # cui
    gh
    ghq
    nkf
    ripgrep
    fd
    sshuttle
    tig
    wget
    gnumake
    rsync
    tree

    # lang
    gopls
    nixd

    # archiver
    unzip

    # k8s
    kubectl
    krew

    # Data format
    jq
    yamlfmt

    # SSH
    openssh

    # TLS
    openssl

    # claude
    claude-code
    inputs.ccusage.packages.${pkgs.system}.default

    # gemini
    gemini-cli

    # codex
    codex

    # Terraform
    tenv
  ];
}
