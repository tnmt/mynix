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
      fzf-vim
      neoterm
      onedark-vim
      vim-better-whitespace
      vim-commentary
      vim-endwise
      vim-fugitive
      vim-gitgutter
      vim-indent-guides
      vim-puppet
      vimwiki
      {
        plugin = fzf-vim;
        config = ''
          nmap <C-p> :History<CR>
          '';
      }
      {
        plugin = vim-polyglot;
        config = ''
          let g:polyglot_disabled = ['csv']
          '';
      }
      {
       plugin = lightline-vim;
       config = ''
         let g:lightline = {'colorscheme': 'onedark'}
         let g:lightline.component_expand = {
           \   'linter_checking': 'lightline#ale#checking',
           \   'linter_warnings': 'lightline#ale#warnings',
           \   'linter_errors': 'lightline#ale#errors',
           \   'linter_ok': 'lightline#ale#ok',
           \ }
         let g:lightline.component_type = {
           \   'linter_checking': 'left',
           \   'linter_warnings': 'warning',
           \   'linter_errors': 'error',
           \   'linter_ok': 'left',
           \ }
         let g:lightline.active = {
           \   'left': [
           \     ['mode', 'paste'],
           \     ['readonly', 'filename', 'modified'],
           \     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok'],
           \   ]
           \ }
         '';
      }
      {
        plugin = vim-indent-guides;
        config = ''
          let g:indent_guides_enable_on_vim_startup = 1
          '';
      }
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
