{ pkgs, inputs, ... }:
{
  imports = [
    ./git.nix
    ./neovim.nix
    ./ssh.nix
    #./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    # nix
    cachix
    nh

    # cui
    direnv
    fzf
    gh
    ghq
    nkf
    peco
    platinum-searcher
    sshuttle
    tig
    tmux
    wget
    gnumake
    rsync

    # lang
    rubyPackages_3_2.solargraph
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
    openssh # provide ssh ssh-agent ssh-keygen ssh-add scp ssh-keyscan

    # TLS
    openssl

    # Etc(not categorized yet)
    direnv
    neofetch

    # claude
    claude-code
    inputs.ccusage.packages.${pkgs.system}.default

    # gemini
    gemini-cli

    # Terraform
    tenv
  ];
}
