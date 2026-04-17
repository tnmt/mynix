{
  lib,
  pkgs,
  theme,
  ...
}:
let
  themeSrc = pkgs.fetchFromGitHub theme.src;
in
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./eza.nix
    ./git.nix
    ./ssh.nix
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

    zsh.initContent = ''
      source ${themeSrc}/${theme.extras.fzf}
    '';
  };

  home.packages =
    with pkgs;
    [
      # nix
      cachix
      nh
      sops

      # cui
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
