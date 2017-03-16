export TERM="xterm-256color"
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.dotfiles/Zsh/.oh-my-zsh


# Init jenv
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# Set theme and default user
ZSH_THEME="powerlevel9k/powerlevel9k"
DEFAULT_USER="coffie"

# Powerlevel 9k configuration
# Set left and right prompt
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status battery ram ip)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(time context dir vcs)

# Battery configuration
POWERLEVEL9K_BATTERY_LOW_BACKGROUND="black"
POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="black"
POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="black"
POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="black"
POWERLEVEL9K_BATTERY_LOW_FOREGROUND="red"
POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND="yellow"
POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND="green"
POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="249"
POWERLEVEL9K_BATTERY_VERBOSE=false
POWERLEVEL9K_BATTERY_LOW_THRESHOLD=10

POWERLEVEL9K_TIME_BACKGROUND="black"
POWERLEVEL9K_TIME_FOREGROUND=249
POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

POWERLEVEL9K_IP_BACKGROUND="black"
POWERLEVEL9K_IP_FOREGROUND=249

POWERLEVEL9K_RAM_BACKGROUND="black"
POWERLEVEL9K_RAM_FOREGROUND=249

# Directory modification
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2

POWERLEVEL9K_RAM_ELEMENTS=(ram_used)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man colorize github pip python brew osx
zsh-syntax-highlighting wd)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias szsh="source ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias cass="mosh cass"
alias sv="source venv/bin/activate"
alias house='mosh house"
alias ydl='youtube-dl  --extract-audio --audio-quality 320k --audio-format mp3'
alias mush='ncmpcpp -h 192.168.35.133'
