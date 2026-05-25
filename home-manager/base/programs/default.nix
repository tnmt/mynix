{
  lib,
  osConfig ? null,
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
    ./herdr.nix
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

    navi = {
      enable = true;
      enableZshIntegration = true;
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
      git-wt
      roots
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
      yq-go

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
    ]
    ++ lib.optionals (!(osConfig.wsl.enable or false)) [
      # opencode: Bun製単一バイナリがWSL2でSIGSEGV (autoPatchelf相性問題)
      opencode
    ];

  # WSL2では公式インストーラ (curl https://opencode.ai/install) で
  # ~/.opencode/bin に導入したバイナリを nix-ld 経由で実行する。
  home.sessionPath = lib.optionals (osConfig.wsl.enable or false) [
    "$HOME/.opencode/bin"
  ];
}
