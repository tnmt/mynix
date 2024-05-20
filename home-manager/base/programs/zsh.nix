{ ... }:
{
  programs.zsh = {
    enable = true;

    defaultKeymap = "emacs";

    # ファイルが生成されるディレクトリ ($ZDOTDIR)
    dotDir = ".config/zsh";

    # zsh-syntax-highlighting を有効化する
    syntaxHighlighting.enable = true;

    #initExtraFirst = ''
    #  zmodload zsh/zprof
    #  '';
    initExtra = ''
      . ${./zsh/zshrc}
      . ${./zsh/p10k.zsh}
      #if (which zprof > /dev/null 2>&1) ;then
      #  zprof
      #fi
    '';
  };
}
