mklink C:\Users\holychowders\.vimrc C:\Users\holychowders\docs\cs\WinuxDotfiles\common\home\.vimrc
mklink C:\Users\holychowders\.gitconfig C:\Users\holychowders\docs\cs\WinuxDotfiles\common\home\.gitconfig
mklink C:\Users\holychowders\.glzr\glazewm\config.yaml C:\Users\holychowders\docs\cs\WinuxDotfiles\win11\home\.glzr\glazewm\config.yaml

REM Install some things
REM TODO: See if we can use winget to install GlazeWM, Git, Visual Studio (and install the Desktop C++ component), and the other apps we want.
winget install vim.vim

wsl --install
