# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -z "$CURSOR_AGENT" ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz compinit
compinit

bindkey -e

eval "$(/opt/homebrew/bin/brew shellenv)"

files=(
  "$HOME/.path"
  "$HOME/.completions"
  "$HOME/.aliases"
  "$HOME/.friends"
  "$HOME/.vars"
  "$HOME/bin/resources/font-map.sh"
  "$HOME/GitHub/credentials/git-tokens"
)

for f in "${files[@]}"; do
  [ -f "$f" ] && source "$f"
done

save_aliases=$(alias -L)
setopt nocaseglob
setopt nullglob

# allow doing `../path/to/dir` instead of `cd ../path/to/dir`
setopt AUTO_CD

export JFX=$HOME/Library/Java/javafx-sdk-11.0.2/lib/
export SUBL_CFG="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
export HOMEBREW_CASK_OPTS=--no-quarantine

export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export ANDROID_SDK_ROOT=/opt/homebrew/share/android-commandlinetools
export ANDROID_AVD_HOME=$HOME/.android/avd

export NLTK_DATA=/usr/local/share/
# export PGDATABASE=raiddb
export R_MAX_VSIZE=32000000000

DISABLE_UPDATE_PROMPT=true

# ~/.zshrc — disable Powerlevel10k when Cursor Agent runs
if [[ -n "$CURSOR_AGENT" ]]; then
  # Skip theme initialization for better compatibility
else
  # export ZSH="$HOME/.oh-my-zsh"
  # ZSH_THEME=""
  # source $ZSH/oh-my-zsh.sh
  # ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
  source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
fi

EDITOR='vim'; export EDITOR

# POWERLEVEL9K_CUSTOM_SSH_PROMPT="~/bin/ssh_prompt"
# POWERLEVEL9K_CUSTOM_SSH_PROMPT_BACKGROUND=013
# POWERLEVEL9K_CUSTOM_SSH_PROMPT_FOREGROUND=black

# POWERLEVEL9K_CUSTOM_PIA_ON="~/bin/pia-on"
# POWERLEVEL9K_CUSTOM_PIA_ON_BACKGROUND='black'
# POWERLEVEL9K_CUSTOM_PIA_ON_FOREGROUND='green'

# POWERLEVEL9K_CUSTOM_PIA_OFF="~/bin/pia-off"
# POWERLEVEL9K_CUSTOM_PIA_OFF_BACKGROUND='black'
# POWERLEVEL9K_CUSTOM_PIA_OFF_FOREGROUND='red'

# POWERLEVEL9K_CUSTOM_COMMITS="~/bin/commits_yes"
# POWERLEVEL9K_CUSTOM_COMMITS_BACKGROUND='blue'
# POWERLEVEL9K_CUSTOM_COMMITS_FOREGROUND='black'

# POWERLEVEL9K_CUSTOM_NO_COMMITS="~/bin/commits_no"
# POWERLEVEL9K_CUSTOM_NO_COMMITS_BACKGROUND='red'
# POWERLEVEL9K_CUSTOM_NO_COMMITS_FOREGROUND='white'

# POWERLEVEL9K_CUSTOM_NOW_PLAYING='~/bin/nowplaying'
# POWERLEVEL9K_CUSTOM_NOW_PLAYING_BACKGROUND='yellow'
# POWERLEVEL9K_CUSTOM_NOW_PLAYING_FOREGROUND='black'

# POWERLEVEL9K_CUSTOM_SPACE='~/bin/space'
# POWERLEVEL9K_CUSTOM_SPACE_BACKGROUND='blue'

# POWERLEVEL9K_CUSTOM_TIME='~/bin/space'
# POWERLEVEL9K_CUSTOM_SPACE_BACKGROUND='blue'

# # Disable dir/git icons
# POWERLEVEL9K_HOME_ICON=''
# POWERLEVEL9K_HOME_SUB_ICON=''
# POWERLEVEL9K_FOLDER_ICON=''

# DISABLE_AUTO_TITLE="true"

# POWERLEVEL9K_VCS_GIT_ICON=''
# POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
# POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
# POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
# POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
# POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'

# POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
# POWERLEVEL9K_VCS_FOREGROUND='141'
# POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='073'

# POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
# POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4

# POWERLEVEL9K_CUSTOM_BETTER_PATH='~/bin/better_path'
# POWERLEVEL9K_CUSTOM_BETTER_PATH_BACKGROUND='blue'

# # POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
# POWERLEVEL9K_DIR_PATH_ABSOLUTE="false"
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_SHORTEN_DELIMITER=".."
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_right"

# POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"
# POWERLEVEL9K_TIME_BACKGROUND="black"
# POWERLEVEL9K_TIME_FOREGROUND="white"

# POWERLEVEL9K_STATUS_VERBOSE=false
# # POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# # POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
# # POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
# # POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\ue0b0"
# # POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=( 
#                                     # custom_now_playing 
#                                     # time 
#                                     custom_pia_on 
#                                     custom_pia_off
# )
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(root_indicator
#                                    custom_ssh_prompt
#                                    custom_better_path
#                                    vcs
#                                    virtualenv
#                                    custom_commits 
#                                    custom_no_commits 
#                                    newline
#                                    custom_space
# )
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
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
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
export HISTORY_IGNORE="timer*"

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# Ensure zle widgets are available
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind arrows to prefix search, cursor stays at end
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# export PATH="$PATH:$HOME/.cargo/bin"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f $HOME/.dart-cli-completion/zsh-config.zsh ]] && . $HOME/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Load Powerlevel10k configuration unless Cursor Agent is running
if [[ -z "$CURSOR_AGENT" && -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

eval "$(direnv hook zsh)"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions

# Corporate CA certificates for Node.js and CLI tools (e.g. Graphite, Python requests/ssl, curl)
export NODE_EXTRA_CA_CERTS="${HOME}/.config/certs/ca-certs.pem"
export REQUESTS_CA_BUNDLE="${HOME}/.config/certs/ca-certs.pem"
export SSL_CERT_FILE="${HOME}/.config/certs/ca-certs.pem"
export CURL_CA_BUNDLE="${HOME}/.config/certs/ca-certs.pem"
