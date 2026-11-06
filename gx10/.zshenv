. "$HOME/.cargo/env"

# Read by EVERY zsh, including `ssh host cmd`, cron and scripts, which never read .zshrc.
# Put here only what non-interactive shells also need (tools that other tools call by name),
# for example tmux plugins calling `tmux`, or an editor started over ssh.
# Keep each directory minimal (one tool per directory) so nothing else is shadowed by accident.
typeset -U path PATH
[[ -d $HOME/.local/bin ]] && path=($HOME/.local/bin $path)
[[ -d $HOME/bin ]] && path=($HOME/bin $path)
