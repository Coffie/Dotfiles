if [ -n "${DOTFILES_SHELL_FUNCTIONS_LOADED:-}" ]; then
    return
fi
export DOTFILES_SHELL_FUNCTIONS_LOADED=1

if ! command -v __dotfiles_has_command >/dev/null 2>&1; then
    DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"
    DOTFILES_SHELL_ROOT="${DOTFILES_SHELL_ROOT:-$DOTFILES_ROOT/shell}"
    if [ -f "$DOTFILES_SHELL_ROOT/lib/utils.sh" ]; then
        . "$DOTFILES_SHELL_ROOT/lib/utils.sh"
    fi
fi

: "${SSH_ENV:=$HOME/.ssh/environment}"

# extract function
extract () {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1" ;;
            *.tar.gz)    tar xzf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.rar)       unrar e "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xf "$1" ;;
            *.tbz2)      tar xjf "$1" ;;
            *.tgz)       tar xzf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z e "$1" ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
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

kz() {
    for pid in $(ps axo pid=,stat= | awk '$2~/^Z/ { print $1 }') ; do
        kill -9  "$pid"
    done
}

test_flac() {
    for f in *.flac; do
        flac --test --warnings-as-errors "$f"
    done
}
# Convert files in folder using ffmpeg
convert_audio() {
    input=$1
    output=$2
    folder_done="${1}-done"
    folder_out="${2}s"
    mkdir -p "$folder_out" 
    mkdir -p "$folder_done"
    for f in *."$input"; do
        if [[ "$input" == "flac" ]]; then
            flac --test --warnings-as-errors "$f"
        fi
        filename="$folder_out/${f%."$input"}.$output"
        ffmpeg -i "${f}" -write_id3v2 1 -c:v copy "${filename}"
        mv "$f" "$folder_done"
    done
}

convert_heic_to_jpeg() {
    local heic_file="$1"
    local base_name="${heic_file%.*}"
    local extension="${heic_file##*.}"
    local jpeg_file

    if [[ -f "$heic_file" && "$extension" =~ [hH][eE][iI][cC] ]]; then
        jpeg_file="${base_name}.jpeg"
        sips -s format jpeg "$heic_file" --out "$jpeg_file"
        echo "Converted: $heic_file to $jpeg_file"
    else
        echo "Skipped: $heic_file (not a .heic file)"
    fi
}

# Generate a new SSH key with a consistent comment.
sshgen() {
    local default_label
    default_label="$(whoami)@$(hostname)-$(date +%Y-%m-%d)"
    local label="${1:-$default_label}"
    ssh-keygen -t ed25519 -C "$label"
}

# -------------------------------------------------------------------
# FZF helpers
# -------------------------------------------------------------------
if __dotfiles_has_command fd; then
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

if __dotfiles_has_command fzf; then
    _fzf_complete_mosh() {
        _fzf_complete_ssh "$@"
    }
fi

# -------------------------------------------------------------------
#  Convert magnet to torrent
# -------------------------------------------------------------------
magnet_to_torrent() {
    if [ -z "$1" ]; then
        echo "Usage: magnet_to_torrent <magnet-uri>" >&2
        return 1
    fi

    local magnet="$1"
    local hash filename decoder

    hash=$(printf '%s\n' "$magnet" | sed -n 's/.*xt=urn:btih:\([^&]*\).*/\1/p')
    if [ -z "$hash" ]; then
        echo "magnet_to_torrent: unable to parse BTIH hash" >&2
        return 1
    fi

    filename=$(printf '%s\n' "$magnet" | sed -n 's/.*dn=\([^&]*\).*/\1/p')
    if [ -n "$filename" ]; then
        if __dotfiles_has_command python3; then
            decoder=python3
        elif __dotfiles_has_command python; then
            decoder=python
        else
            decoder=
        fi

        if [ -n "$decoder" ]; then
            filename=$("$decoder" -c 'import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))' "$filename")
        fi
    fi

    filename=${filename:-$hash}
    printf 'd10:magnet-uri%d:%se' "${#magnet}" "$magnet" > "${filename}.torrent"
    echo "Created ${filename}.torrent"
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
    if [ -z "$1" ] ; then
        echo "any - search processes by keyword" >&2
        echo "Usage: any <pattern>" >&2
        return 1
    fi
    local pattern="$1"
    ps auxww | awk -v pat="$pattern" '
        NR == 1 { print; next }
        {
            line = tolower($0)
            needle = tolower(pat)
            if (index(line, needle)) {
                print $0
            }
        }
    '
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
      do asdf install "$lang" "$version"; done;
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
