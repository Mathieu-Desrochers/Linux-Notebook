set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set encoding=utf-8
set fileencoding=utf-8

syntax enable

set list
set listchars=tab:··,trail:·

set hlsearch
nnoremap <CR> :noh<CR><CR>

set tags=./tags;

set nobackup
set noswapfile
set noundofile

execute pathogen#infect()
