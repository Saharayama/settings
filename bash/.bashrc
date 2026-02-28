# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

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
alias wu='winget.exe upgrade'
alias wf='winget.exe find'
alias ws='winget.exe show'
alias g-='git switch -'
alias gb='git branch'
alias gl='git log --oneline --pretty=format:"%C(auto)%h %C(cyan)%cd%C(auto)%d %s %C(green bold dim)%an%Creset" --date=format:"%Y-%m-%d %H:%M:%S"'
alias glr='gl --reverse'
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
export HISTIGNORE=cd:'exp .':la:las:rs:wu:g-:gb:gl:glr:grl:gs:gf:wttr:gst:gr:gr-:pve:gd:cpc:gds:gdn:gdsn:cc:cco:gdt:gi:gsn:gba:gla:priv
export PROMPT_COMMAND="history -a"
mkcd() {
  if ! [ -d "$1" ]; then
    mkdir -p "$1" && cd "$1"
  else
    echo "Directory '$1' already exists." >&2
    return 1
  fi
}
alias pve='python.exe -m venv --upgrade-deps .venv && . .venv/Scripts/activate'
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
tree() {
  local path=""
  if [ -n "$1" ]; then
    path="\"$1\""
  fi
  pwsh.exe -c "tree /f "$path""
}
alias xargs='xargs '
alias gds='git diff --staged'
op() {
  open_file() {
    local file_name="${1//$'\r'/}"
    if [ ! -e "$file_name" ]; then
      echo "'$file_name' does not exist." >&2
      return
    fi
    local abs_path=$(readlink -f -- "$file_name")
    local windows_path=$(cygpath -w -- "$abs_path")
    case "${windows_path##*.}" in
      "xl"*)
        start "" "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" //x "$windows_path" > /dev/null 2>&1;;
      "doc"*)
        start "" "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" //w "$windows_path" > /dev/null 2>&1;;
      *)
        rundll32.exe url.dll,FileProtocolHandler "$windows_path" > /dev/null 2>&1
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
alias gdn='git diff --name-status'
alias gdsn='git diff --staged --name-status'
alias cc='cat /dev/clipboard'
alias cco='cat /dev/clipboard | op'
alias gdt='git difftool'
pp() {
  local input_pipe=""
  if [ ! -t 0 ]; then
    IFS=$'\r' read -r input_pipe || true
  fi
  MSYS_NO_PATHCONV=1 python.exe -Sc "
import sys
from math import *
def solve():
  pipe_val = sys.argv[1]
  expressions = sys.argv[2:]
  if not expressions and not pipe_val:
    return
  if not expressions and pipe_val:
    expressions = pipe_val.split()
    pipe_val = ''
  if sys.stdout.isatty():
    CYAN = '\033[96m'
    RED = '\033[1;91m'
    RESET = '\033[0m'
  else:
    CYAN = RED = RESET = ''
  for i, expr in enumerate(expressions):
    if not expr.strip():
      continue
    if '@' in expr:
      final_expr = expr.replace('@', pipe_val)
    else:
      final_expr = f'{pipe_val} {expr}'.strip()
    try:
      result = eval(final_expr)
      output = []
      if isinstance(result, int):
        sign = '-' if result < 0 else ''
        abs_val = abs(result)
        h = hex(result).upper().replace('X', 'x', 1)
        b_raw = bin(result)
        b_abs = f'{abs_val:b}'
        blen = len(b_abs)
        fmt_b = '_'.join(b_abs[::-1][i:i+4] for i in range(0, blen, 4))[::-1]
        output = [str(result), h, b_raw, f'{sign}0b{fmt_b} ({blen})']
      else:
        output = [str(result)]
      msg = '\n'.join(output)
      if i % 2 == 1:
        print(f'{CYAN}{msg}{RESET}')
      else:
        print(msg)
    except Exception as e:
      err_msg = getattr(e, 'msg', str(e))
      print(f'{RED}Error at #{i+1}: {err_msg}{RESET}', file=sys.stderr)
      sys.exit(1)
solve()
" "$input_pipe" "$@"
}
alias swu='sudo winget.exe upgrade'
dh() {
  if [[ ! "$PROMPT_COMMAND" =~ "history -a" ]]; then
    echo "Error: 'history -a' is not found in PROMPT_COMMAND" >&2
    return 1
  fi
  local offset_from_end=${1:-1}
  if ! [[ "$offset_from_end" =~ ^[1-9][0-9]*$ ]]; then
    echo "Usage: dh [OFFSET_FROM_END]" >&2
    return 1
  fi
  local total_lines=$(wc -l < ~/.bash_history)
  local line_num=$((total_lines - offset_from_end + 1))
  if [[ "$line_num" -lt 1 ]]; then
    echo "Error: out of range" >&2
    return 1
  fi
  local line_content=$(sed -n "${line_num}{p;q}" ~/.bash_history)
  ex -sc "${line_num}d|wq" ~/.bash_history && history -c && history -r
  local red=""
  local reset=""
  if [[ -t 1 ]]; then
    red='\033[1;91m'
    reset='\033[0m'
  fi
  printf "${red}Deleted:${reset} %s\r\n" "$line_content"
}
await() {
  if [ -z "$1" ]; then
    echo "Usage: await <end_time>" >&2
    return 1
  fi
  local end_time_input="$1"
  local end_time_unix=""
  end_time_unix=$(date -d "$end_time_input" +%s 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: Invalid datetime format" >&2
    return 1
  fi
  local end_time_output="$(date -d "@$end_time_unix" '+%H:%M:%S')"
  echo "終了時間: $end_time_output"
  while true; do
    local current_time_unix=$(date +%s)
    if [ "$current_time_unix" -ge "$end_time_unix" ]; then
      echo "残り時間: 00:00:00"
      ntf.exe "${end_time_output} になりました"
      break
    fi
    local remaining=$((end_time_unix - current_time_unix))
    echo -ne "残り時間: $(date -u -d "@$remaining" '+%H:%M:%S')\r"
    sleep 1
  done
}
tmr() {
  local meas_time="$1"
  local message="$2"
  sleep "$meas_time" && ntf.exe ""$meas_time" 経過 (at $(date '+%H:%M:%S'))" "$message"
}
alias gi='git ls-files --others --ignored --exclude-standard'
alias gsn='git show --name-status --pretty=""'
alias gba='gb --all'
alias gla='gl --all'
dhm() {
  local offset_from_end=${1:-1}
  if [[ ! "$offset_from_end" =~ ^[1-9][0-9]*$ ]]; then
    echo "Usage: dh [OFFSET_FROM_END]" >&2
    return 1
  fi
  local cur=$(history 1 | awk '{print $1}')
  local line_num=$((cur - offset_from_end))
  if [[ "$line_num" -le 0 ]]; then
    echo "Error: out of range" >&2
    return 1
  fi
  local line_content=$(fc -ln "$line_num" "$line_num" | sed 's/^[[:space:]]*//')
  history -d "$cur"
  history -d "$line_num"
  local red=""
  local reset=""
  if [[ -t 1 ]]; then
    red='\033[1;91m'
    reset='\033[0m'
  fi
  printf "${red}Deleted:${reset} %s\r\n" "$line_content"
}
priv() {
  if [[ -z "${IN_PRIV_MODE:-}" ]]; then
    export IN_PRIV_MODE=1
    bash --rcfile <(echo 'source "${HOME}/.bashrc"')
    unset IN_PRIV_MODE
  else
    echo "Error: already in private mode" >&2
    return 1
  fi
}
if [[ -n "${IN_PRIV_MODE:-}" ]]; then
  PS1="(priv) ${PS1}"
  history -r
  unset HISTFILE dh
  alias dh='dhm'
fi
alias cc1='cc | tr -d "\r" | xargs'
_pp_signed() {
  local bit_width=$1
  shift
  local input_pipe=""
  if [ ! -t 0 ]; then
    IFS=$'\r\n' read -r input_pipe || true
  fi
  MSYS_NO_PATHCONV=1 python.exe -Sc "
import sys
from math import *
def solve():
  CYAN, RED, YELLOW, RESET = ('\033[96m', '\033[1;91m', '\033[1;93m', '\033[0m') if sys.stdout.isatty() else ('', '', '', '')
  i = -1
  try:
    width = int(sys.argv[1])
    h_len = width // 4
    pipe_in = sys.argv[2].strip()
    args = sys.argv[3:]
    all_exprs = args if args else (pipe_in.split() if pipe_in else [])
    if not all_exprs:
      return
    for i, expr in enumerate(all_exprs):
      if not expr.strip():
        continue
      res = eval(expr)
      if isinstance(res, int):
        min_val, max_val = -(1 << (width - 1)), (1 << width) - 1
        if res < min_val or res > max_val:
          print(f'{YELLOW}Warning: {res} is out of range for {width}-bit ({min_val} to {max_val}){RESET}', file=sys.stderr)
        mask = (1 << width) - 1
        u_val = res & mask
        s_val = u_val - (1 << width) if u_val & (1 << (width - 1)) else u_val
        h_str = f'0x{u_val:0{h_len}X}'
        b_raw = f'0b{u_val:0{width}b}'
        b_str = f'{u_val:0{width}b}'
        parts = [b_str[max(0, j-4):j] for j in range(len(b_str), 0, -4)][::-1]
        b_fmt = '0b' + '_'.join(parts)
        output = f'{s_val}\n{h_str}\n{b_raw}\n{b_fmt} ({width})'
      else:
        output = str(res)
      if i % 2 == 1:
        print(f'{CYAN}{output}{RESET}')
      else:
        print(output)
  except Exception as e:
    err_msg = getattr(e, 'msg', str(e))
    loc = f' at #{i+1}' if i >= 0 else ''
    print(f'{RED}Error{loc}: {err_msg}{RESET}', file=sys.stderr)
    sys.exit(1)
solve()
" "$bit_width" "$input_pipe" "$@"
}
p1() { _pp_signed 8 "$@"; }
p2() { _pp_signed 16 "$@"; }
p4() { _pp_signed 32 "$@"; }
p8() { _pp_signed 64 "$@"; }
alias su='store.exe updates'
