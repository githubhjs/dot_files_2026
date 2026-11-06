# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY      # Save timestamps to history file
setopt SHARE_HISTORY         # Share history across all active sessions
setopt APPEND_HISTORY        # Append to history file, do not overwrite
setopt INC_APPEND_HISTORY    # Write command to history file immediately after execution
setopt HIST_IGNORE_DUPS      # Ignore immediately preceding duplicate commands
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8  # aliases to en_US.utf8, confirmed via locale -a

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/bin:$PATH"

alias gam="/home/hjs/bin/gam7/gam"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/hjs/google-cloud-sdk/path.zsh.inc' ]; then . '/home/hjs/google-cloud-sdk/path.zsh.inc'; fi
. "/home/hjs/.acme.sh/acme.sh.env"

. "$HOME/.local/bin/env"

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# Composio CLI
export COMPOSIO_INSTALL_DIR="/home/hjs/.composio"
export PATH="$COMPOSIO_INSTALL_DIR:$PATH"

# AWS Bedrock Configuration for Claude Code
export AWS_PROFILE=josh_huang
export AWS_REGION=ap-southeast-2
export AWS_DEFAULT_REGION=ap-southeast-2
export CLAUDE_CODE_USE_BEDROCK=0

# deno (installed for yt-dlp JS runtime support)
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/home/hjs/.bun/_bun" ] && source "/home/hjs/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ---------------------------------------------------------------------------
# Added 2026 (ideas from a dev-environment study, see docs/ENV_NOTES.md).
# Keep this block LAST: installers above keep prepending to PATH, so PATH is
# deduplicated here, and every tool below is guarded so a missing one is skipped.
# ---------------------------------------------------------------------------

# History: shared, timestamped, de-duplicated; a leading space keeps a command out
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS HIST_VERIFY
bindkey '\ep' history-beginning-search-backward   # Alt-p: search back by typed prefix
bindkey '\en' history-beginning-search-forward    # Alt-n: search forward by typed prefix

# Aliases (guarded). Plain `ls` stays untouched because scripts parse its output.
alias v='vim -p'        # one tab per file
alias n='nvim'
alias datime="date +'%F_%Hh%M'"                    # timestamp for file names
alias newtmux='tmux new-session -s "$(hostname -s)-$(date +%H%M)"'
if (( $+commands[eza] )); then
  # No --git in the everyday alias: it makes ls very slow in big repositories.
  alias ll='eza -lh --group-directories-first --icons'
  alias la='eza -lah --group-directories-first --icons'
  alias lt='eza --tree --level=2 --icons'
  alias llg='eza -lh --git'                        # only when the git column is wanted
fi

# fzf: Ctrl-T files (bat preview), Ctrl-R history, Alt-C directories (tree preview).
# fzf >= 0.48 ships its own zsh integration, so no separate key-bindings file is needed.
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
  local _fd=${commands[fd]:-${commands[fdfind]}}
  [[ -n $_fd ]] && export FZF_DEFAULT_COMMAND="$_fd --type f --hidden --follow --exclude .git"
  export FZF_DEFAULT_OPTS='--cycle --height=60% --layout=reverse --border --info=inline'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  (( $+commands[bat] )) && export FZF_CTRL_T_OPTS="--preview 'bat -p --color=always --line-range :200 {}' --preview-window=right,60%,border-left"
  [[ -n $_fd ]] && export FZF_ALT_C_COMMAND="$_fd --type d --hidden --follow --exclude .git"
  (( $+commands[eza] )) && export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down,3,wrap --bind 'ctrl-/:toggle-preview'"
fi

# zoxide: smarter cd (installed tools are only useful once they are hooked in)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Remove duplicate PATH entries, keeping the first occurrence (the order set above wins)
typeset -U path PATH
