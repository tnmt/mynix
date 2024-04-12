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
Plug 'dense-analysis/ale'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'github/copilot.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

set number
set termguicolors
set updatetime=100

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

au UIEnter * set guifont=MesloLGS\ NF:h16

" copilot.vim
let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'python': v:true,
      \ 'go': v:true,
      \ 'vim': v:true,
      \ 'ruby': v:true,
      \ }
