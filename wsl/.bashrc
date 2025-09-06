# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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
export HISTIGNORE=cd:'exp .':la:las:rs:wu:g-:gb:gl:glr:grl:gf:wttr:gst:gr:gr-:pve:gd:cpc:gds:gdn:gdsn:cc:cco
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
  if [[ $# -ne 2 || ! "$count" =~ ^[1-9][0-9]*$ ]]; then
    echo "Usage: rt <STRING> <COUNT>" >&2
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
alias gdn='git diff --name-only'
alias gdsn='git diff --staged --name-only'
alias gdt='git difftool'
pp() {
  local input_arg="${*//$'\r'/}"
  local input_pipe=""
  if [ ! -t 0 ]; then
    IFS=$'\r' read -r input_pipe || true
  fi
  if [ -z "$input_arg" ] && [ -z "$input_pipe" ]; then
    return 1
  fi
  local final_expression=""
  if [[ "$input_arg" == *"@"* ]]; then
    final_expression="${input_arg//@/ "$input_pipe" }"
  else
    final_expression="$input_pipe $input_arg"
  fi
  if ! python.exe -c "from math import *; result = $final_expression; print(f'{result}\n{hex(result)}\n{bin(result)} ({len(bin(abs(result))) - 2})' if isinstance(result, int) else result)"; then
    return 1
  fi
}
alias swu='sudo winget.exe upgrade'
dh() {
  local offset_from_end=1
  if [[ -n "$1" ]]; then
    if [[ "$1" =~ ^[1-9][0-9]*$ ]]; then
      offset_from_end="$1"
    else
      echo "Usage: dh [OFFSET_FROM_END]" >&2
      return 1
    fi
  fi
  local total_lines=$(wc -l < ~/.bash_history)
  local line_num=$((total_lines - offset_from_end + 1))
  if [[ "$line_num" -lt 1 ]]; then
    echo "Error: out of range" >&2
    return 1
  fi
  local line_content=$(sed -n "${line_num}{p;q}" ~/.bash_history)
  sed -i "${line_num}d" ~/.bash_history && history -c && history -r
  if [ -t 1 ]; then
    printf "\033[1;31mDeleted: \033[0m%s\r\n" "$line_content"
  else
    printf "Deleted: %s\r\n" "$line_content"
  fi
}
