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
#>>> Prompt >>>     
function prompt_norm_setup() {
  PS1='%n%@%* %~ %# '
  prompt_opts=(percent)
}

autoload -Uz promptinit; promptinit
prompt_themes+=(norm)
prompt fade blue grey white
#PROMPT='%F{blue}%n%f%F{white}@%f%F{cyan}%*%f %F{green}%~%f %F{white}%#%f '
#<<< Prompt <<<                          
# >>> autocomplete initialize >>
autoload -Uz compinit
compinit
# <<< auto complete initialize <<<
#
# >>> Load Angular CLI autocompletion. >>>
source <(ng completion script)
# <<< Load Angular CLI autocompletion. <<<
#
# >>> iTerm2 Integration >>>
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# <<< iTerm2 Integration <<<

# >>> Auto tmux >>>
if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi
# <<< Auto tmux <<<
#>>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# 
# >>> GO PATH >>>
export GOPATH=$HOME/Workspace/Go/
#export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
#<<< GO PATH <<<
#>>> LUA PATH >>>
export LUA_PATH='/usr/local/share/lua/5.1/?.lua;;'
export LUA_CPATH='/usr/local/lib/lua/5.1/?.so;;'

#
# >>> API Keys >>>
# <<< API Keys <<<
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
#
. "$HOME/.cargo/env"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
