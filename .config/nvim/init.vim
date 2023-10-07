" General
set nocompatible					" Vim only, no Vi
filetype off						" force plugins to load
filetype plugin indent on			" force indent on
syntax enable						" Turn on syntax highlighting
set encoding=utf-8					" Use utf-8 encoding
set modelines=0						" Disable modelines
" set number							" Turn on line numbers
set ttyfast							" Faster scrolling
set mouse=a							" Use mouse in all modes
set guifont=JetBrainsMono_NF:h14
set linespace=0

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

" Operating system
if !exists("g:curr_os")
	if system('uname -s') == "Linux\n"
		let g:curr_os = "linux"
	elseif system('uname -s') == "Darwin\n"
		let g:curr_os = "darwin"
	else
		let g:curr_os = "nt"
	endif
endif


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
au BufNewFile,BufRead *.xml	 set tw=109 shiftwidth=2
au BufNewFile,BufRead *.yml	 set tw=109 shiftwidth=2
au FileType sh				 set tw=80	shiftwidth=4
au FileType tex,cls,sty		 set tw=119

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

" Plugins
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " The one and only fuzzy finder
Plug 'junegunn/fzf.vim'
let g:fzf_command_prefix = 'Fz'
let g:fzf_buffers_jump = 1

command! -nargs=? -bang -complete=dir FzFiles
\	call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:60%') : {}, <bang>0)
command FzfChanges call s:fzf_changes()

" Themes and Schemes
Plug 'oessaid/ibm'
Plug 'rockerBOO/boo-colorscheme-nvim'

" QoL
Plug 'ap/vim-css-color'			"Hex Color Preview
Plug 'preservim/nerdtree'       " FS Explorer for Vim
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-sensible'       " Basic amenities for Vim
Plug 'tpope/vim-fugitive'       " Git wrapper
Plug 'itchyny/lightline.vim'    " Lightline
let g:lightline = {
\	'colorscheme': 'ibm',
\	'active': {
\	'left': [	[ 'copilot' ],
\				[ 'mode', 'paste' ],
\				[ 'gitbranch', 'readonly', 'filename', 'modified', 'currentfunction' ] ]
\},
\	'component_function': {
\		'gitbranch':		'FugitiveHead',
\		'cocstatus':		'coc#status',
\		'currentfunction':  'CocCurrentFunction',
\		'copilot':			'CopilotEnabledCheck'
\	},
\}

" Snippet config
Plug 'Sirver/ultisnips'
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsSnippetDirectories=['Snips']
nnoremap <leader>U :call UltiSnips#RefreshSnippets<CR>
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
set completeopt=noinsert,menuone,noselect

augroup my_cm_setup
	autocmd!
	autocmd BufEnter * call ncm2#enable_for_buffer()
	autocmd Filetype tex call ncm2#register_source({
			\ 'name' : 'vimtex-cmds',
			\ 'priority': 8,
			\ 'complete_length': -1,
			\ 'scope': ['tex'],
			\ 'matcher': {'name': 'prefix', 'key': 'word'},
			\ 'word_pattern': '\w+',
			\ 'complete_pattern': g:vimtex#re#ncm2#cmds,
			\ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
			\ })
	autocmd Filetype tex call ncm2#register_source({
			\ 'name' : 'vimtex-labels',
			\ 'priority': 8,
			\ 'complete_length': -1,
			\ 'scope': ['tex'],
			\ 'matcher': {'name': 'combine',
			\             'matchers': [
			\               {'name': 'substr', 'key': 'word'},
			\               {'name': 'substr', 'key': 'menu'},
			\             ]},
			\ 'word_pattern': '\w+',
			\ 'complete_pattern': g:vimtex#re#ncm2#labels,
			\ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
			\ })
	autocmd Filetype tex call ncm2#register_source({
			\ 'name' : 'vimtex-files',
			\ 'priority': 8,
			\ 'complete_length': -1,
			\ 'scope': ['tex'],
			\ 'matcher': {'name': 'combine',
			\             'matchers': [
			\               {'name': 'abbrfuzzy', 'key': 'word'},
			\               {'name': 'abbrfuzzy', 'key': 'abbr'},
			\             ]},
			\ 'word_pattern': '\w+',
			\ 'complete_pattern': g:vimtex#re#ncm2#files,
			\ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
			\ })
	autocmd Filetype tex call ncm2#register_source({
			\ 'name' : 'bibtex',
			\ 'priority': 8,
			\ 'complete_length': -1,
			\ 'scope': ['tex'],
			\ 'matcher': {'name': 'combine',
			\             'matchers': [
			\               {'name': 'prefix', 'key': 'word'},
			\               {'name': 'abbrfuzzy', 'key': 'abbr'},
			\               {'name': 'abbrfuzzy', 'key': 'menu'},
			\             ]},
			\ 'word_pattern': '\w+',
			\ 'complete_pattern': g:vimtex#re#ncm2#bibtex,
			\ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
			\ })
augroup END

" Language support
"" JSONC
Plug 'neoclide/jsonc.vim'

"" Markdown
Plug 'mzlogin/vim-markdown-toc'

"" Python plugins
Plug 'ambv/black'
Plug 'tmhedberg/simpylfold'     "Code folding

"" Rust
Plug 'rust-lang/rust.vim'       " Support for Rust


"" TeX / LaTeX
Plug 'lervag/vimtex'            " LaTeX on Vim
let g:vimtex_compiler_method='latexmk'
let g:vimtex_compiler_latexmk_engines= {
\	'_': '-lualatex -synctex=1 -file-line-error -interaction=nonstopmode -shell-escape',
\	'pdflatex': '-pdf',
\	'xelatex': '-xelatex',
\	'lualatex': '-lualatex'
\}

" Discord
Plug 'andweeb/presence.nvim'
let g:presence_auto_update = 1
let g:presence_neovim_image_text = "Neovide"
let g:presence_main_image = "neovide"
let g:presence_enable_line_number = 1

" Always load the vim-devicons as the last one
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Neovide
if exists("g:neovide")
	let g:neovide_scale_factor = 1.0
	let g:neovide_transparency = 0.9 " opacity [0.0, 1.0]
	let g:transparency = 1.0
	let g:neovide_floating_blur_amount_x = 2.0
	let g:neovide_floating_blur_amount_y = 2.0
	let g:neovide_remember_window_size = v:true
	let g:neovide_cursor_animation_length = 0.15 " default: 0.13
	colo ibm
	set guifont=CMU\ Typewriter\ Text,\ JetBrainsMono_Nerd_Font:h12
end

" Functions
function! CopilotEnabledCheck()
	let l:copilot_status = copilot#Enabled()
	if l:copilot_status == "1"
		return " "
	else
		return " "
	endif 
endfunction
