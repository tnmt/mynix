-- Neovim options
local opt = vim.opt

-- General
opt.syntax = "on"
opt.termguicolors = true
opt.number = true
opt.ruler = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.updatetime = 100

-- Indentation
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Backup
opt.backup = true
opt.backupdir = vim.fn.expand("~/.vimbackup")
opt.swapfile = false

-- Encoding
opt.encoding = "utf-8"
opt.fileencodings = "utf-8,iso-2022-jp,cp932,sjis,euc-jp"
opt.fileformats = "unix,dos,mac"

-- History
opt.history = 10000

-- Backspace
opt.backspace = "indent,eol,start"

-- UI
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Neovim specific
vim.g.mapleader = " "
vim.g.maplocalleader = " "