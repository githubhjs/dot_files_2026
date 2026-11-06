# Environment notes (2026)

Lessons collected from a study of a mature zsh + tmux + vim/Neovim environment on two air-gapped Linux servers. Host names, paths and company details are left out on purpose; what remains is generic and was folded into `gx10/` where it fits.

## What was applied to `gx10/`

| Idea | Where | Notes |
|---|---|---|
| PATH is repaired once, at the very end of `.zshrc` | `gx10/.zshrc` (last block) | installers (nvm, conda, bun, deno, env scripts) keep prepending to PATH; `typeset -U path PATH` removes duplicates and the order set before it wins |
| Non-interactive shells get the tools they need through `.zshenv` | `gx10/.zshenv` | `ssh host cmd`, cron and scripts never read `.zshrc`; keep each directory minimal so nothing is shadowed by accident |
| History: shared, timestamped, de-duplicated | `gx10/.zshrc` | `HIST_IGNORE_ALL_DUPS`, `HIST_VERIFY`, Alt-p / Alt-n prefix search; a leading space keeps a command out of history |
| fzf integration, guarded | `gx10/.zshrc` | Ctrl-T files with `bat` preview, Ctrl-R history, Alt-C directories with `eza` tree preview; uses `fzf --zsh` (fzf 0.48 or newer); each piece is skipped when its tool is missing |
| zoxide: optional, hooked in only when installed | `gx10/.zshrc` | not using it is a valid choice (the oh-my-zsh `z` plugin has its own database; running both splits your history). See the corrections below |
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
- **Check which binary a running process really uses.** A study found a private zsh 5.9 on PATH while every running shell was still the system 5.5: the login shell comes from the account's passwd entry and tmux's `default-shell`, and PATH only affects programs started by name. See "Version 2" below for how to measure it.
- **Keep a snapshot or backup habit** for the home directory (file-system snapshots saved deleted files for other users of the same setup).
- **Security reminder.** `credential.helper = store` keeps credentials in plain text in `~/.git-credentials`; prefer `gh auth git-credential` or a keyring helper. This repository's gitconfig keeps both entries because the machine already used `store` before; review before copying.

## Tools worth installing (all optional, all guarded in the config)

`fzf`, `fd`, `ripgrep`, `bat`, `eza`, `delta`, `lazygit`, `jq`, `yq`, `zoxide`, `uv`, `ruff`, universal-ctags. On Debian/Ubuntu `fd` is `fdfind` and `bat` is `batcat`; the zsh block handles `fdfind`, and you can alias `bat=batcat`.

## Version 2 (2026-11-06): corrections and extra findings

A second pass over the same study corrected the first one. Only the generic lessons are recorded here; the study itself was about private servers and its host names, paths and internal repository layout are deliberately left out of this public repository.

**Corrections to the first version**

1. "zoxide is installed but not hooked in" was wrongly listed as a problem. It was deliberate: the oh-my-zsh `z` plugin already held hundreds of trained directories, so switching would throw them away. The `gx10/.zshrc` block therefore only hooks zoxide when it is installed, and says that skipping it is fine.
2. A list of "files others can read for reference" was withdrawn. Do not assume colleagues can read your home directory (it may be `drwxrwx---`, and nobody should build on another user's home). Put what others need into a repository, or into a shared directory with explicit permissions.
3. The first version missed that the team repository already had eleven chapters on the same topics. Lesson: read the existing docs before writing new ones, extend them, cite them, and update records that went stale (an earlier note about two diverging `.gitconfig` files had already been fixed by an `[include]`).
4. The "6 problems" became 5 numbered findings (F1-F5).

**F1. Check which shell binary actually runs.** Measure instead of assuming:

```
# what every running zsh process really is
for p in $(pgrep -u "$USER" zsh); do readlink /proc/$p/exe; done | sort | uniq -c
getent passwd "$USER" | cut -d: -f7        # the login shell
tmux show -gv default-shell                # what tmux panes start
```

In the study every interactive shell was the system zsh 5.5.1 even though a private 5.9 was on PATH. Making tmux start another zsh needs `default-shell` set per host; that was not tested.

**F2. Vim leader.** `let g:leader = ","` is a no-op; use `let mapleader = ","` before the mappings. Reproduce with a batch run:

```
vim -N -es -u ~/.vimrc -c 'redir! > /tmp/v.txt' \
  -c 'silent echo (exists("mapleader") ? "mapleader=".mapleader : "mapleader=<unset>")' \
  -c 'silent nmap \fl' -c 'silent nmap ,fl' -c 'redir END' -c 'qa!'; cat /tmp/v.txt
```

Run against a vimrc that sets `g:leader` and maps `<leader>fl`, it printed `mapleader=<unset>`, showed the mapping on `\fl`, and `No mapping found` for `,fl`. Vim documents this in `:help mapleader`: `<Leader>` is replaced by the value of `mapleader`, and by a backslash if it is unset.

**F3. Guard auto-templates.** An `autocmd BufNewFile ... 0r ~/tmpl/tmpl` fails with `E484` when the template file does not exist on a host (the shared home had it, the other server did not). Guard it with `filereadable()` or ship the template with the dotfiles.

**F4. Old scratch directories pile up.** One home had thousands of leftover tool scratch directories (about 18,000 entries, almost all removable by name). They slow `ls -A` and shell completion; clean such directories on a schedule, but check before deleting.

**F5. Drift between hosts.** Compare hand-maintained files across hosts with `md5sum` and `diff`; move the shared part into a repository and keep per-host files thin (an `[include]` for git, a `source` line for shells).

**More measured details worth copying**

- `fzf --zsh` needs fzf 0.48 or newer; an older fzf (0.44 in the study) prints `unknown option: --zsh`. `gx10/.zshrc` now probes with `fzf --zsh >/dev/null 2>&1` before sourcing it.
- A tmux client must match the server's version: a 2.7 client cannot talk to a 3.x server. That is why the newer tmux directory must be on PATH in `.zshenv`, which tmux plugins and cron also read.
- `.zshenv` must print nothing, otherwise `ssh host cmd` output is polluted. Check with `ssh host 'zsh -c "" 2>&1 | wc -c'`: it must print 0.
- The `.zshrc` order that works: instant prompt, history options and the framework, then environment/module scripts, then conda and nvm, and at the very end the PATH fix, the prompt theme and the fzf integration.
- A prompt-theme config (`~/.p10k.zsh`) is easiest to keep as a short diff against the theme's own preset instead of its full 1800 lines.
- Static or musl builds of the small CLI tools (fzf, fd, ripgrep, bat, eza, delta, lazygit, jq, yq, uv, ruff) run on old glibc hosts, so one download per tool serves every host.
- Startup time was measured without a terminal (`zsh -i -c exit`, 1.0 to 1.3 s on the two servers) and is only good for comparing hosts, not for the time to a usable prompt.

**Not verified in the study:** other hosts of the shared home, whether tmux `default-shell` pointing at a newer zsh works, the contents of the differing `.ssh/config` and `htoprc`, and the time to a usable prompt in a real terminal.
