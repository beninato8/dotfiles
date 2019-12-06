source $HOME/.aliases
source $HOME/.friends
source $HOME/.vars
source $HOME/bin/resources/font-map.sh
save_aliases=$(alias -L)
setopt nocaseglob
setopt nullglob

# If you come from bash you might have to change your $PATH.
# export PATH=/usr/local/opt/python@2/libexec/bin:/usr/local/opt/python@2/bin:$PATH
# export PATH=~/Library/Python/2.7/bin:$PATH
# export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
export PATH=/Applications/Xcode.app/Contents/Developer/usr/bin/:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/dotfiles:$PATH
export PATH=$HOME/bin:$PATH
export PATH=/usr/local/bin:$PATH

export JFX=$HOME/Library/Java/javafx-sdk-11.0.2/lib/

# echo $PATH
# export PATH=/usr/local/Cellar/python/3.7.0/Frameworks/Python.framework/Versions/3.7/bin:$PATH
# export PATH=/usr/local/Cellar/python/3.6.5_1/Frameworks/Python.framework/Versions/3.6/bin:$PATH
export NLTK_DATA=/usr/local/share/

# Path to your oh-my-zsh installation.
export ZSH=/Users/Nicholas/.oh-my-zsh
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
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git-open
  chucknorris
)

source $ZSH/oh-my-zsh.sh

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
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs custom_commits custom_no_commits custom_now_playing time)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator custom_better_path)
export DEFAULT_USER="$USER"

# unalias -m '*'
eval $save_aliases; unset save_aliases
case ":$PATH:" in
  *":$new_entry:"*) :;; # already there
  *) PATH="$new_entry:$PATH";; # or PATH="$PATH:$new_entry"
esac
export LSCOLORS="GxfxcxdxbxegedabagGxGx"

eval $(thefuck --alias tf)
eval "$(pyenv init -)"
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# export $ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$(brew --prefix)/share/zsh-syntax-highlighting/highlighters/"

export HISTFILE=~/.zsh_history
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE
setopt HIST_FIND_NO_DUPS

setopt inc_append_history
setopt share_history