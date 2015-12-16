"#############################################################################
"
" Vim Configuration
" Zac Hester <zac.hester@gmail.com>
"
"#############################################################################

"-----------------------------------------------------------------------------
" .vimrc Boilerplate
"-----------------------------------------------------------------------------

set nocompatible        " disable vi compatibility features (must come first)
scriptencoding utf-8    " set how Vim should handle this script (.vimrc)
set encoding=utf-8      " set how Vim handles text internally (multibyte)

"=============================================================================
" Functions Used in This Configuration
"=============================================================================

"-----------------------------------------------------------------------------
" Retrieves basic file information.
"-----------------------------------------------------------------------------
function! GetFileInfo()
    let l:finfo = &fileformat . ','
    if strlen( &fileencoding )
        let finfo .= &fileencoding
    else
        let finfo .= &encoding
    endif
    return finfo . ',' . &filetype
endfunction

"-----------------------------------------------------------------------------
" Retrieves various toggle states.
"-----------------------------------------------------------------------------
function! GetToggleStates()
    let l:toggle_states = ''
    " Search highlighting <F6>
    if &hlsearch
        let toggle_states .= 'H'
    endif
    " Automatic line wrapping <F7>
    if &formatoptions =~ 't'
        let toggle_states .= 'W'
    endif
    " Spell checking <F8>
    if &spell
        let toggle_states .= 'S'
    endif
    " Paste mode <F9>
    if &paste
        let toggle_states .= 'P'
    endif
    return toggle_states
endfunction

"-----------------------------------------------------------------------------
" Tests for the presence of a plugin given its name.
"-----------------------------------------------------------------------------
function! HasPlugin( plugin_name )
    if isdirectory( expand( '$HOME/.vim/bundle/' . a:plugin_name ) )
        return 1
    endif
    return 0
endfunction

"-----------------------------------------------------------------------------
" Toggles textwidth-based line wrapping.
"-----------------------------------------------------------------------------
function! ToggleAutoWrap()
    if &formatoptions =~ 't'
        set formatoptions-=t
    else
        set formatoptions+=t
    endif
    set formatoptions?
endfunction

"-----------------------------------------------------------------------------
" Toggles traditional (non-relative) line numbering.
"-----------------------------------------------------------------------------
function! ToggleNumber()
    " if both are enabled, disable relative numbering
    if &number && &relativenumber
        set norelativenumber
    " if enabled, disable
    elseif &number
        set nonumber
    " if relative numbering is displayed, switch to traditional
    elseif &relativenumber
        set norelativenumber
    " if both are disabled, enable both
    else
        set norelativenumber
        set number
    endif
    set number?
endfunction

"-----------------------------------------------------------------------------
" Toggles relative line numbering.
"-----------------------------------------------------------------------------
function! ToggleRelativeNumber()
    " if both are enabled, disable both
    if &relativenumber && &number
        set nonumber
        set norelativenumber
    " if enabled, disable
    elseif &relativenumber
        set norelativenumber
    " if traditional numbering is displayed, switch to relative
    elseif &number
        set relativenumber
    " if both are disabled, enable both
    else
        set number
        set relativenumber
    endif
    set relativenumber?
endfunction

"=============================================================================
" Basic Setup
"=============================================================================

"-----------------------------------------------------------------------------
" Host System Interaction
"-----------------------------------------------------------------------------

set autoread            " detect external modifications to files
set fileencoding=utf-8  " write all files as utf-8
set hidden              " keep invisible buffers in memory
set nobackup            " do not create backup files
set noswapfile          " do not create swap files

"-----------------------------------------------------------------------------
" Terminal Settings
"-----------------------------------------------------------------------------

" set mouse=a         " enable mouse input in all modes
set t_ti=[?47h    " on init, push terminal state to alternate buffer
set t_te=[?47l    " on exit, pop terminal state from alternate buffer
set title           " attempt to set console's title bar
" set ttymouse=xterm  " attempt to enable mouse input over TTY

" Allow bright colors without requiring bold (helpful on physical terminals).
if ( &t_Co == 8 ) && ( $TERM !~# '^linux' )
    set t_Co=16
endif

"-----------------------------------------------------------------------------
" Display Settings
"-----------------------------------------------------------------------------

set colorcolumn=81              " color column 81
set cursorline                  " color the current line
set diffopt=vertical            " always split diff views vertically
set fillchars=vert:\│           " use a long pipe for the vertical split
set laststatus=2                " always show the statusline
set list                        " show non-text characters
set listchars=tab:»·,trail:·    " how to display non-text characters
set nofoldenable                " disable code folding entirely
set ruler                       " show cursor position in corner
set scrolloff=4                 " start scrolling before edge is reached
set showcmd                     " show incomplete commands on bottom
set showmode                    " show current mode on bottom
" set spell spelllang=en_us       " enable spell checking by default

" Use new linebreak-indent feature.
if exists( '+breakindent' )
    set breakindent
    let &showbreak = '   →'
end

" Enable syntax highlighting.
syntax enable on

"-----------------------------------------------------------------------------
" Text Entry and Manipulation
"-----------------------------------------------------------------------------

set backspace=indent,eol,start       " allow backspace in insert mode
set nrformats=hex                    " CTRL-A/CTRL-X inc/dec hex, too
set omnifunc=syntaxcomplete#Complete " enable omni completion
set textwidth=78                     " columns for wrapping/automatic re-flow
set formatoptions=tcrqljn            " default format options:
    "             ^^^^^^^
    "             ||||||+------------- handle indenting with numbered lists
    "             |||||+-------------- reassemble comments when joining
    "             ||||+--------------- do not auto-format lines past textwidth
    "             |||+---------------- allow comment re-flow with "gq"
    "             ||+----------------- auto-insert comment leader (insert)
    "             |+------------------ auto-format comments
    "             +------------------- auto-format text

" Enable file-based undo history.
if has( 'persistent_undo' )
    let s:udir = expand( '$HOME/.vim/undodir' )
    if !isdirectory( s:udir )
        call mkdir( s:udir, 'p' )
    endif
    set undodir=s:udir
    set undofile
    set undolevels=500
    set undoreload=10000
endif

"-----------------------------------------------------------------------------
" Searching and Substitution
"-----------------------------------------------------------------------------

set gdefault    " substitute globally by default
set hlsearch    " highlight all matching search terms
set ignorecase  " ignore case in searches
set incsearch   " show search hits as they are typed
set showmatch   " highlight matching brackets
set smartcase   " use smart case in searches

"-----------------------------------------------------------------------------
" Code and Project Management
"-----------------------------------------------------------------------------

set tags=tags;  " look "up" for tags files

"-----------------------------------------------------------------------------
" Custom statusline
"-----------------------------------------------------------------------------

" clip overflow to the left
set statusline=%<\ 

" file name
set statusline+=%#SLFileName#%f%*

" file's git status
if HasPlugin( 'vim-fugitive' )
    set statusline+=%(│%{fugitive#statusline()}%)
endif

" file state flags
set statusline+=%(│%#SLFlags#%M%R%H%W%*%)

" left-to-right-side separator
set statusline+=%=

" cursor|line coordinates
set statusline+=%#SLCursor#%2c,%l%*│%#SLPlace#%p%%\/%L%*

" value of character under cursor
set statusline+=│0x%02B

" interface's toggle states
set statusline+=%(│%#SLToggle#%{GetToggleStates()}%*%)

" file information
set statusline+=│%#SLFileInfo#%{GetFileInfo()}%*\ 

"-----------------------------------------------------------------------------
" Command Entry Completion
"-----------------------------------------------------------------------------

set wildchar=<Tab>                 " start command entry completion
set wildcharm=<C-Z>                " start command entry completion (macros)
set wildignore=.git,.svn,*.o,*.pyc " files to ignore in completions
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.pdf,*.zip,*.tar,*.gz,*.bz2
set wildignore+=*.doc,*.docx,*.xls,*.xlsx,*.ppt,*.pptx
set wildignore+=*.exe,*.dll,*.jar
set wildignore+=*.sdf,*.suo,*.opensdf
set wildmenu                       " enable command entry auto-completion

"-----------------------------------------------------------------------------
" Code Indentation
"-----------------------------------------------------------------------------

set autoindent          " automatic indent on new lines
set expandtab           " use spaces instead of tabs
set pastetoggle=<F9>    " paste toggle to disable automatic indentation
set shiftround          " maintain tab space intervals
set shiftwidth=4        " number of spaces to use for autoindent
set softtabstop=4       " number of spaces to insert for tabs
set tabstop=4           " number of spaces to display for tabs

"=============================================================================
" Event-based Automation
"=============================================================================

if has( 'autocmd' )

    "-------------------------------------------------------------------------
    " Set up an autocommand group for the user configuration.
    "-------------------------------------------------------------------------
    augroup vimrc
        autocmd!
    augroup END

    "-------------------------------------------------------------------------
    " File-type Overrides
    "-------------------------------------------------------------------------

    " Disable expandtab setting for make files.
    autocmd vimrc FileType make setlocal noexpandtab

    " Adjust tab settings for some web source files.
    autocmd vimrc FileType html setlocal shiftwidth=2 softtabstop=2
    autocmd vimrc FileType css setlocal shiftwidth=2 softtabstop=2

    " Always enable spell checking in markdown files.
    autocmd vimrc FileType markdown setlocal spell spelllang=en_us

    " My ".h" headers are never C++.
    autocmd vimrc BufNewFile,BufReadPost *.h setlocal filetype=c

    " Use MySQL dialect for SQL syntax highlighting.
    autocmd vimrc BufNewFile,BufReadPost *.sql setlocal filetype=mysql

    " I've never opened a "Modula-2" file.
    autocmd vimrc BufNewFile,BufReadPost *.md setlocal filetype=markdown

    " Highlight JSON as JavaScript (now that they're different filetypes?).
    autocmd vimrc BufNewFile,BufReadPost *.json setlocal filetype=javascript

    " Highlight Vimperator configuration files.
    autocmd vimrc BufNewFile,BufReadPost [._]vimperatorrc setlocal filetype=vim

    "-------------------------------------------------------------------------
    " File/Buffer/Window Behavior Overrides
    "-------------------------------------------------------------------------

    " Do not trigger auto-indentation when typing a colon.
    autocmd vimrc BufEnter * setlocal indentkeys-=<:>

    " Never leave trailing whitespace when auto-wrapping.
    autocmd vimrc BufEnter * setlocal formatoptions-=w

    " Never insert comment leader when opening a new line.
    autocmd vimrc BufEnter * setlocal formatoptions-=o

    " Always auto-wrap text (until toggled off).
    autocmd vimrc BufEnter * setlocal formatoptions+=t

    " Re-open files at their last position.
    autocmd vimrc VimEnter *
        \ if line( "'\"" ) > 1 && line( "'\"" ) <= line( "$" ) |
        \     exe "normal! g`\"" |
        \ endif

    " Resize split windows when the terminal resizes.
    autocmd vimrc VimResized * =

endif

"=============================================================================
" Custom Commands
"=============================================================================

" Save the buffer and close only this buffer (:wq for buffers).
cnoreabbrev bq update<bar>bdelete
cnoreabbrev bx update<bar>bdelete

"=============================================================================
" Custom Key Mapping
"=============================================================================

"-----------------------------------------------------------------------------
" Override Default Behaviors
"-----------------------------------------------------------------------------

" Do not use the default register when deleting single characters.
nnoremap x "xx

" Do not use the default register when pasting in visual mode.
"vnoremap p "xc<Esc>p

" Make default regular expression entry less annoying.
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" Adjust home/end line movement keys.
nnoremap 0 ^
vnoremap 0 ^
nnoremap ^ 0
vnoremap ^ 0
nnoremap - $
vnoremap - $

" Make Y behave like C and D (since yy duplicates the functionality).
nnoremap Y y$

"-----------------------------------------------------------------------------
" General Convenience Key Bindings
"-----------------------------------------------------------------------------

" Create new bindings for treating parts of symbol names as text objects.
onoremap <silent>au :<C-u>execute 'normal! T_v' . v:count1 . 'f_'<CR>
onoremap <silent>iu :<C-u>execute 'normal! T_v' . v:count1 . 't_'<CR>
vnoremap <silent>au :<C-u>execute 'normal! T_v' . v:count1 . 'f_'<CR>
vnoremap <silent>iu :<C-u>execute 'normal! T_v' . v:count1 . 't_'<CR>

" If the terminal can send CTRL+s, use it to save the buffer.
nnoremap <silent> <C-s> :update<CR>
vnoremap <silent> <C-s> <C-c>:update<CR>
inoremap <silent> <C-s> <C-o>:update<CR>

" Send escape instead of opening help.
nnoremap <F1> <Esc>
vnoremap <F1> <Esc>
inoremap <F1> <Esc>

" Reload .vimrc.
nnoremap <silent> <F2> :source $MYVIMRC<CR>

" Reload current syntax highlighting.
nnoremap <silent> <F3> :syntax enable<CR>

" nnoremap <silent> <F4>

" Execute the current make command.
nnoremap <silent> <F5> :make<CR>

" Toggle highlighting.
nnoremap <silent> <F6> :set hlsearch!<CR>

" Toggle automatic wordwrapping.
nnoremap <silent> <F7> :call ToggleAutoWrap()<CR>
inoremap <silent> <F7> <C-o>:call ToggleAutoWrap()<CR>

" Toggle spell checking.
nnoremap <silent> <F8> :setlocal spell! spelllang=en_us<CR>

" <F9> mapped to paste toggle

" nnoremap <silent> <F10>
" nnoremap <silent> <F11>
" nnoremap <silent> <F12>

"-----------------------------------------------------------------------------
" Shortcuts to Common Commands/Features
"-----------------------------------------------------------------------------

" Use space bar for the leader.
let g:mapleader = ' '

" nnoremap <silent> <Leader>a

" Start the built-in explorer in the current directory.
nnoremap <silent> <Leader>b :Explore<CR>

" Open a different file browser in the current directory.
if has( 'win32unix' )
    nnoremap <silent> <Leader>B :!explorer .<CR><CR>
endif

" System clipboard interaction.
if has( 'clipboard' )

    " Paste from system clipboard.
    nnoremap <Leader>cp :setlocal paste<CR>"+p<CR>:setlocal nopaste<CR>

    " Copy to system clipboard.
    nnoremap <Leader>cc "+y
    vnoremap <Leader>cc "+y
endif

" Put currently open buffers (in separate windows) in diff mode.
nnoremap <silent> <Leader>d :diffthis<CR>

" Disable diff mode.
nnoremap <silent> <Leader>D :diffoff<CR>

" Execute contents of current line.
nnoremap <silent> <Leader>e "eyy:@e<CR>

" Execute contents of current selection.
vnoremap <silent> <Leader>e "ey:'<,'>@e<CR>

" Search across all open buffers.
nnoremap <Leader>fb :cexpr []
    \ <BAR> bufdo vimgrepadd @\v@g %
    \ <BAR> cwindow<S-Left><S-Left><S-Left><S-Left><Right><Right><Right>

" Search more interactively than normal `/|?` searches.
nnoremap <Leader>fi :vimgrep @\v@g %
    \ <BAR> cwindow<S-Left><S-Left><S-Left><S-Left><Right><Right><Right>

" Search across all source files in current directory.
nnoremap <Leader>fs :vimgrep @\v@g *
    \ <BAR> cwindow<S-Left><S-Left><S-Left><S-Left><Right><Right><Right>

" Open and close the quickfix window.
nnoremap <silent> <Leader>fo :cwindow<CR>
nnoremap <silent> <Leader>fc :cclose<CR>

" nnoremap <silent> <Leader>g in use by Gundo plugin

" Convert decimal numbers to hexadecimal.
nnoremap <silent> <Leader>h :D2H<CR>
vnoremap <silent> <Leader>h :'<,'>D2H<CR>

" Convert hexadecimal numbers to decimal.
nnoremap <silent> <Leader>H :H2D<CR>
vnoremap <silent> <Leader>H :'<,'>H2D<CR>

" Highlight the last insertion.
nnoremap <silent> <Leader>i `[v`]

" Split the current line opposite the default join operation.
nnoremap <silent> <Leader>j :call code#SplitLine()<CR>

" nnoremap <silent> <Leader>k

" Open buffer list (wildmenu) with current buffers listed.
nnoremap <Leader>l :b <C-Z>

" Normalize quick-entry comments into nice-looking block comments.
nnoremap <silent> <Leader>m :call code#CommentBlock()<CR>
nnoremap <silent> <Leader>M :call code#CommentBlock( line( '.' ), 70 )<CR>

" Toggle line numbering.
nnoremap <silent> <Leader>n :call ToggleNumber()<CR>

" Toggle relative line numbering.
nnoremap <silent> <Leader>N :call ToggleRelativeNumber()<CR>

" nnoremap <silent> <Leader>o

" Start CtrlP directly in buffer mode or MRU mode.
nnoremap <Leader>p :CtrlPBuffer<CR>
nnoremap <Leader>P :CtrlPMRU<CR>

" nnoremap <silent> <Leader>q

" Trim trialing whitespace.
nnoremap <silent> <Leader>r :%s/\s\+$//ge<CR>
vnoremap <silent> <Leader>r <C-c>:%s/\%V\s\+$//ge<CR>

" nnoremap <silent> <Leader>s

" Initiate a surround on the current word text object (needs character)
nmap <Leader>S ysiw

" nnoremap <silent> <Leader>t in use by taglist plugin

" Convert to UNIX line endings.
nnoremap <Leader>u :set ff=unix<CR>:update<CR>

" nnoremap <silent> <Leader>v in use by Vundle plugin

" Bootstraps Vundle for plugin acquisition and management.
nnoremap <Leader>V :!git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim<CR>

" nnoremap <silent> <Leader>w

" Filter buffer through `xxd` (hex dump).
nnoremap <silent> <Leader>x :%!xxd<CR>

" Display syntax match group.
nnoremap <silent> <Leader>y :echo "hi<"
    \ . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" nnoremap <silent> <Leader>z in use by vim-hz plugin (Vim memory)

"=============================================================================
" Plugins
"=============================================================================

" Allows this configuration to be used on systems without Vundle
if filereadable( expand( '~/.vim/bundle/Vundle.vim/autoload/vundle.vim' ) )

    "-------------------------------------------------------------------------
    " Vundle Setup
    "-------------------------------------------------------------------------

    " Vundle runtime path bootstrapping
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    " List of plugins to manage
    Plugin      'gmarik/Vundle.vim'         " Vundle plugin manager plugin

    " Plugins that are only used for development.
    if empty( $NODEVMODE ) && ( $USER != 'root' )
    Plugin         'sjl/gundo.vim'          " undo tree browser
    "Plugin   'godlygeek/tabular'            " table auto-formatter
    Plugin 'vim-scripts/taglist.vim'        " visual tag browser/navigator
    Plugin      'tomtom/tlib_vim'           " required by vim-snipmate
    Plugin   'MarcWeber/vim-addon-mw-utils' " required by vim-snipmate
    Plugin  'craigemery/vim-autotag'        " automatic ctags synchronizing
    Plugin       'tpope/vim-fugitive'       " git integration
    Plugin     'zhester/vim-grm'            " Garmin-style snippets
    Plugin       'tpope/vim-obsession'      " better session management
    Plugin      'garbas/vim-snipmate'       " TextMate-style text snippets
    endif

    " Plugins that are always available.
    "Plugin        'kien/ctrlp.vim'          " fuzzy file finder
    Plugin    'ctrlpvim/ctrlp.vim'          " maintained fuzzy file finder
    Plugin     'zhester/vim-hz'             " personal plugin
    Plugin       'tpope/vim-repeat'         " repeat works with some plugins
    Plugin       'tpope/vim-surround'       " fast quote/bracket manipulation

    " All plugins declared
    call vundle#end()

    "-------------------------------------------------------------------------
    " Individual Plugin configuration
    "-------------------------------------------------------------------------

    " Vundle
    nnoremap <Leader>v :PluginInstall<CR>\|:PluginUpdate<CR>\|:bdelete<CR>

    " Gundu
    nnoremap <silent> <Leader>g :GundoToggle<CR>

    " snipmate
        " do not include C snippets when editing C++ files
        " do not include HTML and JavaScript snippets when editing PHP files
    let g:snipMate = {}
    let g:snipMate.no_default_aliases = 1

    " taglist
    nnoremap <silent> <Leader>t :TlistToggle<CR>
    let g:Tlist_Exit_OnlyWindow = 1 " close vim if only tag list is open
    let g:Tlist_Use_SingleClick = 1 " single-clicking on tags jumps to them
    let g:Tlist_Inc_Winwidth    = 0 " do not resize console for tag window
    let g:Tlist_GainFocus_On_ToggleOpen = 1 " focus on taglist

    " vim-hz
    if filereadable( expand( '~/.vim/bundle/vim-hz/colors/desolarized.vim' ) )
        colorscheme desolarized     " personal color theme
    endif
    nnoremap <silent> <Leader>z :echo memory#OfTheDay()<CR>
    nnoremap <silent> <Leader>Z :echo memory#Random()<CR>

" Vundle/plugins not available.  Assume some reasonable fall-backs.
else

    "-------------------------------------------------------------------------
    " Display Configuration
    "-------------------------------------------------------------------------
    set background=dark " intended for use on dark consoles

endif

"-----------------------------------------------------------------------------
" File-based Configuration (Must come after plugin loading.)
"-----------------------------------------------------------------------------

" Enable file-type-based features.
filetype plugin indent on

"=============================================================================
" Local Overrides
"=============================================================================

let s:local_overrides = expand( '~/.vimrc.local' )
if filereadable( s:local_overrides )
    exec 'source ' . s:local_overrides
endif

