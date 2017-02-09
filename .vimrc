" Colors
colorscheme default			" color scheme
"colorscheme molokai			" color scheme
syntax enable				" enable syntax processing. duh.

" Spacing and Tabs
set tabstop=4				" number of visual spaces per TAB
set softtabstop=4			" number of visual spaces inserted per TAB
set expandtab				" tabs to spaces
set autoindent
"filetype indent on			" load filetype-specific indent files

" UI Config
set number				    " show line numbers
set cursorline				" highlight current line

set showcmd				    " show command in bottom bar. possibly replace with plugin powerline
set wildmenu				" visual autocomplete for command menu

set showmatch				" highlight matching [{()}]

set lazyredraw 				" redraw only when we need to

set incsearch				" search as characters are entered
set hlsearch				" hightlight search matches
" let mapleader=","
" nnoremap <leader><space> :noh

" TODO: gundo.vim plugin
" nnoremap <leader>u :gundoToggle<CR>


" TODO: map something to turn off highlights after search

" Folding
" TODO: figure out folding or get a plugin to do it
" set foldenable				" enable folding
" set foldlevelstart=10		" open most folds by default 0-99
" set foldnestmax=10			" 10 nested fold max




""set runtimepath+=~/.vim_runtime
"
""source ~/.vim_runtime/vimrcs/basic.vim
""source ~/.vim_runtime/vimrcs/filetypes.vim
""source ~/.vim_runtime/vimrcs/plugins_config.vim
""source ~/.vim_runtime/vimrcs/extended.vim
"
""try
""source ~/.vim_runtime/my_configs.vim
""catch
""endtry
"
"
"
"
"
"
"" An example for a vimrc file.
""
"" Maintainer:	Bram Moolenaar <Bram@vim.org>
"" Last change:	2014 Feb 05
""
"" To use it, copy it to
""     for Unix and OS/2:  ~/.vimrc
""	      for Amiga:  s:.vimrc
""  for MS-DOS and Win32:  $VIM\_vimrc
""	    for OpenVMS:  sys$login:.vimrc
"
"" When started as "evim", evim.vim will already have done these settings.
"if v:progname =~? "evim"
"  finish
"endif
"
"" Use Vim settings, rather than Vi settings (much better!).
"" This must be first, because it changes other options as a side effect.
"set nocompatible
"
"" allow backspacing over everything in insert mode
"set backspace=indent,eol,start
"
""if has("vms")
""  set nobackup		" do not keep a backup file, use versions instead
""else
""  set backup		" keep a backup file (restore to previous version)
""  set undofile		" keep an undo file (undo changes after closing)
""endif
"set hidden
"set nobackup
"set noswapfile
"set history=50		" keep 50 lines of command line history
"set ruler		" show the cursor position all the time
"set showcmd		" display incomplete commands
"set incsearch		" do incremental searching
"
"set cursorline                  " color the current line
"set diffopt=vertical            " always split diff views vertically
"set fillchars=vert:\¦           " use a long pipe for the vertical split
"set laststatus=2                " always show the statusline
"set list                        " show non-text characters
"set listchars=tab:»·,trail:·    " how to display non-text characters
"set nofoldenable                " disable code folding entirely
"set number                      " show line numbers on side
"set ruler                       " show cursor position in corner
"set scrolloff=4                 " start scrolling before edge is reached
"set showcmd                     " show incomplete commands on bottom
"set showmode                    " show current mode on bottom
"" set spell spelllang=en_us       " enable spell checking by default
"set background=dark
"colorscheme molokai
"
"" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
"" let &guioptions = substitute(&guioptions, "t", "", "g")
"
"" Don't use Ex mode, use Q for formatting
"map Q gq
"
"" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
"" so that you can undo CTRL-U after inserting a line break.
"inoremap <C-U> <C-G>u<C-U>
"
"" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif
"
"" Switch syntax highlighting on, when the terminal has colors
"" Also switch on highlighting the last used search pattern.
"if &t_Co > 2 || has("gui_running")
"  syntax on
"  set hlsearch
"endif
"
"set autoindent                  " automatic indent on new lines
"set pastetoggle=<F9>            " paste toggle to disable automatic indentation
"
"
"" Only do this part when compiled with support for autocommands.
"if has("autocmd")
"
"  " Enable file type detection.
"  " Use the default filetype settings, so that mail gets 'tw' set to 72,
"  " 'cindent' is on in C files, etc.
"  " Also load indent files, to automatically do language-dependent indenting.
"  filetype plugin indent on
"  set tabstop=4
"  set shiftwidth=4
"  set expandtab
"  " Put these in an autocmd group, so that we can delete them easily.
"  augroup vimrcEx
"  au!
"
"  " For all text files set 'textwidth' to 78 characters.
"  autocmd FileType text setlocal textwidth=78
"
"  " When editing a file, always jump to the last known cursor position.
"  " Don't do it when the position is invalid or when inside an event handler
"  " (happens when dropping a file on gvim).
"  " Also don't do it when the mark is in the first line, that is the default
"  " position when opening a file.
"  autocmd BufReadPost *
"    \ if line("'\"") > 1 && line("'\"") <= line("$") |
"    \   exe "normal! g`\"" |
"    \ endif
"
"  augroup END
"
"else
"
"  set autoindent		" always set autoindenting on
"
"endif " has("autocmd")
"
"" Convenient command to see the difference between the current buffer and the
"" file it was loaded from, thus the changes you made.
"" Only define it when not defined already.
"if !exists(":DiffOrig")
"  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
"		  \ | wincmd p | diffthis
"endif
"
