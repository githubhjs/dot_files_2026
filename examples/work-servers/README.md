# examples/work-servers

A sanitized copy of the hand-maintained configuration of a pair of air-gapped Linux work servers (zsh + oh-my-zsh + powerlevel10k, tmux 3.x, Vim 8.2, Neovim + LazyVim offline, git). Read them as worked examples and adapt the paths; do not source them as they are. The reasoning behind each choice is in [`../../docs/ENV_NOTES.md`](../../docs/ENV_NOTES.md).

## What is here

| File | What it shows |
|---|---|
| `.zshenv.example` | what non-interactive shells need on PATH (per-OS zsh, a newer tmux, nvim); must print nothing |
| `.zshrc.example` | plugin list, history options, and the end-of-file blocks that must stay last (PATH fix-ups, theme, tool precedence, guarded fzf) |
| `.alias.example` | generic aliases and the eza decisions (no `--git` on the everyday `ll`, `ls` left alone) |
| `.zsh_functions` | `dedup_env_var` and `tar_pigz_compress` (complete, unchanged) |
| `.vimrc.example` | condensed vimrc with two marked fixes: `let mapleader` and a `filereadable()` guard on the new-file template |
| `.tmux.conf.example` | mouse, offline TPM, resurrect + continuum, catppuccin, and the "re-run continuum after the status line" guard |
| `.gitconfig.example` | the thin per-host file with a shared `[include]` and host overrides last |
| `tmpl.example` | the Verilog/SystemVerilog header template that the vimrc inserts |
| `fonts.conf` | extra font directories for fontconfig |
| `nvim/lua/...` | offline LazyVim pieces: `offline.lua`, `lsp-offline.lua`, `options.lua`, `lazy.lua` |
| `p10k-changes.diff` | `~/.p10k.zsh` as a 63-line diff against the powerlevel10k `p10k-rainbow` preset (the wizard answers are in its header) |

## What was deliberately left out or changed

This repository is public, so everything that identifies a private environment was removed or replaced by neutral placeholders: host names, network mounts and addresses, internal repository and project paths, vendor tool and licence setup, job-scheduler and EDA command lines, technology-library paths, and the internal history of incidents. Shared tool locations became `/opt/shared/...` placeholders. Dead commented-out blocks were dropped from the vimrc, and the raw ESC bytes in it are written as `\<Esc>` so the file survives copy and paste.

Not published: the periodic tmux scrollback snapshot script and the per-pane logger (the `.tmux.conf.example` lines that call them are commented out), the unmodified LazyVim starter files (`init.lua`, `keymaps.lua`, `autocmds.lua`), the old `~/.fzf.zsh` (superseded by the fzf block in `.zshrc.example`), and a diff between the two servers' copies of the same files.
