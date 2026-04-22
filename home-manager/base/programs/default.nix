{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./eza.nix
    ./git.nix
    ./ssh.nix
    ./ssh-private.nix
    ./starship
    ./tmux.nix
    ./vim.nix
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd"
        "j"
      ];
    };

  };

  home.packages =
    with pkgs;
    [
      # nix
      cachix
      nh
      sops

      # cui
      file
      forgejo-cli
      gh
      ghq
      ripgrep
      fd
      tig
      wget
      rsync
      tree

      # archiver
      unzip

      # Data format
      jq
      yq

      # SSH
      openssh

      # TLS
      openssl

      # search
      platinum-searcher

      # AI
      claude-code
      ccusage
      gemini-cli
      codex
      rtk
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      bubblewrap
    ];
}
