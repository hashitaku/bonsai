case $- in
    *i*) ;;
    *) return;;
esac

export LESSHISTFILE=-
export MANPAGER='less -M +Gg'
export HISTCONTROL='ignoreboth'

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi

export EDITOR='nvim'

# エイリアス
alias cl='clang -Wall -Wextra -std=c11 -pedantic'
alias cl++='clang++ -Wall -Wextra -std=c++2a -pedantic'
alias tree='tree -C'
alias eman='LC_ALL=C man'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias pbcopy='xclip -selection c'
alias pbpaste='xclip -selection c -o'

# セットアップ
type fnm >/dev/null 2>&1 && eval "$(fnm env)"
test -f /usr/share/git/git-prompt.sh && source /usr/share/git/git-prompt.sh

# 補完
type rustup >/dev/null 2>&1 && eval "$(rustup completions bash cargo)"
type rustup >/dev/null 2>&1 && eval "$(rustup completions bash rustup)"
type oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh completion bash)"
type fnm >/dev/null 2>&1 && eval "$(fnm completions --shell bash)"
type uv >/dev/null 2>&1 && eval "$(uv generate-shell-completion bash)"
type uvx >/dev/null 2>&1 && eval "$(uvx --generate-shell-completion bash)"

# プロンプト設定
if [[ "$(type -t __git_ps1)" == 'function' ]]; then
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWUPSTREAM='auto'
    title='\[\e]0;\w$(__git_ps1)\a\]'
    prompt='\[\e[31m\]\u\[\e[0m\] at\[\e[33m\] \h\[\e[0m\] in\[\e[32m\] \w\[\e[36m\]$(__git_ps1)\[\e[0m\]\$ '
else
    title='\[\e]0;\w\a\]'
    prompt='\[\e[31m\]\u\[\e[0m\] at\[\e[33m\] \h\[\e[0m\] in\[\e[32m\] \w\[\e[0m\]\$ '
fi

case "${TERM}" in
    xterm*|rxvt*)
        PS1="${title}${prompt}"
        ;;
    *)
        PS1="${prompt}"
        ;;
esac
unset title prompt

type oh-my-posh >/dev/null 2>&1 && eval "$(oh-my-posh init bash --config ${XDG_CONFIG_HOME}/oh-my-posh/config.toml)"
