syntax on

set relativenumber

set hlsearch
set incsearch

set paste
set wildmenu
set smarttab
set showmatch

set t_Co=256
set background=dark
colorscheme elflord
 
set clipboard=unnamedplus 

" Tab 4 chars, hotkeys 'c - t' ->, 'c - d' <- 
set tabstop=4 softtabstop=-1 shiftwidth=0 expandtab
set backspace=indent,eol,start
" Exec NerdTree plugin 
map <C-n> :NERDTreeToggle<CR>