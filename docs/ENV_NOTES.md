# Environment notes (2026)

Lessons collected from a study of a mature zsh + tmux + vim/Neovim environment on two air-gapped Linux servers. Host names, paths and company details are left out on purpose; what remains is generic and was folded into `gx10/` where it fits.

## What was applied to `gx10/`

| Idea | Where | Notes |
|---|---|---|
| PATH is repaired once, at the very end of `.zshrc` | `gx10/.zshrc` (last block) | installers (nvm, conda, bun, deno, env scripts) keep prepending to PATH; `typeset -U path PATH` removes duplicates and the order set before it wins |
| Non-interactive shells get the tools they need through `.zshenv` | `gx10/.zshenv` | `ssh host cmd`, cron and scripts never read `.zshrc`; keep each directory minimal so nothing is shadowed by accident |
| History: shared, timestamped, de-duplicated | `gx10/.zshrc` | `HIST_IGNORE_ALL_DUPS`, `HIST_VERIFY`, Alt-p / Alt-n prefix search; a leading space keeps a command out of history |
| fzf integration, guarded | `gx10/.zshrc` | Ctrl-T files with `bat` preview, Ctrl-R history, Alt-C directories with `eza` tree preview; uses `fzf --zsh` (fzf 0.48 or newer); each piece is skipped when its tool is missing |
| zoxide hooked in, not just installed | `gx10/.zshrc` | a tool on PATH does nothing until it is initialised in the shell |
| `ls` is not replaced, `ll` is | `gx10/.zshrc` | scripts parse `ls` output; the everyday `ll` has no `--git`, because the git column is very slow in large repositories (use `llg` on demand) |
| tmux-continuum must run after the status line is final | `gx10/.tmux.conf` | continuum saves via a hook it injects into `status-right`; a theme or later `set status-right` wipes the hook and auto-save silently stops. The file already did this for tmux-cpu; continuum now gets the same treatment |
| tmux: longer scrollback, reload key, true colour, readable window names, nvim sessions | `gx10/.tmux.conf` | `history-limit 50000`, `prefix r`, `Tc` override, directory name for shells and program name otherwise |
| git: `diff3` conflict style, optional delta pager, host-specific include | `gx10/.gitconfig` | `zdiff3` needs git 2.35 or newer and breaks merge/rebase on older versions, so `diff3` is used; `~/.gitconfig.local` is included last so a host can override anything |

## Ideas not applied (kept as notes)

- **Share configuration through a repository `[include]`.** Keep the real git settings in a versioned file and let each host's `~/.gitconfig` hold only the include plus host-specific overrides. This stops the same dotfile from drifting between machines (a study of two servers found four rc files that had already diverged).
- **Offline or air-gapped machines.** Turn off everything that tries to reach the network: oh-my-zsh auto-update (`DISABLE_AUTO_UPDATE`), TPM plugin installs (unpack plugins by hand), Neovim `mason.nvim` and `nvim-treesitter` downloads (empty `ensure_installed`), lazy.nvim update checks. Point LSP at binaries you copied in instead of letting a manager fetch them.
- **Never lose tmux scrollback.** Scrollback lives only in memory, so an OOM kill or `kill -9` of the tmux server loses every pane's history. Two layers worked well: a periodic (about every 5 minutes) `capture-pane` snapshot of each pane, compressed and rotated with a per-pane size cap, plus a per-pane toggle that logs raw output with `pipe-pane`.
- **Fonts live where the terminal runs.** Prompt icons (powerlevel10k), tmux theme separators and `eza --icons` are drawn by the terminal program, so a Nerd Font must be installed on the machine whose terminal you look at, not on the server. A server-side font directory only affects X11 programs started on the server.
- **Vim leader pitfall.** `let g:leader = ","` does nothing; Vim only reads `mapleader` (`let mapleader = ","`, set before the mappings that use `<leader>`). Without it, `<leader>` is a backslash.
- **Check that a tool is actually used.** A study found a private zsh 5.9 on PATH while every running shell was still the system 5.5, and zoxide installed but never initialised. Verify the version a running process really uses.
- **Keep a snapshot or backup habit** for the home directory (file-system snapshots saved deleted files for other users of the same setup).
- **Security reminder.** `credential.helper = store` keeps credentials in plain text in `~/.git-credentials`; prefer `gh auth git-credential` or a keyring helper. This repository's gitconfig keeps both entries because the machine already used `store` before; review before copying.

## Tools worth installing (all optional, all guarded in the config)

`fzf`, `fd`, `ripgrep`, `bat`, `eza`, `delta`, `lazygit`, `jq`, `yq`, `zoxide`, `uv`, `ruff`, universal-ctags. On Debian/Ubuntu `fd` is `fdfind` and `bat` is `batcat`; the zsh block handles `fdfind`, and you can alias `bat=batcat`.
