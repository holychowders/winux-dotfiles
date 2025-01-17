@echo off

REM Todos
REM TODO: See if we can use winget to install GlazeWM, Git, Visual Studio (and install the Desktop C++ component), and the other apps we want.
REM FIXME: Fix vim installation. Use nvim for now.

REM Symlink configs
mklink C:\Users\holychowders\.glzr\glazewm\config.yaml C:\Users\holychowders\docs\cs\WinuxDotfiles\win11\home\.glzr\glazewm\config.yaml
REM FIXME
REM mklink C:\Users\holychowders\.vimrc C:\Users\holychowders\docs\cs\WinuxDotfiles\common\home\.vimrc
mkdir C:\Users\holychowders\AppData\Local\nvim
mklink C:\Users\holychowders\AppData\Local\nvim\init.vim C:\Users\holychowders\docs\cs\WinuxDotfiles\common\home\.vimrc
mklink C:\Users\holychowders\.gitconfig C:\Users\holychowders\docs\cs\WinuxDotfiles\common\home\.gitconfig
mklink C:\Users\holychowders\themes.gitconfig C:\Users\holychowders\docs\cs\WinuxDotfiles\common\home\themes.gitconfig

REM Install some things
REM winget install vim.vim
winget install nvim
winget install dandavison.delta

wsl --install
