#!/usr/bin/env bash

# PATH
export PATH="$PATH:$(go env GOPATH)/bin"

# MISC
set -o vi
export EDITOR=vim

# ALIASES
## Misc aliases
alias r='vi README.md'
alias c='clear'

## Navigation aliases
alias ..='..'
alias home='cd ~'

## Common directory and file aliases
alias cs='cd ~/docs/cs'
alias lib='cd ~/docs/cs/lib'
alias winux='cd ~/docs/cs/winux-dotfiles'

alias notes='cd ~/docs/notes'
alias lab='cd ~/docs/notes/lab'

alias log='glow -tl ~/docs/notes/log.md'
alias loge='vi ~/docs/notes/log.md'

alias res='glow -tl ~/docs/notes/resources.md'
alias rese='vi ~/docs/notes/resources.md'

## Reference manual aliases
alias refs='glow -tl ~/docs/cs/linux-reference'
alias ref='glow -tl ~/docs/cs/linux-reference/README.md'
alias refe='vi ~/docs/cs/linux-reference/README.md'

alias pbb='glow -tl ~/docs/cs/linux-reference/other-resources/pure-bash-bible/README.md'
alias psb='glow -tl ~/docs/cs/linux-reference/other-resources/pure-sh-bible/README.md'

alias wrefs='glow -tl ~/docs/cs/windows-reference'
alias wref='glow -tl ~/docs/cs/windows-reference/README.md'
alias wrefe='vi ~/docs/cs/windows-reference/README.md'

alias crefs='glow -tl ~/docs/notes/cs/c/'
alias cref='glow -tl ~/docs/notes/cs/c/c-reference.md'
alias crefe='vi ~/docs/notes/cs/c/c-reference.md'

## General system utility aliases
alias q='exit'
alias chmox='chmod u+x'
alias ls='ls --color --group-directories-first'
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
alias gcu='git commit --allow-empty-message -m ""'
alias gcua='git commit -a --allow-empty-message -m ""'
alias gp='git pull && git push'
alias gl='git log --oneline'
#alias gll='git log --oneline --max-count=15'
#alias gla='git log --oneline'
#alias gld='git log --max-count=5'
#alias grs='git reset --soft HEAD~1'
#alias gri='git rebase -i HEAD~5'

# FUNCTIONS
dirty() {
    pushd ~/docs/
    find . -type d -name .git | while read dir; do
        repo=$(dirname "$dir")
        cd "$repo"
        dirty=$(git status --porcelain)
        [[ -n "$dirty" ]] && echo "Dirty repo: $repo"
        cd - >/dev/null
    done
    popd
}
fetch() {
    pushd ~/docs/
    mr fetch
    popd
}
missing() {
    pushd ~/docs/
    mr log --max-count=1 --oneline
    popd
}

clone() {  # Clone a holychowders repo into the current directory and cd into it
    if [ -z "$1" ]; then
        echo 'Specify repository from user github.com/holychowders'
        echo 'Example: `clone dotfiles` to clone `github.com/holychowders/dotfiles` and `cd` into it'
        return 1
    fi
    repo_name="$1"
    git clone git@github.com:holychowders/$repo_name
    cd $repo_name
}

mkreadme() {
    if [ -f "README.md" ]; then
        echo "ERROR: README.md exists. Delete it and try again. Aborting." >&2
        return 1
    fi

    [ "$1" = "--repo-name" ] && local repomd="- *GitHub repo: <https://github.com/holychowders/$2>*" && local title="${@:3}" || local title="$@"

    cat <<EOF >README.md
# $title

---

- *Created by \`holychowders\` on $(date +%F)*
- *GitHub profile: <https://github.com/holychowders>*
$repomd
EOF
}

cat() {
    command cat "$@" && (
        ffplay ~/.config/bashrc/cat-meow.mp3 -nodisp -autoexit -loglevel quiet >/dev/null &
        disown
    ) || (
        ffplay ~/.config/bashrc/trill.mp3 -nodisp -autoexit -loglevel quiet >/dev/null &
        disown
    )
}

#alias '?=xargs -r w3m https://www.duckduckgo.com/?q='

i() {
    query=$(echo "$*" | sed 's/ /+/g')
    w3m "https://duckduckgo.com/?q=$query"
}

# PROMPT
#prompt_username="\[\e[0;33m\]\u"
#prompt_at="\[\e[0;34m\]@"
#prompt_hostname="\[\e[0;34m\]\h"
#prompt_colon="\[\e[0;38m\] "
#prompt_cwd="\[\e[0;31m\]\w"
#prompt_git="\[\e[0;34m\]\$(__git_ps1)"
#prompt_prompt=" \[\e[0m\]\n$ "
#PS1="$prompt_username$prompt_at$prompt_hostname$prompt_colon$prompt_cwd$prompt_git$prompt_prompt"

# ALTERNATE PROMPT
set_ps1() {
    prompt_username="\[\e[1;32m\]\u"
    prompt_at="\[\e[1;32m\]@"
    prompt_hostname="\[\e[1;32m\]\h"
    prompt_colon="\[\e[0;38m\]:"
    prompt_cwd="\[\e[1;36m\]\w"
    prompt_git="\[\e[0;37m\]\$(__git_ps1)"
    prompt_prompt=" \[\e[0m\]\n$ "
    prompt_datetime="\[\e[0;32m\][$(date +"%m/%d/%y %T %Z")] "
    PS1="$prompt_datetime$prompt_username$prompt_at$prompt_hostname$prompt_colon$prompt_cwd$prompt_git$prompt_prompt"
}
PROMPT_COMMAND=set_ps1
