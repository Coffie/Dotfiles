# mkdir and cd into it
mcd() {
    mkdir "${1}" && cd "${1}"
}

# Execute a command in a specific directory
xin() {
    (
        cd "${1}" && shift && "${@}"
    )
}

# Update dotfiles
dfu() {
    (
        cd ~/.dotfiles && git pull --ff-only && ./install -q
    )
}

path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink $HOME/.shell.here)"
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")"
}

# -------------------------------------------------------------------
#  Get my current IP address(es)
# -------------------------------------------------------------------
function myip() {
	if [[ "$(uname)" == "Darwin" ]];
	then
		ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
		ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
		ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
		ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
		ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
	else
  		ip addr show dev lo | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo       : " $2}'
  		ip addr show dev eth0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "eth0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  		ip addr show dev eth0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "eth0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  		ip addr show dev wlan0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "wlan0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  		ip addr show dev wlan0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "wlan0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	fi
}

# -------------------------------------------------------------------
#  Code review TODO: use git repo?
# -------------------------------------------------------------------
function code-review () {
  local is_git=$(git rev-parse --is-inside-work-tree 2> /dev/null)
  if [ -z $is_git ]; then
    echo "not a git repository"
    return
  fi

  local base_branch=${1:-${REVIEW_BASE_BRANCH:-master}}
  local target_branch=${2:-HEAD}

  local merge_base=$(git merge-base $target_branch $base_branch)

  local base_mode=true
  local base=$merge_base

  local shortstatout=$(git diff --shortstat --color $base $target_branch)
  local statout=$(git diff --stat --color $base $target_branch)
  local filesout=$(git diff --relative --name-only $base $target_branch)

  local LESS
  local selectfile

  setopt localtraps
  trap '' 2

  while true; do
    # alternate screen
    echo -ne "\e[?1049h"
    # clear screen; move to top left
    echo -ne "\e[2J\e[H"
    echo " comparing $base_branch..$target_branch | merge base mode: $base_mode"
    echo " from $(pwd)"
    echo $shortstatout
    echo -n " Usage:\n  l - list changed files\n  f - launch difftool for file\n  m - toggle merge base\n  y - git fetch\n  q - quit"
    read -sk opt
    case $opt in
      (l)
        echo $statout | less -c -g -i -M -R -S -w -X -z-4
        ;;
      (f)
        selectfile=$(echo "$filesout" | fzf --reverse --preview '[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --color=always -r :$FZF_PREVIEW_LINES {} || head -$FZF_PREVIEW_LINES {}) 2> /dev/null')
        # alternate screen
        echo -ne "\e[?1049h"
        if [ -z $selectfile ]; then
        else
          git difftool --no-prompt $merge_base $target_branch -- $selectfile
        fi
        ;;
      (m)
        if [ "$base_mode" = true ]; then
          base_mode=false
          base=$base_branch
        else
          base_mode=true
          base=$merge_base
        fi
        shortstatout=$(git diff --shortstat --color $base $target_branch)
        statout=$(git diff --stat --color $base $target_branch)
        filesout=$(git diff --relative --name-only $base $target_branch)
        ;;
      (y)
        git fetch
        ;;
      (q)
        break
        ;;
    esac
  done

  # revert alternate screen
  echo -ne "\e[?1049l"
}
# -------------------------------------------------------------------
#  Convert magnet to torrent 
# -------------------------------------------------------------------
function magnet_to_torrent() {
    [[ "$1" =~ xt=urn:brih:([^\&/]+) ]] || return 1

    hashh=${match[1]}

    if [[ "$1" =~ dn=([^\&/]+) ]];then
	  filename=${match[1]}
	else
	  filename=$hashh
	fi

	echo "d10:magnet-uri${#1}:${1}e" > "$filename.torrent"
}
# -------------------------------------------------------------------
#  Start a SSH-agent daemon, so that all SSH-keys are available.
# -------------------------------------------------------------------
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent -t 4h | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo "The SSH agent was started!"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

function add_keys {
   echo "Adding keys to existing SSH agent..."
   /usr/bin/ssh-add;
}

function init_ssh_agent {
    # Source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
	if ! ps -ef | grep ${SSH_AGENT_PID} | grep "ssh-agent.*$" > /dev/null; then
            start_agent;
        elif ! ssh-add -l > /dev/null; then
            add_keys;
        fi
    else
        start_agent;
    fi
}

# -------------------------------------------------------------------
# Function for searching running processes 
# -------------------------------------------------------------------

any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}
