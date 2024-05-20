{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python311Packages.pynvim
    rubyPackages_3_2.solargraph

    nodePackages.coc-solargraph
    nodePackages.coc-go
    nodePackages.coc-ultisnips
    nodePackages.coc-json
    nodePackages.coc-pyright
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
      auto-pairs
      coc-pyright
      coc-solargraph
      fzf-vim
      nerdtree-git-plugin
      vim-better-whitespace
      vim-commentary
      vim-endwise
      vim-fugitive
      #vim-gitgutter
      vim-go
      vim-indent-guides
      vim-puppet
      vim-rooter
      vim-snippets
      vimwiki
      #{
      #  plugin = neoterm;
      #  config = ''
      #    let g:neoterm_default_mod='belowright'
      #    let g:neoterm_size=10
      #    let g:neoterm_autoscroll=1
      #    tnoremap <silent> <C-w> <C-\><C-n><C-w>
      #    nnoremap <silent> <C-n> :TREPLSendLine<CR>j0
      #    vnoremap <silent> <C-n> V:TREPLSendSelection<CR>'>j0
      #    '';
      #}
      {
        plugin = coc-nvim;
        config = ''
          inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)
          nnoremap <silent> K :call <SID>show_documentation()<CR>

          function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
              execute 'h '.expand('<cword>')
            else
              call CocAction('doHover')
            endif
          endfunction
        '';
      }
      {
        plugin = copilot-vim;
        config = ''
          let g:copilot_filetypes = {
                \ '*': v:false,
                \ 'python': v:true,
                \ 'go': v:true,
                \ 'vim': v:true,
                \ 'ruby': v:true,
                \ }
        '';
      }
      {
        plugin = ale;
        config = ''
          let g:ale_set_highlights = 0
          let g:ale_linters = {'python': ['flake8']}
          let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
          let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'python': ['black'],
            \ }
          " let g:ale_fix_on_save = 1
          nmap <silent> <C-k> <Plug>(ale_previous_wrap)
          nmap <silent> <C-j> <Plug>(ale_next_wrap)
        '';
      }
      {
        plugin = nerdtree;
        config = ''
          nmap <C-e> :NERDTreeToggle<CR>
          let NERDTreeShowHidden=1
        '';
      }
      {
        plugin = ultisnips;
        config = ''
          let g:UltiSnipsExpandTrigger="<tab>"
          let g:UltiSnipsJumpForwardTrigger="<c-n>"
          let g:UltiSnipsJumpBackwardTrigger="<c-p>"
        '';
      }
      {
        plugin = vimwiki;
        config = ''
          let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/',
                                \ 'syntax': 'markdown', 'ext': '.md'},
                                \ {'path': '~/Dropbox/vimwiki/zettelkasten/',
                                \ 'syntax': 'markdown', 'ext': '.md'}]
          let g:vimwiki_global_ext = 0
        '';
      }
      {
        plugin = vim-zettel;
        config = ''
          let g:zettel_format="%Y%m%d%H%M%S"
          let g:zettel_fzf_command = "pt --column --ignore-case --color"
          let g:zettel_date_format = "%Y/%m/%d %H:%M:%S"
          function! s:insert_id()
            if exists("g:zettel_current_id")
              return strftime("%Y%m%d%H%M%S")
            else
              return "unnamed"
            endif
          endfunction
          let g:zettel_options = [{}, {"front_matter" :
                \ [
                \   ["id", function("s:insert_id")],
                \   ["tags", []],
                \   ["publish", "false"]
                \ ]
                \}]
        '';
      }
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
          let g:lightline = {'colorscheme': 'tokyonight'}
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
        plugin = tokyonight-nvim;
        config = ''
          syntax enable
          colorscheme tokyonight
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
      "diagnostic.enable" = false;
      "languageserver" = {
        "python" = {
          "command" = "pyright";
          "trace.server" = "verbose";
          "filetypes" = [ "py" ];
        };
        "golang" = {
          "command" = "gopls";
          "rootPatterns" = [
            "go.mod"
            ".vim/"
            ".git/"
            ".hg/"
          ];
          "filetypes" = [ "go" ];
        };
        "nix" = {
          "enableLanguageServer" = true;
          "serverPath" = "nixd";
          "serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = [ "nixpkgs-fmt" ];
              };
              "options" = {
                "enable" = true;
                "target" = {
                  "args" = [ ];
                  "installable" = "<flakeref>#nixosConfigurations.<name>.options";
                };
              };
            };
          };
        };
      };
    };

    extraConfig = ''
      syntax on
      set t_Co=256
      set autoindent
      set backspace=indent,eol,start
      set backup
      set backupdir=~/.vimbackup
      set clipboard+=unnamedplus
      set history=10000
      set hlsearch
      set ignorecase
      set smartcase
      set incsearch
      set ruler
      set encoding=utf-8
      set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
      set fileformats=unix,dos,mac
      set number
      set termguicolors
      set updatetime=100
      au UIEnter * set guifont=MesloLGS\ NF:h16
    '';
  };
}
