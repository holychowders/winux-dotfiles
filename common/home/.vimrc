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
set relativenumber

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
set backspace=indent,eol,start
match Visual '\s\+$'  " Highlight trailing whitespace
set shortmess=aoOtTI " Avoid most of the 'Hit Enter ...' messages
set hidden
set nofixendofline
set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
set clipboard=unnamedplus

" File stuff
filetype plugin on
autocmd FileType * setlocal formatoptions-=ro " Disable continuing comments on line return and opening new lines before/after comments
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " Return cursor to last position on open

" Highlighting
"" Enable basic syntax highlighting and dark mode
if has("syntax")
  syntax on " for plugins
endif
set background=dark
color retrobox

hi Normal ctermbg=none

hi StatusLine ctermfg=darkgrey ctermbg=none cterm=none
hi StatusLineNC ctermfg=darkgrey ctermbg=none cterm=none

"" Scrolling and line numbers
set cursorline
hi LineNr ctermfg=darkgrey
hi CursorLineNr ctermfg=darkgrey

"" Searching
hi Search ctermfg=lightblue ctermbg=black
hi IncSearch ctermfg=lightblue ctermbg=black
hi CurSearch ctermfg=lightblue ctermbg=black cterm=reverse

"" Diffing
hi SignColumn ctermbg=none

hi DiffAdd ctermfg=lightgreen
hi DiffDelete ctermfg=red
hi DiffChange ctermfg=lightblue

hi GitGutterAdd ctermfg=darkgrey
hi GitGutterDelete ctermfg=darkgrey
hi GitGutterChange ctermfg=darkgrey

" Plugins
packadd termdebug
let termdebug_wide=1

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
nnoremap <F1> :Termdebug<CR>

if has("win32") || has("win64") " Windows path seperators
  set makeprg=tools\\build
  nnoremap <F5> :!tools\\debug<CR>
  nnoremap <F6> :!tools\\format<CR>
  nnoremap <F7> :!tools\\build<CR>
  nnoremap <F8> :!tools\\run<CR>
else " Unix path seperators
  set makeprg=tools/build
  nnoremap <F5> :!tools/debug<CR>
  nnoremap <F6> :!tools/format<CR>
  nnoremap <F7> :!tools/build<CR>
  nnoremap <F8> :!tools/run<CR>
endif

nnoremap <C-j> :make<CR>
nnoremap <C-k> :copen<CR>
"nnoremap <C-k> :cclose<CR>
nnoremap <C-h> :cprev<CR>
nnoremap <C-l> :cnext<CR>
