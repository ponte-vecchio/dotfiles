" Fuck off vi!
set nocompatible

" Force proper loading of plugins
filetype off
filetype plugin indent on

" TODO: vundle or pathogen plugins go here


" Turn on syntax highlighting
syntax on

" Default Encoding
set encoding=utf-8

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error (in lieu of beep)
set visualbell

" Whitespacing
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Rendering
set ttyfast

" Status Bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Formatting
map <leader>q gqip

" Show indentatinos (tabs and spaces)
set listchars=tab:⇥\ ,eol:↵ "space could be ␣
set list
map <leader>l :set list!<CR>

" Plugins
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" call plugins
Plug 'tpope/vim-sensible'     "Basic amenities for Vim
Plug 'junegunn/seoul256.vim'  "256 Colors of Seoul
Plug 'lervag/vimtex'          "LaTeX on Vim
Plug 'dense-analysis/ale'     "Generic autocompletion
Plug 'ambv/black'             "Python code formatter
call plug#end()

" ale linter selection
let g:ale_linters = {
\	'javascript': ['eslint'],
\}
