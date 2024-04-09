{ pkgs
, ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = true;
    withNodeJs = true;
    withPython3 = true;

    coc.enable = true;
    coc.settings = {
      "diagnostic.enable" =  false;
      "jedi" = {
        "enable" = true;
        "startupMessage" = true;
        "hover.enable" = true;
        "executable.command" = "~/.pyenv/versions/neovim3/bin/jedi-language-server";
      };
      "languageserver" = {
        "golang" = {
          "command" = "gopls";
          "rootPatterns" =  ["go.mod" ".vim/" ".git/" ".hg/"];
          "filetypes" = ["go"];
        };
      };
    };

    extraConfig = ''
      source ${pkgs.vimPlugins.vim-plug}/plug.vim
      source ${./neovim/init.vim}
      '';
  };
}
