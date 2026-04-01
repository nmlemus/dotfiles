# ─────────────────────────────────────────────────────────
# Modern CLI tools & aliases
# ─────────────────────────────────────────────────────────

# eza - modern ls with icons and git status
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --group-directories-first --git'
  alias lt='eza --tree --icons --level=2 --group-directories-first'
  alias la='eza -la --icons --group-directories-first --git --time-style=relative'
  alias llt='eza -la --icons --tree --level=2 --group-directories-first --git'
fi

# bat - modern cat with syntax highlighting
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catp='bat --plain'
  export BAT_THEME="Catppuccin Mocha"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# zoxide - smart cd
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# fzf theming (Catppuccin Mocha)
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --border='rounded' --border-label='' --preview-window='border-rounded' \
  --prompt='> ' --marker='>' --pointer='>' --separator='─' \
  --scrollbar='│' --info='right'"

# Syntax highlighting colors (Catppuccin-inspired)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[path]='fg=#f9e2af,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f5e0dc'

# Autosuggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

# Useful aliases
alias reload='source ~/.zshrc && echo "ZSH config reloaded!"'
alias zshconfig='${EDITOR:-code} ~/.zshrc'
alias p10kconfig='${EDITOR:-code} ~/.p10k.zsh'
