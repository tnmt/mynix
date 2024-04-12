{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    python311Packages.pynvim
  ];



  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = true;
    withNodeJs = true;
    withPython3 = true;

    plugins = with pkgs.vimPlugins; [
      lightline-vim
      onedark-nvim
    ];

    coc.enable = true;
    coc.settings = {
      "diagnostic.enable" =  false;
      "jedi" = {
        "enable" = true;
        "startupMessage" = true;
        "hover.enable" = true;
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
