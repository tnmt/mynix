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

call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-rooter'
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'github/copilot.vim'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'michal-h21/vim-zettel'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
call plug#end()

set number
set termguicolors
set updatetime=100

" SirVer/ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

" dense-analysis/ale
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

" scrooloose/nerdtree
nmap <C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" neoclide/coc.nvim
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

" kassio/neoterm
let g:neoterm_default_mod='belowright'
let g:neoterm_size=10
let g:neoterm_autoscroll=1
tnoremap <silent> <C-w> <C-\><C-n><C-w>
nnoremap <silent> <C-n> :TREPLSendLine<CR>j0
vnoremap <silent> <C-n> V:TREPLSendSelection<CR>'>j0

" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'},
                      \ {'path': '~/Dropbox/vimwiki/zettelkasten/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

" vim-zettel
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

au UIEnter * set guifont=MesloLGS\ NF:h16

" copilot.vim
let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'python': v:true,
      \ 'go': v:true,
      \ 'vim': v:true,
      \ 'ruby': v:true,
      \ }
