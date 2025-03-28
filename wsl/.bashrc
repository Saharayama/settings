# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
# #shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi

# set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color|*-256color) color_prompt=yes;;
# esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# #force_color_prompt=yes

# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
# 	color_prompt=yes
#     else
# 	color_prompt=
#     fi
# fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
# #export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
# alias ll='ls -alF'
# alias la='ls -A'
# alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if ! shopt -oq posix; then
#   if [ -f /usr/share/bash-completion/bash_completion ]; then
#     . /usr/share/bash-completion/bash_completion
#   elif [ -f /etc/bash_completion ]; then
#     . /etc/bash_completion
#   fi
# fi



PS1='(WSL) \[\e[1;32m\]\u \[\e[33m\]\w\[\e[0m\]\n\$ '

alias exp='explorer.exe'
alias la='ls -lAhtr --time-style="+%Y-%m-%d"'
alias las='ls -lAhtr --time-style="+%Y-%m-%d %H:%M:%S"'
export LANG=ja_JP.UTF-8
EDITOR='"code" --wait'
stty -ixon
alias rs='exec $SHELL -l'
alias echon='printf "%s\r\n"'
alias clip='iconv -f UTF-8 -t CP932 | clip.exe'
alias wu='winget.exe upgrade'
alias wf='winget.exe find'
alias ws='winget.exe show'
alias g-='git switch -'
alias gb='git branch'
alias gl='git log --oneline --pretty=format:"%C(auto)%h %C(cyan)%cd%C(auto)%d %s %C(green bold dim)%an%Creset" --date=format:"%Y-%m-%d %H:%M:%S"'
alias glr='git log --oneline --reverse --pretty=format:"%C(auto)%h %C(cyan)%cd%C(auto)%d %s %C(green bold dim)%an%Creset" --date=format:"%Y-%m-%d %H:%M:%S"'
alias grl='git reflog --oneline --pretty=format:"%C(auto)%h %C(cyan)%gd:%C(auto)%d %gs %C(green bold dim)%gn%Creset" --date=format:"%Y-%m-%d %H:%M:%S"'
alias gs='git show --date=format:"%Y-%m-%d %H:%M:%S"'
alias gf='git fetch'
gr() {
  git rev-parse --revs-only "${1:-"@"}" | tee >(clip)
}
en() {
  if [ -z "$2" ]; then
    echo "Usage: en BEGIN END [PREFIX [SUFFIX [STEP]]]" >&2
    return 1
  fi
  local step=""
  if [ -n "$5" ]; then
    step="..$5"
  fi
  local sequence=$(eval echo '$3'"{""$1".."$2""$step""}"'$4')
  printf "%s\r\n" $sequence | clip
  printf "%s\r\n" "$sequence" | tee >(wc -w)
}
echonc() {
  echon $* | tee >(clip)
}
alias wttr='curl -s "wttr.in?1MF&lang=ja"'
# chcp.com 65001 >/dev/null
alias gst='git status'
gr-() {
  local output
  output=$(git rev-parse --revs-only --symbolic-full-name --abbrev-ref=loose @{-1}) || return
  if [ -z "$output" ]; then
    git rev-parse --revs-only @{-1}
  else
    echo "$output"
  fi
}
export HISTIGNORE=cd:'exp .':la:las:rs:wu:g-:gb:gl:glr:grl:gf:wttr:gst:gr:gr-:pve:gd:cpc:gds:rd:gdn:gdsn:cc:cco
export PROMPT_COMMAND="history -a"
mkcd() {
  if ! [ -d "$1" ]; then
    mkdir -p "$1" && cd "$1"
  else
    echo "Directory '$1' already exists." >&2
    return 1
  fi
}
alias gd='git diff'
rt() {
  local string="$1"
  local count="$2"
  if [[ $# -ne 2 || ! "$count" =~ ^[0-9]+$ ]]; then
    echo "Usage: rt <string> <count>" >&2
    return 1
  fi
  yes "$string" | head -n "$count" | tr -d "\n" | tee >(clip)
  echo
}
alias cpc='fc -ln -1 | sed "s/^[\t ]*//" | tee >(clip)'
ef() {
  awk -v row="$1" -v col="$2" '
  {
    lines[NR] = $0
  }
  END {
    row = (row < 0) ? NR + row + 1 : row
    split(lines[row], fields)
    col = (col < 0) ? length(fields) + col + 1 : col
    print fields[col]
  }' | tee >(clip)
}
alias xargs='xargs '
alias gds='git diff --staged'
rd() {
  if [[ "$PS1" == *"$"* ]]; then
    PS1="${PS1//\\$/🦆}"
  else
    PS1="${PS1//🦆/\\$}"
  fi
}
alias gdn='git diff --name-only'
alias gdsn='git diff --staged --name-only'
alias gdt='git difftool'
