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

PS1='\[\e[1;32m\]\u \[\e[33m\]\w\[\e[0m\]\n\$ '

alias exp='explorer.exe'
alias la='ls -lAhtr --time-style="+%Y-%m-%d"'
alias las='ls -lAhtr --time-style="+%Y-%m-%d %H:%M:%S"'
export LANG=ja_JP.UTF-8
EDITOR='"code" --wait'
stty -ixon
alias rs='exec $SHELL'
alias echon='printf "%s\r\n"'
# alias clip='iconv -f UTF-8 -t CP932 | clip.exe'
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
chcp.com 65001 >/dev/null
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
alias pve='python -m venv --upgrade-deps .venv && . .venv/Scripts/activate'
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
tree() {
  local path=''
  if [ -n "$1" ]; then
    path="\"$1\""
  fi
  pwsh -c "tree /f "$path"" | iconv -f CP932 -t UTF-8 -c
}
alias xargs='xargs '
alias gds='git diff --staged'
op() {
  open_file() {
    local file_name="$1"
    file_name="${file_name//$'\r'/}"
    if [ ! -e "$file_name" ]; then
      echo "'$file_name' does not exist." >&2
      return
    fi
    abs_path=$(readlink -f -- "$file_name")
    windows_path=$(cygpath -w -- "$abs_path")
    case "${windows_path##*.}" in
      "xl"*)
        start "" "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" //x "$windows_path" > /dev/null 2>&1;;
      "doc"*)
        start "" "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" //w "$windows_path" > /dev/null 2>&1;;
      *)
        start "" "$windows_path" > /dev/null 2>&1
    esac
  }
  if [ ! -t 0 ]; then
    while IFS= read -r std_input || [ -n "$std_input" ]; do
      open_file "$std_input"
    done
  fi
  for arg in "$@"; do
    open_file "$arg"
  done
  unset -f open_file
}
rd() {
  if [[ "$PS1" == *"$"* ]]; then
    PS1="${PS1//\\$/🦆}"
  else
    PS1="${PS1//🦆/\\$}"
  fi
}
alias gdn='git diff --name-only'
alias gdsn='git diff --staged --name-only'
alias cc='cat /dev/clipboard'
alias cco='cat /dev/clipboard | op'
alias gdt='git difftool'
pp() {
  local input_data
  if [ -t 0 ]; then
    input_data="$*"
  else
    input_data=$(cat)
  fi
  if [ -z "$input_data" ]; then
    return 1
  fi
  if ! python -c "from math import *; print($input_data)"; then
    echo "Error: Python execution failed." >&2
    return 1
  fi
}
alias swu='sudo winget.exe upgrade'
