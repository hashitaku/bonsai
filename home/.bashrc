case $- in
    *i*) ;;
    *) return;;
esac

HISTTIMEFORMAT='%F %T '
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
    	. /etc/bash_completion
	fi
fi

export EDITOR='vim'

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

# 補完
type rustup >/dev/null 2>&1 && eval "$(rustup completions bash cargo)"
type rustup >/dev/null 2>&1 && eval "$(rustup completions bash rustup)"
[ -f /etc/bash_completion.d/git-prompt ] && source /etc/bash_completion.d/git-prompt
[ -f /usr/share/git/git-prompt.sh ] && source /usr/share/git/git-prompt.sh
type brew >/dev/null 2>&1 && source "$(brew --prefix)/etc/bash_completion.d/brew"

# プロンプト設定
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWDIRTYSTYLE=1

title='\[\e]0;\w$(__git_ps1)\a\]'
prompt='\[\e[31m\]\u\[\e[0m\] at\[\e[33m\] \h\[\e[0m\] in\[\e[32m\] \w\[\e[36m\]$(__git_ps1)\[\e[0m\]\$ '
case "${TERM}" in
	xterm*|rxvt*)
		PS1="${title}${prompt}"
		;;
	*)
		PS1="${prompt}"
		;;
esac
unset title prompt
