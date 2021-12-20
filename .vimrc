" Fuck off vi!
set nocompatible

" Force proper loading of plugins
filetype off
filetype plugin indent on

" Turn on syntax highlighting
syntax on

" Default Encoding
set encoding=utf-8

" Security
set modelines=0

" Show line numbers
" set number

" Show file stats
set ruler

" Blink cursor on error (in lieu of beep)
set visualbell

" Whitespacing
set wrap
set textwidth=119
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
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

" Install Vimplug if not exists
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Call plugins
Plug 'tpope/vim-sensible'       "Basic amenities for Vim
Plug 'tpope/vim-fugitive'       "Git wrapper
Plug 'junegunn/seoul256.vim'    "256 Colors of Seoul
Plug 'joshdick/onedark.vim'     "Atom's One Dark theme
Plug 'lervag/vimtex'            "LaTeX on Vim
Plug 'dense-analysis/ale'       "Generic autocompletion
Plug 'rust-lang/rust.vim'       "Support for Rust

" QoL
Plug 'preservim/nerdtree'       "FS Explorer for Vim
Plug 'itchyny/lightline.vim'    "Lightline

" Markdown Stuff
Plug 'iamcco/markdown-preview.nvim', { 
            \ 'do': { -> mkdp#util#install() },
            \ 'for': ['markdown', 'vim-plug']
            \}                  "Markdown Preview
Plug 'neoclide/coc.nvim', { 
            \ 'branch': 'release'
            \}                  "Coc LSP
Plug 'mzlogin/vim-markdown-toc' "Markdown TOC Generator

" Python plugins
Plug 'ambv/black'               "Black code formatter
Plug 'tmhedberg/simpylfold'     "Code folding

call plug#end()

" ALE completion config
let g:ale_completion_enabled = 1  "default=0
let g:ale_completion_max_suggestions = 20  "default=50

" ALE linter selection
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'javascript': ['eslint'],
\ 'python': ['flake8']
\}

" ALE change colour on error
let g:ale_change_sign_column_color = 1  "default=0

" COLORSCHEME CONFIG
" See https://github.com/itchyny/lightline.vim/blob/master/colorscheme.md
 let g:lightline = {
            \ 'colorscheme': 'onedark',
            \ } " solarized, PaperColor, one, darcula, nord, seoul256
