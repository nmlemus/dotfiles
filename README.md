# Dotfiles - Terminal Visual Setup

Automated setup for a beautiful macOS terminal with **Catppuccin Mocha** colors.

## What's included

| Component | Description |
|---|---|
| **Powerlevel10k** | Rainbow style, 2-line prompt, Nerd Font icons |
| **eza** | Modern `ls` with icons, colors, and Git status |
| **bat** | Modern `cat` with syntax highlighting |
| **zoxide** | Smart `cd` that learns your habits |
| **fzf** | Fuzzy finder with Catppuccin colors |
| **MesloLGS NF** | Nerd Font with powerline glyphs |

## Plugins

- `zsh-autosuggestions` - Fish-like suggestions
- `zsh-syntax-highlighting` - Catppuccin-colored syntax
- `zsh-history-substring-search` - Better history search
- `zsh-completions` - Extra completions
- `fzf-tab` - fzf-powered tab completion

## Quick install

```bash
git clone https://github.com/YOUR_USER/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Then set your terminal font to **MesloLGS NF**:
- **iTerm2**: Preferences > Profiles > Text > Font
- **Terminal.app**: Preferences > Profiles > Font
- **VS Code**: `"terminal.integrated.fontFamily": "MesloLGS NF"`
- **Ghostty**: `font-family = "MesloLGS NF"` in config

## Files

```
~/.dotfiles/
├── install.sh              # Main installer (idempotent)
├── README.md
├── configs/
│   ├── p10k.zsh            # Powerlevel10k config (Rainbow + Catppuccin)
│   ├── custom.zsh          # Aliases, tools config, colors
│   └── plugins.txt         # Plugin list reference
└── themes/
    └── Catppuccin Mocha.tmTheme   # bat syntax theme
```

## Aliases

| Alias | Expands to |
|---|---|
| `ls` | `eza --icons --group-directories-first` |
| `ll` | `eza -la --icons --git` |
| `lt` | `eza --tree --icons --level=2` |
| `la` | `eza -la --icons --git --time-style=relative` |
| `cat` | `bat --paging=never` |
| `cd` | `zoxide` (smart cd) |
| `reload` | `source ~/.zshrc` |

## Updating

Pull changes and re-run:

```bash
cd ~/.dotfiles
git pull
./install.sh
```

The script is idempotent - safe to run multiple times. It backs up existing configs before overwriting.
