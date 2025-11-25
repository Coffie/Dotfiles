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
    if [ "$#" -eq 0 ]; then
        echo "Usage: extract <archive>" >&2
        return 1
    fi

    local archive="$1"
    if [ ! -f "$archive" ]; then
        echo "extract: '$archive' is not a valid file" >&2
        return 1
    fi

    case "$archive" in
        *.tar.bz2)   tar xjf "$archive" ;;
        *.tar.gz)    tar xzf "$archive" ;;
        *.bz2)       bunzip2 "$archive" ;;
        *.rar)       unrar e "$archive" ;;
        *.gz)        gunzip "$archive" ;;
        *.tar)       tar xf "$archive" ;;
        *.tbz2)      tar xjf "$archive" ;;
        *.tgz)       tar xzf "$archive" ;;
        *.zip)       unzip "$archive" ;;
        *.Z)         uncompress "$archive" ;;
        *.7z)        7z e "$archive" ;;
        *)
            echo "extract: '$archive' cannot be extracted automatically" >&2
            return 1
            ;;
    esac
}

# Execute a command in a specific directory
xin() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: xin <directory> <command...>" >&2
        return 1
    fi
    (
        cd "$1" >/dev/null 2>&1 || exit
        shift
        "$@"
    )
}

# Update dotfiles
dfu() {
    if ! command -v git >/dev/null 2>&1; then
        echo "dfu: git is not available in PATH" >&2
        return 1
    fi
    (
        set -e
        cd "$HOME/.dotfiles" || exit 1
        git pull --ff-only
        ./install -q
    )
}

add_sorted() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: add_sorted <newline-separated-input> <file>" >&2
        return 1
    fi
    printf "%s\n" "$1" | sort -o "$2" -m - "$2"
}

kz() {
    ps axo pid=,stat= | awk '$2 ~ /^Z/ { print $1 }' | while read -r pid; do
        kill -9 "$pid"
    done
}

test_flac() {
    if ! command -v flac >/dev/null 2>&1; then
        echo "test_flac: flac command not found" >&2
        return 1
    fi
    local exit_code=0
    for f in ./*.flac; do
        [ -e "$f" ] || continue
        if ! flac --test --warnings-as-errors "$f"; then
            exit_code=1
        fi
    done
    return "$exit_code"
}

# Convert files in folder using ffmpeg
convert_audio() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: convert_audio <from-extension> <to-extension>" >&2
        return 1
    fi
    if ! command -v ffmpeg >/dev/null 2>&1; then
        echo "convert_audio: ffmpeg not found" >&2
        return 1
    fi
    local input="$1"
    local output="$2"
    local folder_done="${input}-done"
    local folder_out="${output}s"
    mkdir -p "$folder_out" "$folder_done"
    local exit_code=0
    for f in ./*."$input"; do
        [ -e "$f" ] || continue
        if [ "$input" = "flac" ] && command -v flac >/dev/null 2>&1; then
            flac --test --warnings-as-errors "$f"
        fi
        local filename="$folder_out/$(basename "${f%."$input"}").$output"
        if ffmpeg -i "$f" -write_id3v2 1 -c:v copy "$filename"; then
            mv "$f" "$folder_done/"
        else
            exit_code=1
        fi
    done
    return "$exit_code"
}

convert_heic_to_jpeg() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: convert_heic_to_jpeg <image.heic>" >&2
        return 1
    fi
    if ! command -v sips >/dev/null 2>&1; then
        echo "convert_heic_to_jpeg: sips command not found" >&2
        return 1
    fi

    local heic_file="$1"
    local base_name="${heic_file%.*}"
    local extension="${heic_file##*.}"

    if [[ -f "$heic_file" && "$extension" =~ [hH][eE][iI][cC] ]]; then
        local jpeg_file="${base_name}.jpeg"
        sips -s format jpeg "$heic_file" --out "$jpeg_file"
        printf "Converted: %s -> %s\n" "$heic_file" "$jpeg_file"
    else
        echo "Skipped: $heic_file (not a .heic file)" >&2
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
_fzf_compgen_path() {
    if __dotfiles_has_command fd; then
        fd --hidden --follow --exclude ".git" . "$1"
    else
        find "$1" -path '*/.git' -prune -o -print
    fi
}

_fzf_compgen_dir() {
    if __dotfiles_has_command fd; then
        fd --type d --hidden --follow --exclude ".git" . "$1"
    else
        find "$1" -path '*/.git' -prune -o -type d -print
    fi
}

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
    local hash filename

    if __dotfiles_has_command python3 || __dotfiles_has_command python; then
        local python_bin="python3"
        __dotfiles_has_command python3 || python_bin="python"
        read -r hash filename <<EOF
$("$python_bin" - <<'PY' "$magnet"
import sys, urllib.parse
magnet = sys.argv[1]
parts = urllib.parse.parse_qs(urllib.parse.urlparse(magnet).query)
btih = ''
if 'xt' in parts:
    for value in parts['xt']:
        if value.startswith('urn:btih:'):
            btih = value.split(':')[-1]
            break
name = parts.get('dn', [''])[0]
print(btih)
print(name)
PY
)
EOF
    else
        hash=$(printf '%s\n' "$magnet" | sed -n 's/.*xt=urn:btih:\([^&]*\).*/\1/p')
        filename=$(printf '%s\n' "$magnet" | sed -n 's/.*dn=\([^&]*\).*/\1/p')
    fi

    if [ -z "$hash" ]; then
        echo "magnet_to_torrent: unable to parse BTIH hash" >&2
        return 1
    fi

    [ -n "$filename" ] || filename=""

    filename=${filename:-$hash}
    printf 'd10:magnet-uri%d:%se' "${#magnet}" "$magnet" > "${filename}.torrent"
    printf "Created %s.torrent\n" "$filename"
}
# -------------------------------------------------------------------
#  Start a SSH-agent daemon, so that all SSH-keys are available.
# -------------------------------------------------------------------
function start_agent {
    if ! command -v ssh-agent >/dev/null 2>&1 || ! command -v ssh-add >/dev/null 2>&1; then
        echo "start_agent: ssh-agent or ssh-add not available" >&2
        return 1
    fi

    echo "Initialising new SSH agent..."
    local agent_tmp
    agent_tmp="${SSH_ENV}.tmp"
    mkdir -p "$(dirname "$SSH_ENV")"
    if ! ssh-agent -s -t 4h | sed 's/^echo/#echo/' > "$agent_tmp"; then
        echo "start_agent: failed to launch ssh-agent" >&2
        rm -f "$agent_tmp"
        return 1
    fi
    mv "$agent_tmp" "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" >/dev/null
    printf "The SSH agent was started! PID %s\n" "${SSH_AGENT_PID:-unknown}"
    ssh-add
}

function add_keys {
   if ! command -v ssh-add >/dev/null 2>&1; then
       echo "add_keys: ssh-add not available" >&2
       return 1
   fi
   echo "Adding keys to existing SSH agent..."
   ssh-add
}

function init_ssh_agent {
    # Source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        if ! ps -p "${SSH_AGENT_PID:-0}" >/dev/null 2>&1; then
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
  if ! command -v asdf >/dev/null 2>&1; then
    echo "vmi: asdf not installed" >&2
    return 1
  fi
  if ! __dotfiles_has_command fzf; then
    echo "vmi: fzf is required for interactive selection" >&2
    return 1
  fi

  local lang="${1:-}"

  if [[ -z $lang ]]; then
    lang=$(asdf plugin-list | fzf --prompt="plugin> ")
  fi

  if [[ -n $lang ]]; then
    local versions
    versions=$(asdf list-all "$lang" | fzf --tac --no-sort --multi --prompt="${lang}> ")
    if [[ -n $versions ]]; then
      while read -r version; do
        asdf install "$lang" "$version"
      done <<< "$versions"
    fi
  fi
}

# Remove one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to remove
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
# Mnemonic [V]ersion [M]anager [C]lean
vmc() {
  if ! command -v asdf >/dev/null 2>&1; then
    echo "vmc: asdf not installed" >&2
    return 1
  fi
  if ! __dotfiles_has_command fzf; then
    echo "vmc: fzf is required for interactive selection" >&2
    return 1
  fi

  local lang="${1:-}"

  if [[ -z $lang ]]; then
    lang=$(asdf plugin-list | fzf --prompt="plugin> ")
  fi

  if [[ -n $lang ]]; then
    local versions
    versions=$(asdf list "$lang" | fzf -m --prompt="${lang}> ")
    if [[ -n $versions ]]; then
      while read -r version; do
        asdf uninstall "$lang" "$version"
      done <<< "$versions"
    fi
  fi
}

# Interactive cd when called with no arguments
function cdi() {
    if [[ "$#" -gt 0 ]]; then
        builtin cd "$@"
        return
    fi

    while true; do
        local entries=()
        entries+=(..)
        while IFS= read -r dir; do
            entries+=("${dir#./}")
        done < <(find . -mindepth 1 -maxdepth 1 -type d ! -name '.git' -print | sort)

        local selection
        selection=$(printf '%s\n' "${entries[@]}" | fzf --prompt="cd> " --reverse --preview '
            target="{}"
            if [ "$target" = ".." ]; then
                path="$(cd .. && pwd)"
            elif [ -z "$target" ] || [ "$target" = "." ]; then
                path="$(pwd)"
            else
                path="$(pwd)/$target"
            fi
            printf "%s\n\n" "$path"
            ls -Ap "$path" 2>/dev/null
        ')

        [[ -n $selection ]] || return 0
        builtin cd "$selection" >/dev/null 2>&1 || return 1
    done
}
