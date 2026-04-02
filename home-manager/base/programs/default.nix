{ pkgs, inputs, ... }:
{
  imports = [
    ./atuin.nix
    ./git.nix
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
      options = [
        "--cmd"
        "j"
      ];
    };

    bat = {
      enable = true;
      config = {
        theme = "tokyonight_storm";
      };
      themes = {
        tokyonight_storm = {
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "v4.12.0";
            hash = "sha256-fj6x7R11+s0/lhWCe0s3ELTRLgvU25Rjp4M5vZw5i3c=";
          };
          file = "extras/sublime/tokyonight_storm.tmTheme";
        };
      };
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-storm";
        theme_background = true;
        truecolor = true;
        rounded_corners = true;
        graph_symbol = "braille";
        update_ms = 2000;
        proc_sorting = "cpu lazy";
        proc_colors = true;
        proc_gradient = true;
        proc_mem_bytes = true;
        proc_cpu_graphs = true;
        show_uptime = true;
        show_cpu_freq = true;
        check_temp = true;
        show_coretemp = true;
        show_battery = true;
        vim_keys = false;
        clock_format = "%X";
      };
    };
  };

  home.packages = with pkgs; [
    # nix
    cachix
    nh
    sops

    # editor (minimal)
    vim

    # cui
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
    inputs.ccusage.packages.${pkgs.stdenv.hostPlatform.system}.default
    gemini-cli
    codex
  ];
}
