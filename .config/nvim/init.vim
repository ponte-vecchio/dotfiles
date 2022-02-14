" General
set nocompatible					" Vim only, no Vi
filetype off						" force plugins to load
filetype plugin indent on			" force indent on
syntax on							" Turn on syntax highlighting
set encoding=utf-8					" Use utf-8 encoding
set modelines=0						" Disable modelines
" set number						" Turn on line numbers
set ttyfast							" Faster scrolling
set mouse=a							" Use mouse in all modes

" Status Bar
set ruler							" Status in title bar
set laststatus=2					" Use last 2 lines as status bar
set noshowmode						" Don't show mode
set showcmd							" Show command in status bar

" Things that go ding
set visualbell						" Visual bell
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>				" Toggle paste mode when F2 is pressed


" Whitespacing
set		textwidth=120
set formatoptions=tcqrn1
set		  tabstop=4
set	   shiftwidth=4
set	  softtabstop=4
set smarttab autoindent
set noshiftround
set title

" Extension-specific Whitespacing
au BufNewFile,BufRead *.c,*.h	set tw=109
au BufNewFile,BufRead *.xml		set tw=109	shiftwidth=2 smarttab
au BufNEwFile,BufRead *.yml		set tw=109	shiftwidth=2 smarttab
au FileType sh					set tw=80	shiftwidth=4 smarttab
au FileType c					set tw=109
au FileType h					set tw=109
au FileType tex,cls,sty			set tw=109


" Rendering
set ttyfast


" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch						" Highlight search
set incsearch						" Search for incremental matches
set ignorecase						" Case-insensitive searching
set showmatch						" Highlight matching parens
map <leader><space> :let @/=''<cr>	" clear search

" Formatting
map <leader>q gqip

" Install Vimplug if not exists
if has('nvim') && empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

if has('nvim') && empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Call plugins
Plug 'tpope/vim-sensible'       "Basic amenities for Vim
Plug 'tpope/vim-fugitive'       "Git wrapper
" Plug 'junegunn/seoul256.vim'    "256 Colors of Seoul
" Plug 'joshdick/onedark.vim'     "Atom's One Dark theme
Plug 'lervag/vimtex'            "LaTeX on Vim
Plug 'dense-analysis/ale'       "Generic autocompletion
Plug 'rust-lang/rust.vim'       "Support for Rust
Plug 'neoclide/coc.nvim', { 
            \ 'branch': 'release'
            \}                  "Coc LSP
" QoL
Plug 'preservim/nerdtree'       "FS Explorer for Vim
Plug 'itchyny/lightline.vim'    "Lightline
Plug 'Xuyuanp/nerdtree-git-plugin'

" Markdown Stuff
Plug 'iamcco/markdown-preview.nvim', {
            \ 'do': { -> mkdp#util#install() },
            \ 'for': 'markdown'
            \}                  "Markdown Preview
Plug 'mzlogin/vim-markdown-toc' "Markdown TOC Generator

" B
" Python plugins
Plug 'ambv/black'               "Black code formatter
Plug 'tmhedberg/simpylfold'     "Code folding
Plug 'github/copilot.vim'       "Github Copilot

call plug#end()

"  completion config
let g:ale_completion_enabled = 1  "default=0
let g:ale_completion_max_suggestions = 20  "default=50

" ALE linter selection
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'python': ['flake8']
\}
" ALE change colour on error
let g:ale_change_sign_column_color = 1  "default=0

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction
function! CopilotEnabledCheck()
	return get(b:, 'Copilot_status', ' ')
endfunction

" Lightline args for Git integration
let g:lightline = {
    \ 'active': {
    \   'left': [	[ 'copilot' ],
	\				[ 'mode', 'paste' ],
    \				[ 'gitbranch', 'readonly', 'filename', 'modified', 'cocstatus', 'currentfunction' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch':		'FugitiveHead',
    \   'cocstatus':		'coc#status',
    \   'currentfunction':  'CocCurrentFunction',
	\	'copilot':			'CopilotEnabledCheck'
    \ },
    \ }

" Use Okular if linux
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" Custom TeX Compiler
let g:vimtex_compiler_generic = {
	\ 'command': 'dotheluaffs',
	\ 'executable' : 'latexmk',
	\ 'options': [
	\	'-lualatex',
	\	'-c',
	\	'--interaction=nonstopmode',
	\	'-synctex=1',
	\],
	\}

let g:vimtex_compiler_method='generic'
