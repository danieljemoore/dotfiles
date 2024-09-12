set history=500
set encoding=utf-8
set updatetime=300
set signcolumn=yes

" set numbers on the side
set number

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "

" Fast saving
nmap <leader>w :w!<cr>
" Turn on the Wild menu
set wildmenu

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1
" Highlight search result
set hlsearch
" Makes search act like search in modern browsers
set incsearch
" Don't redraw while executing macros (good performance config)
set lazyredraw
" For regular expressions turn magic on
set magic
" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2
" Add a bit extra margin to the left
set foldcolumn=1

"=> Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable

set background=dark

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> Text, Tab, and Indent Related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=>Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <leader>/ /
map <leader>? ?
"Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ %=%l:%c

""""""""""""""""""""""""""""""
" => Vim-Plug
""""""""""""""""""""""""""""""
let data_dir = has('vim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'wincent/terminus'

  Plug 'nordtheme/vim'

  Plug 'preservim/nerdtree'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  Plug 'bfrg/vim-cpp-modern'

  Plug 'airblade/vim-gitgutter'
  Plug 'prabirshrestha/vim-lsp'

  if !has('vim')
    Plug 'rhysd/vim-healthcheck'
  endif
  Plug 'mattn/vim-lsp-settings'

  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }

  Plug 'junegunn/vim-github-dashboard'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

colorscheme nord

"Dissable function highlighting (affects both C and C++ files)
"let g:cpp_function_highlight = 0

" Enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" " Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" " Put all standard C and C++ keywords under Vim's highlight group 'Statement'
" " (affects both C and C++ files)
let g:cpp_simple_highlight = 1

nnoremap \ :NERDTreeToggle<CR>

" vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
