#
#>>> Prompt >>>
PROMPT='%F{yellow}%n%f%F{white}@%f%F{cyan}%*%f %F{green}%~%f %F{white}%#%f '
#<<< Prompt <<<
#
#>>> zsh auto-completion and themes >>>
autoload -Uz compinit promptinit
compinit
promptinit
#
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# Open in tmux popup if on tmux, otherwise use --height mode
export FZF_DEFAULT_OPTS='--tmux bottom,90%,40% --layout reverse --border top'
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
#<<< zsh auto-completion and themes <<<
#
#>>> zsh shell options >>>
setopt extendedglob
setopt vi
#<<< zsh shell options <<<
#
#>>> Aliases >>>
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
#<<< Aliases <<<
#
#>>> help >>>
autoload run-help
HELPDIR=/usr/share/zsh/"${ZSH_VERSION}"/help
alias help=run-help
#<<< help <<<
#
#>>> bspwm >>>
bspc wm -r
#<<< bspwm <<<
#
#>>> Editor >>>
export VISUAL=nvim
export EDITOR="$VISUAL"
#<<< Editor <<<
#
#>>> History >>>
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
#<<< History <<<
#
#>>> tmux init >>>
if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi
#<<< tmux init <<<
#
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/usr/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/dojix/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
##
#>>> PATHS >>>
# --- Go Path ---
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
#
# --- Android SDK ---
export ANDROID_HOME=/opt/android-sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
#
# --- w3m ---
export W3M_DIR="$XDG_STATE_HOME/w3m"
#
# --- Rust ---
export CARGO_HOME="$XDG_DATA_HOME/cargo"
#
# --- npm ---
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
#
# --- Gradle ---
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
#
# --- Kaggle ---
export KAGGLE_CONFIG_DIR="$XDG_CONFIG_HOME/kaggle"
# --- Lua ---
export LUA_PATH="/usr/share/lua/5.1/?.lua;;"
export LUA_CPATH="/usr/lib/lua/5.1/?.so;;"
export PATH="/usr/lib/luajit-2.1.0-beta3:$PATH"
#<<< PATHS <<<
#
# >>> API Keys >>>
# --- LLMS --- 

# <<< API Keys <<<
#
