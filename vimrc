" My new .vimrc will start here.
" Time to start seriously taking
" advantage of this program

" ================================================ Notes ===

" gui_w32.txt Windows specific junk
" os_unix.txt Some Unix stuff

" internal-variables Information on variable namespaces

" ==================================== Start Up Settings ===

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-commentary'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'mbbill/undotree'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'godlygeek/tabular'

call vundle#end()
filetype plugin indent on

" Syntax highlighing
syntax on
" Try to detect filetypes
filetype on
" Enable loading indent file for filetype
filetype plugin indent on

let irdata = '_data'
let irdirs = {'backupdir': 'backup', 'dir': 'swap', 'undodir': 'undo'}
let irsplit = '/'
let irroot = '.vim'
if has("win32")
    if has("autocmd")
        " Starts gvim in full screen mode
        autocmd GUIEnter * simalt ~x
    endif
    let irsplit = '\\'
    let irroot = 'vimfiles'

    " Remove special windows keys (copy/paste/etc)
    set keymodel=

elseif has("unix")
    " Some attempts at nice fonts
    set guifont=Inconsolata\ 11,DejaVu\ Sans\ Mono\ 11,Courier\ 11

elseif has("gui_macvim")
    set lines=75
    set columns=78

endif

" Let's create our _data directory in the vim root.
let irdirname = expand('~' . irsplit . irroot . irsplit . irdata)
if !isdirectory(irdirname)
    call mkdir(irdirname)
endif

" Path to dictionary for vim to use in completion
for wordfile in ['dictionary', 'thesaurus']
    let path = expand('~' . irsplit . irroot . irsplit .  wordfile . ".txt")
    let cmd = "set " . wordfile . "+=" . path
    exec cmd
endfor

" Create the dirs we need.  A little loop will do just fine.
" We'll also go ahead and assign the directories to their options.
for dir in keys(irdirs)
    let tmp = irdirname . irsplit . irdirs[dir]
    if !isdirectory(tmp)
        call mkdir(tmp)
    endif
    let cmd = "set " . dir . "=" . tmp
    exec cmd
endfor

if has("gui_running")
    if has("autocmd")
        augroup clear_cursorcolumn
            " Stolen from TPetticrew's vimrc
            " Remove line/column selection on inactive panes
            autocmd!
            autocmd WinEnter * setlocal cursorcolumn
            autocmd WinLeave * setlocal nocursorcolumn
        augroup END
    endif

    " Highlight the cursor column
    set cuc
    " Highlight the cursor line
    set cul

    " Make the mouse disappear when in vim
    set mousehide
    " Give me just the code area. No need for toolbars
    set guioptions=ac
    " My colorsceme
    colorscheme molokai
    let g:molokai_original=0
else
    " Adapt colors for dark background
    colorscheme slate
    set background=dark
    set t_Co=256
endif

" ======================================= Basic Settings ===
" Make command line one line high
set ch=1
" Keep 3 lines when scrolling
set scrolloff=3
" Always set autoindenting on
set autoindent
" Always set smartindent on
set smartindent
" Turn off erroring and beeping
set visualbell
set noerrorbells
set t_vb=
" Show title in console title bar
set title
" Don't jump to first character when paging
set nostartofline
" Start,indent,eol
set backspace=2
" Show matching <> (html mainly) as well
set matchpairs+=<:>
" Jump to matching brace immediately after insert
set showmatch
" Time vim will sit on the matching brace
set matchtime=3
" Abbreviate messages
set shortmess=atI
" Highlight search items
set hlsearch
" Tab complete commands
set wildmenu
" New feature that will ignore case whne completing commandline
set wildignorecase
" Complete from a Dictionary if possible
set complete+=,k
" List longest first. Don't know if I want this
set wildmode=longest,list,full
" Whoever wanted to modify a .pyc?
set wildignore+=*.pyc,*.autosave,*~,*.exr,*.png,*.gif,*.bcd,*.jpg,*.jpeg,*.mp4,*.pc2,*.aus,*.hip,*.abc,*.xcf,*.pdf,*.tgz,*.tar,*.gz
" Commandline remembrance
set history=10000
" Give me lots of Undos
set undolevels=100000
" Let my cursor go everywhere
set virtualedit=all
" Search as I type
set incsearch
" Use the / instead of \
set shellslash
set shell=/bin/sh
" No word wrap
set nowrap
" Settings for vim to remember stuff on startup :help viminfo
set viminfo='1000,h
" Always show status line
set laststatus=2
" Harder to explain but an awesome statusline just for me
" %r tells me if the file is readonly
" %{fugitive#statusline()} Lets me know what Git branch I'm in.
" %{expand('%:p')} gives me the full path to the file
" %l/%L current line and total lines
" %v current column
set statusline=\ [%r]\ %n\ %{fugitive#statusline()}\ F:%{expand('%:p')}\ L:%l/%L\ C:%v
" This removes the characters between split windows (and some other junk)
set fillchars="-"
" This allows vim to work with buffers much more liberally. So no warnings when switching modified buffers
set hidden
" Persistent undos
set undofile
" What information to lsave when creating a session.
set sessionoptions=buffers,resize,winpos,winsize
" Turning the mouse off.  Suck it mouse users.
set mouse=""
" Setting the language to everything NOT American English.
set spelllang=en_gb,en_nx,en_au,en_ca
" Ensure that all my auto formatting is minimal
set formatoptions=""

if has("autocmd")
    " I've set up these groups at the recommendation of Steve Losh's
    " Learn Vimscript the Hardway
    " augroup clear_whitespace
    "     " Automatically delete trailing white spaces
    "     autocmd!
    "     autocmd BufWrite * :silent! %s/[\r \t]\+$//
    "     " * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    "     autocmd BufEnter *.php :%s/[ \t\r]\+$//e
    " augroup END
    augroup clear_cursorline
        " Remove line/column selection on inactive panes
        autocmd!
        autocmd BufEnter * setlocal cursorline
        autocmd WinLeave * setlocal nocursorline
    augroup END

    augroup set_working_path
        " Set current directory to that of the opened files
        autocmd!
        autocmd BufEnter,BufWrite * silent! lcd %:p:h
    augroup END

    augroup set_filetypes
        " Set some filtype stuff up
        autocmd!
        autocmd BufRead,BufNewFile *.ma setf mel
        autocmd BufRead,BufNewFile *.rpp setf cpp
        autocmd BufRead,BufNewFile SConstruct setf python
        autocmd BufRead,BufNewFile wscript setf python
        autocmd BufNewFile,BufRead *.z* setlocal filetype=zsh
    augroup END

    augroup set_tabbing
        " Filetype specific tabbing
        autocmd!
        autocmd FileType * setlocal ts=4 sts=4 sw=4 noexpandtab cindent
        autocmd FileType python,vim,vimrc setlocal ts=4 sts=4 sw=4 expandtab
    augroup END

    augroup set_commentary
        " Filetype specific tabbing
        autocmd!
        autocmd FileType cpp let &l:commentstring="// %s"
    augroup END

    augroup set_text_width
        " Set default textwidth
        autocmd!
        autocmd BufEnter * let b:textwidth=100
        autocmd Filetype python let b:textwidth=100
    augroup END

    augroup enable_syntax_highlighting
        autocmd!
        autocmd! BufWinEnter,WinEnter * nested if exists('syntax_on') && ! exists('b:current_syntax') && ! empty(&l:filetype) && index(split(&eventignore, ','), 'Syntax') == -1 | syntax enable | endif
        autocmd! BufRead * if exists('syntax_on') && exists('b:current_syntax') && ! empty(&l:filetype) && index(split(&eventignore, ','), 'Syntax') != -1 | unlet! b:current_syntax | endif
    augroup END
    augroup clean_fugitive_buffers
        autocmd BufReadPost fugitive://* set bufhidden=delete
        autocmd User fugitive if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' | nnoremap <buffer> .. :edit %:h<CR> | endif
    augroup END
endif

" Setup command to easily call to run python buffer
command! RunPythonBuffer call DoRunPythonBuffer()
" Run current buffer in python
noremap <leader>p :RunPythonBuffer<CR>
" Echo current file path and put in middle mouse buffer
noremap <leader>f :let @*=expand('%:p')<CR>:echom @*<CR>

" ========================================== Key Binding ===
" Match the lines that are too long.
noremap <leader>m :ToggleLineLengthHighlight<CR>
" Shortcut to grab last inserted text
noremap gV `[v`]
noremap gVV `[V`]
" Go to the middle of the line.  This is an override of the built in gm
" which jumps to the middle of the line based on screen width instead of text.
noremap gm :GoMiddleOfLine<CR>
" Turning off the stupid man pages thing
noremap K <Nop>
" Shortcut to rapidly toggle `set list`
noremap <leader>l :set list!<CR>
" This if for custom wrap toggle
noremap <silent> <leader>w :set invwrap<CR>:set wrap?<CR>
" Clear highlights with spacebar
noremap <silent> <Space> :nohlsearch <CR>
" Allow me to scroll horizontally
noremap <silent> <leader>o 30zl
noremap <silent> <leader>i 30zh
" Allows the resizing windows horizontally
noremap <leader>. <C-w>20>
noremap <leader>, <C-w>20<
" Map to quickly open and reload my vimrc
noremap <leader>v :e $MYVIMRC<CR><C-W>_
noremap <silent> <leader>V :w<CR> :source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
noremap <leader>g :e $MYGVIMRC<CR><C-W>_
noremap <silent> <leader>G :w<CR> :source $MYGVIMRC<CR>:filetype detect<CR>:exe ":echo 'gvimrc reloaded'"<CR>
" Sometimes I don't want spelling
noremap <leader>s :setlocal spell! spelllang=en_gb<CR>
" Time to start hating myself.  I must learn to use <c-[> to get into normal mode.
" I can't keep the C-[ binding because that is apparently exactly escape.
" inoremap <esc> <nop>
" There are no known words in the dictionary that start with kj so I will use this.
" inoremap kj <es
noremap <leader>sy :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax on <Bar> endif <CR>c>

noremap <leader>ws :%s/\s\+$//e<CR>

" ====================================== Plugin Settings ===

nnoremap <F5> :UndotreeToggle<CR>
" let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

nmap <leader>c <Plug>CommentaryLine
vmap <leader>c <Plug>Commentary

"Additional python syntax highlighting
let python_highlight_all=1

" workaround for https://github.com/vim/vim/issues/1start671
if has("unix")
  let s:uname = system("echo -n \"$(uname)\"")
  if !v:shell_error && s:uname == "Linux"
    set t_BE=
  endif
endif

