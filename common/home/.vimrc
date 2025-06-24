" Requirements:
"  vim-plug
"  fzf.vim
"  ~~ripgrep~~ never works. using vimgrep now.
"  ctags

" FIXME
"   autoread doesn't work

" TODO:
"   Markdown preview toggle
"   Tmux sessionizer integration
"   Yank stack
"   Undo history list
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
set nowrap
autocmd FileType markdown,text set wrap
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

"" Scrolling and line numbers
set number
set relativenumber

set scrolloff=2
set sidescrolloff=1

set cursorline
set cursorlineopt=both

"au WinLeave * set nocursorline
"au WinEnter * set cursorline

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
match StatusLine '\s\+$'  " Highlight trailing whitespace
set shortmess=aoOtTI " Avoid most of the 'Hit Enter ...' messages
set hidden
set nofixendofline
set listchars=space:*,trail:*,nbsp:*,extends:>,precedes:<,tab:\|>
set clipboard=unnamedplus
set colorcolumn=120
autocmd FileType gitcommit set spell

" File stuff
set autoread
filetype plugin on
autocmd FileType * setlocal formatoptions-=ro " Disable continuing comments on line return and opening new lines before/after comments
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " Return cursor to last position on open

" Highlighting
" TODO: Replace color names with color codes for consistency and clarity
set notermguicolors " TODO: Configure GUI colors
syntax on

"autocmd FileType cpp call OnCppFiletype()
function! OnCppFiletype()
  "syntax clear  " TODO: Maybe clear syntax once we're able to smartly check different constructs.
  hi clear
  call SetHighlights()

  syn keyword Typedef typedef
  syn keyword Static static internal internal_global_var internal_dynamic_func local_persist
  syn keyword ControlFlow if else return for while
  syn keyword Debug OutputDebugStringA DebugBreak assert Assert
  syn keyword Type const void char int bool bool32 float size_t int8_t int16_t int32_t int64_t uint8_t uint16_t uint32_t uint64_t

  "syn region String start=+\(L\|u\|u8\|U\)\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"\(sv\|s\|_\i*\)\=+ end='$' contains=cSpecial,cFormat,@Spell

  syn match Comment "\v(//.*|/\*.\_s*\*/)"
  "syn keyword Todo NOTE TODO FIXME
  "syn match Docstring "//!"

  " Highlights
  hi MatchParen ctermfg=red ctermbg=none cterm=bold

  hi PreProc ctermfg=lightgrey ctermbg=none cterm=none
  hi Static ctermfg=lightblue ctermbg=none
  hi ControlFlow ctermfg=9 ctermbg=none
  hi Debug ctermfg=lightgrey ctermbg=none cterm=bold
  hi Type ctermfg=darkyellow ctermbg=none

  hi Constant ctermfg=blue ctermbg=none cterm=none

  hi Comment ctermfg=242 ctermbg=none cterm=none
  hi Todo ctermfg=lightgrey ctermbg=none
  hi Docstring ctermfg=darkblue ctermbg=none

  hi link Typedef PreProc
endfunction


function! SetHighlights()
  set background=dark
  color retrobox

  hi Normal ctermfg=white ctermbg=none

  hi StatusLine ctermfg=lightgrey ctermbg=236 cterm=none
  hi StatusLineNC ctermfg=lightgrey ctermbg=234 cterm=none

  hi QuickFixLine ctermfg=black ctermbg=107 cterm=none
  hi StatusLineTerm ctermfg=black ctermbg=107 cterm=none
  hi StatusLineTermNC ctermfg=107 ctermbg=none cterm=none

  hi DebugPC ctermfg=black ctermbg=107 cterm=none
  hi DebugBreakpoint ctermfg=black ctermbg=107 cterm=none
  hi DebugBreakpointDisabled ctermfg=black ctermbg=red cterm=none

  "" Markdown (TODO: Consider making into autocmd function for markdown filetype)
  " 208 is also good for headings
  hi markdownHeadingDelimiter ctermfg=darkred cterm=none
  hi markdownH1 ctermfg=darkred cterm=bold
  hi markdownH2 ctermfg=darkred cterm=bold
  hi markdownH3 ctermfg=darkred cterm=none
  hi markdownH4 ctermfg=darkred cterm=none
  hi markdownH5 ctermfg=darkred cterm=none
  hi markdownH6 ctermfg=darkred cterm=none

  hi markdownCodeDelimiter ctermfg=darkblue cterm=none
  hi markdownCode ctermfg=darkblue cterm=none

  hi markdownListMarker ctermfg=white cterm=none

  hi markdownUrl ctermfg=white cterm=italic,underline
  hi markdownUrlDelimiter ctermfg=white cterm=italic
  hi markdownLinkText ctermfg=white cterm=none

  "" Scrolling and line numbers
  hi LineNr ctermfg=237
  hi CursorLine ctermbg=17 cterm=none
  " 239 is also nice for ctermfg with 236 ctermbg
  hi CursorLineNr ctermfg=lightgrey ctermbg=17 cterm=none

  hi ColorColumn ctermbg=236 cterm=none

  "" Searching
  hi Search ctermfg=236 ctermbg=109 cterm=none
  hi IncSearch ctermfg=black ctermbg=109 cterm=bold
  hi CurSearch ctermfg=black ctermbg=109 cterm=bold

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
  hi GitGutterAdd ctermfg=green ctermbg=none cterm=none
  hi GitGutterDelete ctermfg=red ctermbg=none cterm=none
  hi GitGutterChange ctermfg=blue ctermbg=none cterm=none
endfunction

call SetHighlights()

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
Plug 'tpope/vim-obsession'
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

"let g:gitgutter_sign_added = '+'
"let g:gitgutter_sign_modified = '~'
"let g:gitgutter_sign_modified_removed = '_~'
"let g:gitgutter_sign_removed = '_|'
"let g:gitgutter_sign_removed_first_line = '‾|'
"let g:gitgutter_sign_removed_above_and_below = '_‾'

let g:gitgutter_sign_added = '|'
let g:gitgutter_sign_modified = '|'
let g:gitgutter_sign_modified_removed = '|'
let g:gitgutter_sign_removed = '_|'
let g:gitgutter_sign_removed_first_line = '‾|'
let g:gitgutter_sign_removed_above_and_below = '_‾'

" Remaps
let mapleader=" "
nnoremap <leader><leader> :source $MYVIMRC<CR>

"" fzf.vim remaps
nnoremap <leader>g :vimgrep<Space>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>' :Marks<CR>
"nnoremap <leader>l :Lines<CR>

" Other custom remaps
inoremap jk <Esc><Cmd>w<CR>
nnoremap <C-q> <Cmd>bd<CR>
nnoremap <leader>/ :noh<CR>

"" Navigation
nnoremap <Tab> <Cmd>tabn<CR>
nnoremap <S-Tab> <Cmd>tabp<CR>

tnoremap <Tab> <Cmd>tabn<CR>
tnoremap <S-Tab> <Cmd>tabp<CR>

""" Buffer (Normal)
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

""" Buffer (Terminal)
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-h> <C-w>h
tnoremap <C-l> <C-w>l

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

  tnoremap <F5> tools\\format<CR>
  tnoremap <F6> tools\\check<CR>
  tnoremap <F7> tools\\build<CR>
  tnoremap <F8> tools\\run<CR>
else " Unix path seperators
  set makeprg=tools/build
  nnoremap <F5> :!tools/format<CR>
  nnoremap <F6> :!tools/check<CR>
  nnoremap <F7> :!tools/build<CR>
  nnoremap <F8> :!tools/run<CR>

  tnoremap <F5> tools/format<CR>
  tnoremap <F6> tools/check<CR>
  tnoremap <F7> tools/build<CR>
  tnoremap <F8> tools/run<CR>
endif

nnoremap <leader>j :make<CR>
nnoremap K :copen<CR>
nnoremap KK :cclose<CR>
nnoremap <leader>h :cprev<CR>
nnoremap <leader>l :cnext<CR>

""" General C/C++ file navigation
"nnoremap [[ {
"nnoremap ]] }
nnoremap H ?^\w\+<CR>
nnoremap L /^\w\+<CR>

"' Termdebug configuration
let termdebug_wide=0
let termdebugger='gdb'

nnoremap <F1> :make<CR>:Termdebug .build/out<CR>
autocmd User TermdebugStartPost call OnTermdebugStartPost()

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

"hi clear
"syntax clear
"autocmd FileType * hi clear
"autocmd FileType * syntax clear
"autocmd FileType * call SetHighlights()
