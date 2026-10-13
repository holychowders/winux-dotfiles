# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added a config file for you to customize HyDE before loading zshrc
# Edit $ZDOTDIR/.user.zsh to customize HyDE before loading zshrc

#  Plugins 
# oh-my-zsh plugins are loaded  in $ZDOTDIR/.user.zsh file, see the file for more information

#  Aliases 
# Override aliases here in '$ZDOTDIR/.zshrc' (already set in .zshenv)

# # Helpful aliases
# alias c='clear'                                                        # clear terminal
alias l='eza -lh --icons=auto'                                         # long list
alias ls='eza -1 --icons=auto'                                         # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto'                                       # long list dirs
alias lt='eza --icons=auto --tree'                                     # list folder as tree
# alias un='$aurhelper -Rns'                                             # uninstall package
# alias up='$aurhelper -Syu'                                             # update system/package/aur
# alias pl='$aurhelper -Qs'                                              # list installed package
# alias pa='$aurhelper -Ss'                                              # list available package
# alias pc='$aurhelper -Sc'                                              # remove unused cache
# alias po='$aurhelper -Qtdq | $aurhelper -Rns -'                        # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
# alias vc='code'                                                        # gui code editor
# alias fastfetch='fastfetch --logo-type kitty'

# # Directory navigation shortcuts
# alias ..='cd ..'
# alias ...='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'

#  This is your file 
# Add your configurations here

###########################################################################
## Variables
###########################################################################
export EDITOR=nvim
export PATH="$HOME/.cargo/bin:$PATH"

###########################################################################
## Misc
###########################################################################
alias n='nvim -S'
alias dump='coredumpctl dump -o ./core'

###########################################################################
## Misc Builtin Utilities
###########################################################################
alias chmox='chmod u+x'

#alias ls='ls --color --group-directories-first'
#alias l='ls -a'
#alias ll='ls --color --group-directories-first -al'

###########################################################################
## System
###########################################################################
alias gpus="lspci -Dnn | grep -Ei 'VGA|3D|Display'" # NOTE: wakes the dGPU momentarily
alias gpustat='cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status' # assumes this is the NVIDI dGPU
alias gpusleep='nvidia-smi set'
alias batt="upower -b | grep -E 'state:|energy:|energy-rate:|time to empty:'"
alias battmon="watch -n 3 'upower -b | grep -E \"state:|energy:|energy-rate:|time to empty:\"'"

# FIXME: This is ridiculous.
alias fixaudio="amixer -c 0 cset iface=CARD,name='Speaker Force Firmware Load' on"

###########################################################################
## Shell/Terminal/Environment
###########################################################################
bindkey -v # vi-style keybinds
unset -f command_not_found_handler # prevent seeking commands not found in package manager
alias c='clear'
alias q='quit'

alias zshrc='$EDITOR ~/.config/zsh/.zshrc'
alias zshrcs='source ~/.config/zsh/.zshrc'

alias nvimrc='$EDITOR ~/.config/nvim/'

alias hyprrc='$EDITOR ~/.config/hypr/hyprland.lua'
alias kittyrc='$EDITOR ~/.config/kitty/kitty.conf'
alias installsh='$EDITOR ~/docs/cs/winux-dotfiles/hyde/install.sh'

###########################################################################
## Applications
###########################################################################
alias bitwarden='flatpak run com.bitwarden.desktop'
alias discord='flatpak run com.discordapp.Discord'

###########################################################################
## Navigation
###########################################################################
alias docs='cd ~/docs'
alias cs='cd ~/docs/cs'

###########################################################################
## Projects
###########################################################################
alias loge='$EDITOR ~/docs/notes/LOG.md'
alias rese='$EDITOR ~/docs/notes/RESOURCES.md'
alias crefe='$EDITOR ~/docs/notes/cs/c/c.md'

alias winux='cd ~/docs/cs/winux-dotfiles'
alias lib='cd ~/docs/cs/lib'

alias notes='cd ~/docs/notes'
alias csnotes='cd ~/docs/notes/cs'
alias cnotes='cd ~/docs/notes/cs/c'

#alias brefe='glow -tl ~/docs/cs/linux-reference/other-resources/pure-bash-bible/README.md'
#alias srefe='glow -tl ~/docs/cs/linux-reference/other-resources/pure-sh-bible/README.md'

###########################################################################
## Git
###########################################################################
alias g='git status --short'
alias gg='git status'

alias gd='git diff'
alias gds='git diff --staged'

alias ga='git add'
alias gau='git add -u'
alias gap='git add -p'

alias gc='git commit'
alias gca='git commit -a'
alias gcp='git commit -p'

alias gcau='git commit -a -m update'
alias gcu='git commit -m update'

alias gp='git pull && git push'
alias gl='git log --oneline --max-count=10'
alias gll='git log --oneline'

alias grs='git reset --soft HEAD~1'
alias gri='git rebase -i HEAD~5'
