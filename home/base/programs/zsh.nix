{ pkgs
, ...
}: {
  programs.zsh = {
    enable = true;

    defaultKeymap = "emacs";

    # ファイルが生成されるディレクトリ ($ZDOTDIR)
    dotDir = ".config/zsh";

    # zsh-syntax-highlighting を有効化する
    syntaxHighlighting.enable = true;

    initExtra = ''
      . ${./zsh/zshrc}
      . ${./zsh/p10k.zsh}
      '';
  };
}
