{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./neovim.nix
    ./zsh.nix
  ];

  programs = {
    bat = {
      enable = true;
      config = { theme = "Monokai Extended Origin"; };
    };
  };

  home.packages = with pkgs; [
    # nix
    cachix

    # cui
    bat
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

    # lang
    python311
    nodejs_20
    ruby_3_2
    rubyPackages_3_2.solargraph
    go
    gopls

    # paas
    heroku

    # container
    docker
    kubectl

    # C
    cmake

    # ssg
    hugo

    # Provisioning
    terraform
    terraform-ls
    tflint
    ansible

    # Secret management
    vault

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
