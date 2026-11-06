# dot_files_2026

Personal dotfiles, 2026 edition. This repository starts from [`dot.hjs`](https://github.com/githubhjs/dot.hjs) (full history kept; a repository cannot be forked into the same account, so it was copied and pushed as a new one). The current GX10 files in `gx10/` were overwritten with the live ones from the machine, and a set of ideas from a dev-environment study was folded in; see [`docs/ENV_NOTES.md`](docs/ENV_NOTES.md). Files outside `gx10/` are the historical ones from the original repository and are untouched.

What changed against `dot.hjs`:

- `gx10/.zshrc`, `.bashrc`, `.gitconfig`, `.tmux.conf`, `.vimrc` replaced by the live versions; `.zshenv`, `.profile` and `.aider.conf.yml` refreshed.
- New: `gx10/.p10k.zsh` and `gx10/.config/nvim/` (LazyVim starter, `LICENSE` omitted).
- New: [`examples/work-servers/`](examples/work-servers/): a sanitized set of worked examples (zsh, tmux, Vim, offline Neovim, git, p10k diff) from a pair of air-gapped work servers; company-specific details are removed, see its README.
- Notes were extended with a "Version 2" section (corrections and extra measured findings) in `docs/ENV_NOTES.md`; the fzf block now probes `fzf --zsh` before sourcing it, and zoxide is optional.
- Added on top: guarded zsh history/aliases/fzf/zoxide block with PATH de-duplication, tmux-continuum re-run after the status line, longer tmux scrollback and true colour, git `diff3` plus an include for host-specific settings, `.zshenv` PATH for non-interactive shells.

Originally: personal dotfiles — primarily from **GX10** (ASUS GB10 Superchip, `192.168.2.93`, Ubuntu).

---

## Active machine: GX10 (`gx10/`)

Machine-specific files live under `gx10/` to avoid clobbering historical configs at root.

| File | Purpose |
|------|---------|
| `gx10/.bashrc` | Bash config |
| `gx10/.zshrc` / `.zshenv` / `.zshrc.backup` | Zsh (oh-my-zsh, NVM, PATH, aliases) |
| `gx10/.profile` | Login shell env |
| `gx10/.gitconfig` | Git aliases, signing key, core settings |
| `gx10/.tmux.conf` | Tmux — TPM + catppuccin theme |
| `gx10/.aider.conf.yml` | Aider AI: dark nord theme, qwen3 model, no auto-commit |
| `.claude/settings.json` | Claude Code: fullscreen TUI, dark theme, sonnet-4-6 |
| `.gemini/settings.json` | Gemini CLI: OAuth personal auth |
| `.gemini/projects.json` | Gemini project directory mappings |
| `.gemini/trustedFolders.json` | Gemini trusted directory settings |
| `.gemini/skills/` | 6 Gemini CLI skills (see below) |

### Gemini Skills

| Skill | Description |
|-------|-------------|
| `acg-factory-gumroad` | ACG content factory + Gumroad integration |
| `aider-tmux-babysitter` | Monitor and manage aider sessions in tmux |
| `book-factory-manager` | Book generation pipeline manager |
| `gx10-orchestrator` | GX10 workstation orchestration |
| `local-image-gen` | Local image generation workflows |
| `workstation-expert` | GX10 system knowledge and ops |

---

## Vim config (.vimrc)

Live config on GX10 is `gx10/.vimrc`; the root `.vimrc` is the older reference copy.

Plugin manager: [vim-plug](https://github.com/junegunn/vim-plug)

| Plugin | Purpose |
|--------|---------|
| `vim-airline` + themes | Status/tabline |
| `nerdtree` | File explorer (`Ctrl+N`) |
| `vim-devicons` | Icons (requires Nerd Font in terminal) |
| `gruvbox` | Colorscheme |

To activate on a new machine:

```bash
# Install vim-plug (already in .vim/autoload/plug.vim in this repo)
# Then in vim:
:PlugInstall

# Recommended terminal font: JetBrainsMono Nerd Font
```

Settings: relative line numbers, 4-space tabs, `termguicolors`, mouse enabled, gruvbox dark.

---

## Legacy / archive

Older files left intact for history:

| File / Dir | Origin |
|------------|--------|
| `.alias` / `.cshrc` / `.conformal_lec` | Old EDA workstation (csh era) |
| `.screenrc` / `.screenrc.nocap` | Pre-tmux screen config |
| `.zsh_functions` | Old zsh function snippets |
| `keepRemoteAlive.sh` | Old SSH keepalive script |
| `.config/git/gitk` | gitk color config |
| `ie9hackathon/` | IE9 hackathon demos (2011) |
| `Application Data/Rovio/` | Angry Birds save from Windows era |
| `choco.install.list.bat` | Old Windows Chocolatey package list |
| `.temp/` | Old temp/scratch |

---

## Excluded (in .gitignore)

Secrets and runtime state are never committed:
- Credentials: `.git-credentials`, `.youtube-creds.json`, `.ssh/`, `.acme.sh/`, `.oci/`, `.cloudflared/`
- Claude runtime: sessions, projects, history, daemon logs, cache
- Gemini runtime: `oauth_creds.json`, `google_accounts.json`, history, tmp
- Shell history, completions, vim undo files

---

## Syncing from GX10

```bash
cd /path/to/dot_files_2026
rsync -a /home/hjs/.claude/settings.json   .claude/
rsync -a /home/hjs/.gemini/skills/         .gemini/skills/
rsync -a /home/hjs/.gemini/settings.json   .gemini/
cp /home/hjs/.zshrc /home/hjs/.bashrc /home/hjs/.vimrc /home/hjs/.tmux.conf /home/hjs/.gitconfig /home/hjs/.aider.conf.yml gx10/
git add -A && git commit -m "sync gx10 $(date +%Y-%m-%d)" && git push origin main
```
