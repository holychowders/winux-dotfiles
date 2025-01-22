" Requirements:
"  vim-plug
"  fzf.vim
"  ripgrep
"  ctags

" TODO:
"   Save marks across sessions
"   List and preview/select marks
"   Display marks in gutter
"   Quickly switch between buffers
"   Persist buffers across sessions
"   Programming:
"     Symbol outline
"     Goto definition
"     Hover definition
"     Hover references
"     Format on write
"     Format
"     Build
"     Show compiler/lint warnings (toggle)
"     Show compiler errors (toggle)
"     Gitsigns
"     Inline Git diff
"     Debugger (toggle)
"   Language Support:
"     Markdown
"     C/C++
"     Go
"     Bash
"     Gitcommit
"     Lua
"     Python

" Tabbing and Spaces
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set smartindent

" Searching
set ignorecase
set smartcase

set hlsearch
set incsearch

" Backups
set nobackup
set noswapfile
set nowritebackup

" Undo
set undofile
set undodir=~/.vimundo
if !isdirectory(expand($HOME . "/.vimundo"))
    call mkdir(expand($HOME . "/.vimundo"), "p")
endif

" Wrapping
set linebreak  " Break at whole word rather than character when wrapping
set textwidth=0  " Don't break lines while you're typing

" Wild Menu
set wildmenu
set wildoptions=pum
set pumheight=10

" Meta
set title
set icon
set belloff=all  " Please, STFU

" Scrolling
set number
set norelativenumber

set scrolloff=5
set sidescrolloff=2

" Time stuff
set timeoutlen=200
set updatetime=200 " Affects how frequently (ms) GitGutter refreshes

" Statusline
set noshowmode
set laststatus=2

function! FmtMode()
  let l:mode = mode()
  return l:mode ==# 'n'  ? 'NORMAL' :
         \ l:mode ==# 'i'  ? 'INSERT' :
         \ l:mode ==# 'v'  ? 'VISUAL' :
         \ l:mode ==# 'V'  ? 'V-LINE' :
         \ l:mode ==# '' ? 'V-BLOCK' :
         \ l:mode ==# 'R'  ? 'REPLACE' :
         \ l:mode ==# 'c'  ? 'COMMAND' :
         \ l:mode ==# 't'  ? 'TERMINAL' :
         \ 'UNKNOWN'
endfunction

set statusline=
set statusline+=[%{FmtMode()}]
set statusline+=\ %f              " Filename with path
set statusline+=\ %m	        " Modified flag [+]
set statusline+=%r              " Read-only flag [RO]

set statusline+=%=
set statusline+=L%l:C%c\ \|\ %p%% " %l line number %c column number %p file percent
set statusline+=\ \|\ %y

" Misc
set splitbelow
set backspace=indent,eol,start
match Visual '\s\+$'  " Highlight trailing whitespace
set shortmess=aoOtTI " Avoid most of the 'Hit Enter ...' messages
set hidden
set nofixendofline
set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
set clipboard=unnamedplus

" File stuff
set autoread
filetype plugin on
autocmd FileType * setlocal formatoptions-=ro " Disable continuing comments on line return and opening new lines before/after comments
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " Return cursor to last position on open

" Highlighting
"" Enable basic syntax highlighting and dark mode
set notermguicolors " TODO: Configure GUI colors
if has("syntax")
  syntax on
endif
set background=dark
color retrobox

" TODO: Replace color names with color codes for consistency and clarity

hi Normal ctermfg=white ctermbg=none

hi StatusLine ctermfg=white ctermbg=none cterm=underline,bold
hi StatusLineNC ctermfg=lightgrey ctermbg=none cterm=underline

hi QuickFixLine ctermfg=black ctermbg=107 cterm=none
hi StatusLineTerm ctermfg=208 ctermbg=none cterm=underline,bold
hi StatusLineTermNC ctermfg=130 ctermbg=none cterm=underline

hi DebugPC ctermfg=black ctermbg=107 cterm=none
hi DebugBreakpoint ctermfg=black ctermbg=107 cterm=none
hi DebugBreakpointDisabled ctermfg=black ctermbg=red cterm=none

"" Scrolling and line numbers
hi LineNr ctermfg=237
hi CursorLineNr ctermfg=lightgrey cterm=none

set cursorline
set cursorlineopt=both
au WinLeave * set nocursorline
au WinEnter * set cursorline

"" Searching
hi Search ctermfg=black ctermbg=white cterm=none
hi IncSearch ctermfg=black ctermbg=white cterm=bold
hi CurSearch ctermfg=black ctermbg=white cterm=bold

"" Diffing
hi SignColumn ctermbg=none

""" Vim diffing
hi DiffAdd ctermfg=green
hi DiffDelete ctermfg=red
hi DiffChange ctermfg=blue

""" Commit messages
hi DiffAdded ctermfg=green
hi DiffRemoved ctermfg=red
hi DiffChanged ctermfg=blue

""" GitGutter
hi GitGutterAdd ctermfg=237 ctermbg=none
hi GitGutterDelete ctermfg=237 ctermbg=none
hi GitGutterChange ctermfg=237 ctermbg=none

" Plugins
packadd termdebug

"" Init Whitebox
if !empty(glob('~/docs/bin/whitebox/editor_plugins/whitebox-vim/plugin/whitebox.vim'))
    execute 'source' expand('~/docs/bin/whitebox/editor_plugins/whitebox-vim/plugin/whitebox.vim')
endif

"" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  execute '!curl -fLo' expand('~/.vim/autoload/plug.vim --create-dirs ') . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source' expand('~/.vim/autoload/plug.vim')
  echo "vim-plug installed successfully! Run PlugInstall to install plugins."
else
  execute 'source' expand('~/.vim/autoload/plug.vim')
endif


"" Initialize vim-plug plugins
call plug#begin(expand('~/.vim/plugged'))
"Plug 'dense-analysis/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
call plug#end()

"" Set Up Plugins
"let g:ale_linters = {
"\   'cpp': ['gcc', 'clangtidy']
"\}
"let g:ale_fix_on_save = 1
"let g:ale_lint_on_text_changed = 'always'
"let g:ale_lint_on_save = 1
"
"nnoremap <leader>[ :ALEFix<CR>

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_modified_removed = '_~'
let g:gitgutter_sign_removed = '_|'
let g:gitgutter_sign_removed_first_line = '‾|'
let g:gitgutter_sign_removed_above_and_below = '_‾'

" Remaps
let mapleader=" "
nnoremap <leader><leader> :source $MYVIMRC<CR>

"" fzf.vim remaps
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<Space>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>[ :Tags<CR>
nnoremap <leader>' :Marks<CR>
nnoremap <leader>l :Lines<CR>

" Other custom remaps
inoremap jk <Esc><Cmd>w<CR>

"" Explorer
nnoremap <leader>o :Explore<CR>
nnoremap <leader>p :bp<CR>

"" Build scripts and quickfix
if has("win32") || has("win64") " Windows path seperators
  set makeprg=tools\\build
  nnoremap <F5> :!tools\\format<CR>
  nnoremap <F6> :!tools\\check<CR>
  nnoremap <F7> :!tools\\build<CR>
  nnoremap <F8> :!tools\\run<CR>
else " Unix path seperators
  set makeprg=tools/build
  nnoremap <F5> :!tools/format<CR>
  nnoremap <F6> :!tools/check<CR>
  nnoremap <F7> :!tools/build<CR>
  nnoremap <F8> :!tools/run<CR>
endif

nnoremap <C-j> :make<CR>
nnoremap <C-k> :copen<CR>
"nnoremap <C-k> :cclose<CR>
nnoremap <C-h> :cprev<CR>
nnoremap <C-l> :cnext<CR>

"' Termdebug configuration
let termdebug_wide=0
let termdebugger='gdb'

nnoremap <F1> :make<CR>:Termdebug .build/out<CR>
autocmd User TermdebugStartPost call OnTermdebugStartPost()
"autocmd User TermdebugStopPost call OnTermdebugStopPost()

function! OnTermdebugStartPost()
  " Keybinds
  nnoremap <F2> :Gdb<CR>exit<CR>
  tnoremap <F2> exit<CR>
  nnoremap <F3> :Gdb<CR>
  tnoremap <F4> <C-w>:Source<CR>

  " Window formatting
  " NOTE: Assumes splitting horizontally and below
  let source_height = float2nr(&lines * 0.5)
  let gdb_output_height = float2nr(&lines * 0.2)
  let gdb_cmd_height = float2nr(&lines * 0.3)

  execute ':Gdb'
  wincmd k " Go to output window
  wincmd J " Move output window down
  execute "resize " . gdb_output_height

  execute ':Source'
  execute "resize " . source_height

  execute ':Gdb'
  execute "resize " . gdb_cmd_height
endfunction

function! OnTermdebugStopPost()
  nunmap <F2>
  tunmap <F2>
  nunmap <F3>
  tunmap <F4>
endfunction
