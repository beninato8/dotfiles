source $HOME/.aliases
source $HOME/.friends
source $HOME/.vars
source $HOME/.path
source $HOME/bin/resources/font-map.sh
source $HOME/GitHub/credentials/git-tokens
save_aliases=$(alias -L)
setopt nocaseglob
setopt nullglob

export JFX=$HOME/Library/Java/javafx-sdk-11.0.2/lib/
export SUBL_CFG="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
export HOMEBREW_CASK_OPTS=--no-quarantine

export NLTK_DATA=/usr/local/share/
export PGDATABASE=raiddb
export R_MAX_VSIZE=32000000000
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
DISABLE_UPDATE_PROMPT=true

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git-open
  chucknorris
  zsh-autosuggestions
  osx
  virtualenv
)

source $ZSH/oh-my-zsh.sh

ZSH_THEME_VIRTUALENV_PREFIX="("
ZSH_THEME_VIRTUALENV_SUFFIX=")"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

EDITOR='/usr/local/bin/vim'; export EDITOR

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# See also https://github.com/Falkor/dotfiles/blob/master/oh-my-zsh/
# Font taken from https://github.com/stefano-meschiari/dotemacs/blob/master/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
#
# See also https://github.com/Falkor/dotfiles/blob/master/oh-my-zsh/
# Font taken from https://github.com/stefano-meschiari/dotemacs/blob/master/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf

POWERLEVEL9K_MODE='awesome-mapped-fontconfig'

POWERLEVEL9K_CUSTOM_SSH_PROMPT="~/bin/ssh_prompt"
POWERLEVEL9K_CUSTOM_SSH_PROMPT_BACKGROUND=013
POWERLEVEL9K_CUSTOM_SSH_PROMPT_FOREGROUND=black

POWERLEVEL9K_CUSTOM_PIA_ON="~/bin/pia-on"
POWERLEVEL9K_CUSTOM_PIA_ON_BACKGROUND='black'
POWERLEVEL9K_CUSTOM_PIA_ON_FOREGROUND='green'

POWERLEVEL9K_CUSTOM_PIA_OFF="~/bin/pia-off"
POWERLEVEL9K_CUSTOM_PIA_OFF_BACKGROUND='black'
POWERLEVEL9K_CUSTOM_PIA_OFF_FOREGROUND='red'

POWERLEVEL9K_CUSTOM_COMMITS="~/bin/commits_yes"
POWERLEVEL9K_CUSTOM_COMMITS_BACKGROUND='blue'
POWERLEVEL9K_CUSTOM_COMMITS_FOREGROUND='black'

POWERLEVEL9K_CUSTOM_NO_COMMITS="~/bin/commits_no"
POWERLEVEL9K_CUSTOM_NO_COMMITS_BACKGROUND='red'
POWERLEVEL9K_CUSTOM_NO_COMMITS_FOREGROUND='white'

POWERLEVEL9K_CUSTOM_NOW_PLAYING='~/bin/nowplaying'
POWERLEVEL9K_CUSTOM_NOW_PLAYING_BACKGROUND='yellow'
POWERLEVEL9K_CUSTOM_NOW_PLAYING_FOREGROUND='black'

POWERLEVEL9K_CUSTOM_SPACE='~/bin/space'
POWERLEVEL9K_CUSTOM_SPACE_BACKGROUND='blue'

POWERLEVEL9K_CUSTOM_TIME='~/bin/space'
POWERLEVEL9K_CUSTOM_SPACE_BACKGROUND='blue'

# Disable dir/git icons
POWERLEVEL9K_HOME_ICON=''
POWERLEVEL9K_HOME_SUB_ICON=''
POWERLEVEL9K_FOLDER_ICON=''

DISABLE_AUTO_TITLE="true"

POWERLEVEL9K_VCS_GIT_ICON=''
POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_FOREGROUND='141'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='073'

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4

POWERLEVEL9K_CUSTOM_BETTER_PATH='~/bin/better_path'
POWERLEVEL9K_CUSTOM_BETTER_PATH_BACKGROUND='blue'

# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_DIR_PATH_ABSOLUTE="false"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER=".."
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_right"

POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
POWERLEVEL9K_TIME_BACKGROUND="black"
POWERLEVEL9K_TIME_FOREGROUND="white"

POWERLEVEL9K_STATUS_VERBOSE=false
# POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\ue0b0"
# POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=( 
                                    # custom_now_playing 
                                    time 
                                    custom_pia_on 
                                    custom_pia_off
)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator
                                   custom_ssh_prompt
                                   custom_better_path
                                   vcs
                                   virtualenv
                                   custom_commits 
                                   custom_no_commits 
                                   newline
                                   custom_space
)
export DEFAULT_USER="$USER"

# unalias -m '*'
eval $save_aliases; unset save_aliases
case ":$PATH:" in
  *":$new_entry:"*) :;; # already there
  *) PATH="$new_entry:$PATH";; # or PATH="$PATH:$new_entry"
esac
# export LSCOLORS="b"

eval $(thefuck --alias tf)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
# if command -v pyenv 1>/dev/null 2>&1; then 
#   eval "$(pyenv init --path)" 
#   eval "$(pyenv init -)" 
# fi
eval $(gdircolors -b $HOME/.dircolors)
source "$(brew --prefix)/etc/profile.d/z.sh"
# if which swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi
export CPPFLAGS=-I$(brew --prefix openssl)/include
export LDFLAGS=-L$(brew --prefix openssl)/lib
export CLICOLOR=1;

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

export HISTFILE=~/.zsh_history
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
# setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
export HISTORY_IGNORE="timer*"

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# export PATH="$PATH:/Users/Nicholas/.cargo/bin"
# source /Users/Nicholas/GitHub/faction/openpilot/tools/openpilot_env.sh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/Nicholas/.dart-cli-completion/zsh-config.zsh ]] && . /Users/Nicholas/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

