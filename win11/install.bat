@echo off

REM TODO:
REM   FIXME: Fix Vim installation. Use Nvim for now.

REM REWORK
echo **REWORK IN PROGRESS: USE WITH CAUTION**
echo **Exiting**
exit /B 1

REM SWITCH SYSTEM-WIDE THEME TO DARK MODE
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe && start explorer.exe

REM MAKE REQUIRED DIRECTORIES (AND UPDATE PATH)
mkdir docs\cs

mkdir docs\bin
set "NEW_PATH=%PATH%;%USERPROFILE%\docs\bin"
setx /M PATH "%NEW_PATH%"


REM SYMLINK CONFIGURATION FILES
mklink %USERPROFILE%\.glzr\glazewm\config.yaml %USERPROFILE%\docs\cs\winux-dotfiles\win11\home\.glzr\glazewm\config.yaml
REM mklink %USERPROFILE%\.vimrc %USERPROFILE%\docs\cs\winux-dotfiles\common\home\.vimrc
mkdir %LOCALAPPDATA%\nvim
mklink %LOCALAPPDATA%\nvim\init.vim %USERPROFILE%\docs\cs\winux-dotfiles\common\home\.vimrc
mklink %USERPROFILE%\.gitconfig %USERPROFILE%\docs\cs\winux-dotfiles\common\home\.gitconfig
mklink %USERPROFILE%\themes.gitconfig %USERPROFILE%\docs\cs\winux-dotfiles\common\home\themes.gitconfig

REM INSTALL APPLICATIONS
winget install OO-Software.ShutUp10
winget install Microsoft.VisualStudio.2022.Community
winget install vim.vim
winget install Neovim.Neovim
winget install Notepad++.Notepad++
winget install Microsoft.Sysinternals.Suite
winget install Microsoft.PowerToys
winget install Git.Git
winget install dandavison.delta
winget install Mozilla.Firefox

winget install glzr-io.glazewm
winget install TheDocumentFoundation.LibreOffice
winget install Valve.Steam
winget install FxSound.FxSound
winget install Discord.Discord
winget install OBSProject.OBSStudio
winget install VideoLAN.VLC
winget install Microsoft.WinDbg
winget install WerWolv.ImHex
winget install UniversalCtags.Ctags
winget install Gitleaks.Gitleaks

winget install LLVM.LLVM
winget install Python.Python.3.13
winget install GoLang.Go
winget install Rustlang.Rustup
wsl --install -d Ubuntu
winget install Docker.DockerDesktop
winget install Kubernetes.kind

rem File Pilot
curl -L "https://filepilot.tech/download/latest" -o "%USERPROFILE%\docs\bin\FPilot.exe"

rem bed (Binary editor written in Go)
curl -L "https://github.com/itchyny/bed/releases/download/v0.2.8/bed_v0.2.8_windows_amd64.zip" -o "bed_v0.2.8_windows_amd64.zip"
tar -xf "bed_v0.2.8_windows_amd64.zip"
copy "bed_v0.2.8_windows_amd64\bed.exe" "docs\bin"


REM INSTALL FONTS

REM Red Hat Mono
curl -L "https://github.com/RedHatOfficial/RedHatFont/archive/refs/tags/4.1.0.zip" -o "RedHatFont-4.1.0.zip"
tar -xf "RedHatFont-4.1.0.zip"
copy "RedHatFont-4.1.0\fonts\Mono\ttf\" "%WINDIR%/fonts"

rem FiraCode
curl -L "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip" -o "Fira_Code_v6.2.zip"
tar -xf "Fira_Code_v6.2.zip" -C "Fira_Code_v6.2"
copy "Fira_Code_v6.2\ttf\" "%WINDIR%/fonts"


REM WINDOWS TERMINAL THEMES
curl -L "https://github.com/atomcorp/themes/blob/master/themes.json" -o "windows-terminal-themes.json"
curl -L "https://github.com/luisiacc/gruvbox-baby/blob/main/extras/windwows_terminal/windows_terminal_dark.json" -o "gruvbox-baby-dark.json"

