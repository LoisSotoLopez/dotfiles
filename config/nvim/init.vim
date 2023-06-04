" Plugins will be downloaded under the specified directory.
call plug#begin('~/.local/share/nvim/site/plugged')

" Declare the list of plugins.
Plug 'vim-airline/vim-airline'

" Visual Settings
Plug 'junegunn/limelight.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Enable line numbering
set number

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Spacing and tabs
set tabstop=4 " VISUAL spaces per TAB
set softtabstop=4 " spaces in tab when editing
set shiftwidth=4 " spaces to use for autoindent

set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the 
                            " right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line 
                            " just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                  " set an 80 column border for good coding style
set textwidth=80            " set maximum text width at 80 characters
set wrapmargin=0            " make text wrap exactly at the end of the text width
highlight ColorColumn ctermbg=7 
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard 
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim set spell 
							" enable spell check (may need to 
							" download language package)

"""""""""""""""""""""""""""""""""""""""""""""""""
" Color Settings
"""""""""""""""""""""""""""""""""""""""""""""""""
syntax on


"""""""""""""""""""""""""""""""""""""""""""""""""
" UI Settings
"""""""""""""""""""""""""""""""""""""""""""""""""
" Keep cursor in the middle of the page, useful for editing text
set so=999

call plug#begin("~/.vim/plugged")
 " Plugin Section
 "Plug 'SirVer/ultisnips'
 "Plug 'honza/vim-snippets'
 " Complettion engine
 "Plug 'neoclide/coc.nvim', {'branch': 'release'}
 
 " nvim-tree
 Plug 'nvim-tree/nvim-web-devicons' " optional, file icons
 Plug 'nvim-tree/nvim-tree.lua'
 " embeded terminal
 Plug 'akinsho/toggleterm.nvim'
call plug#end()

lua require('init')
lua require('keymaps')
lua require'nvim-tree'.setup { remove_keymaps = true, }
lua require'toggleterm'.setup { open_mapping = [[<c-t>]],}

" Make netrw split let open the new window at right side
let g:netrw_altv=1
"""""""""""""""""""""""""""""""""""""""""""""""""
" KEYMAPS 
"""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","
nnoremap <leader>e :vs
nnoremap <leader>m <C-w>w<CR>
nnoremap <leader>n <C-w>W<CR>
nnoremap <leader>r <C-w>=<CR>

