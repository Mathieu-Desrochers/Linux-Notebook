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

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'kien/ctrlp.vim'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'vim-scripts/paredit.vim'
Plugin 'VundleVim/Vundle.vim'
Plugin 'rust-lang/rust.vim'
call vundle#end()
filetype plugin on

let g:ctrlp_custom_ignore = {'file' : '\v\.(o)$' }
let g:buffergator_viewport_split_policy="B"

au BufRead,BufNewFile *.svelte set filetype=html
