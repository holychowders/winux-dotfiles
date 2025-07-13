#!/usr/bin/env bash

# MISC
set -o vi
export EDITOR=vim

cdebug='-g -O0'
cwarnings='-pedantic -Wall -Wextra -Wno-c23-extensions'
cfeatures='-fvisibility=hidden -fno-exceptions -fno-unwind-tables -fno-rtti -ffast-math'
csanitize='-fsanitize=address,undefined,alignment,implicit-integer-truncation,implicit-integer-arithmetic-value-change,implicit-conversion,integer,nullability-arg'
# consider: -Weverything
export cflags="$cdebug $cwarnings $cfeatures $csanitize"
#alias c="clang $cflags"
#alias c99="clang -std=99 $cflags"
# WARNING: DON'T DO THIS. `cpp` is already a command
#alias cpp="clang $cflags"
#alias cpp14="clang -std=c++14 $cflags"

# ALIASES
## Misc aliases
alias r='vi README.md'

## Common directory and file aliases
alias cs='cd ~/docs/cs'
alias winux='cd ~/docs/cs/winux-dotfiles'
alias lab='cd ~/docs/notes/lab'
alias notes='cd ~/docs/notes'
alias ref='glow -p ~/docs/notes/lab/linux/book/README.md'
alias refe='vi ~/docs/notes/lab/linux/book/README.md'
alias todo='glow -p ~/docs/notes/SCHEDULE.md'
alias todoe='vi ~/docs/notes/SCHEDULE.md'

## General system utility aliases
alias q='exit'
alias chmox='chmod +x'
alias l='ls -a'
alias ll='ls -al'

## Git aliases
alias g='git status --short'
alias gg='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gau='git add -u'
alias gap='git add -p'
alias gc='git commit'
alias gcp='git commit -p'
alias gca='git commit -a'
alias gcu='git commit -a --allow-empty-message -m ""'
alias gp='git pull && git push'
alias gl='git log --oneline'
#alias gll='git log --oneline --max-count=15'
#alias gla='git log --oneline'
#alias gld='git log --max-count=5'
#alias grs='git reset --soft HEAD~1'
#alias gri='git rebase -i HEAD~5'

# FUNCTIONS
cat() {
    command cat "$@" && (ffplay ~/.config/bashrc/cat-meow.mp3 -nodisp -autoexit -loglevel quiet >/dev/null & disown) || (ffplay ~/.config/bashrc/trill.mp3 -nodisp -autoexit -loglevel quiet >/dev/null & disown)
}

#alias '?=xargs -r w3m https://www.duckduckgo.com/?q='

i() {
  query=$(echo "$*" | sed 's/ /+/g')
  w3m "https://duckduckgo.com/?q=$query"
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
