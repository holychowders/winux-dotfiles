#!/usr/bin/env bash

# MISC
set -o vi
export EDITOR=vim

# ALIASES
alias l='ls -a'
alias ll='ls -al'

alias g='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gau='git add -u'
alias gc='git commit'
alias gca='git commit -a'
alias gcu='git commit -a --allow-empty-message -m ""'
alias gl='git log --oneline --max-count=5'
alias gll='git log --oneline --max-count=15'
alias gla='git log --oneline'
alias gld='git log --max-count=5'
alias grs='git reset --soft HEAD~1'
alias gri='git rebase -i HEAD~5'

# FUNCTIONS
cat() {
    command cat "$@" && (ffplay ~/.config/bashrc/cat-meow.mp3 -nodisp -autoexit -loglevel quiet >/dev/null & disown) || (ffplay ~/.config/bashrc/trill.mp3 -nodisp -autoexit -loglevel quiet >/dev/null & disown)
}

# PROMPT
prompt_username="\[\e[0;33m\]\u"
prompt_at="\[\e[0;34m\]@"
prompt_hostname="\[\e[0;34m\]\h"
prompt_colon="\[\e[0;38m\] "
prompt_cwd="\[\e[0;31m\]\w"
prompt_git="\[\e[0;34m\]\$(__git_ps1)"
prompt_prompt=" \[\e[0m\]\n$ "
PS1="$prompt_username$prompt_at$prompt_hostname$prompt_colon$prompt_cwd$prompt_git$prompt_prompt"
