{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./neovim.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    # nix
    cachix

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

    # lang
    python311
    nodejs_20
    ruby_3_2
    rubyPackages_3_2.solargraph
    go
    gopls
    nixd

    # k8s
    kubectl

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
