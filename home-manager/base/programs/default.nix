{ pkgs, ... }:
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
    hub
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
    fzf
    neofetch
  ];
}
