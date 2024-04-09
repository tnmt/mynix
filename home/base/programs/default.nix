{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./neovim.nix
  ];

  programs = {
    bat = {
      enable = true;
      config = { theme = "Monokai Extended Origin"; };
    };
  };

  home.packages = with pkgs; [
    # cui
    bat
    direnv
    fzf
    gh
    ghq
    hub
    nkf
    peco
    sshuttle
    tig
    tmux
    wget

    # C
    cmake

    # Provisioning
    terraform
    terraform-ls
    tflint

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
