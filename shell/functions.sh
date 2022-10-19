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

add_sorted() {
    echo "${1}" | sort -o "${2}" -m - "${2}"
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

kz() {
    for pid in $(ps axo pid=,stat= | awk '$2~/^Z/ { print $1 }') ; do
        kill -9  $pid
    done
}

# Not in use, asdf manages java
# Set JDK version
jdk() {
  version=$1
  unset JAVA_HOME;
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
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
        # else
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

# -------------------------------------------------------------------
# fzf functions
# -------------------------------------------------------------------
# ASDF functions
# Install one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to install
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
# Mnemonic [V]ersion [M]anager [I]nstall
vmi() {
  local lang=${1}

  if [[ ! $lang ]]; then
    lang=$(asdf plugin-list | fzf)
  fi

  if [[ $lang ]]; then
    local versions=$(asdf list-all $lang | fzf --tac --no-sort --multi)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do asdf install $lang $version; done;
    fi
  fi
}

# Remove one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to remove
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
# Mnemonic [V]ersion [M]anager [C]lean
vmc() {
  local lang=${1}

  if [[ ! $lang ]]; then
    lang=$(asdf plugin-list | fzf)
  fi

  if [[ $lang ]]; then
    local versions=$(asdf list $lang | fzf -m)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do asdf uninstall $lang $version; done;
    fi
  fi
}

# Interactive cd when called with no arguments
function cdi() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p -FG "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}