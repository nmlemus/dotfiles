#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
#  Dotfiles Installer - Terminal Visual Setup
#  Catppuccin Mocha + Powerlevel10k Rainbow + Modern CLI
# ═══════════════════════════════════════════════════════════

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

step() { echo -e "\n${BLUE}[*]${NC} $1"; }
ok()   { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[-]${NC} $1"; }

# ─────────────────────────────────────────────────────────
# 1. Homebrew
# ─────────────────────────────────────────────────────────
step "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  warn "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add to PATH for Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  ok "Homebrew installed"
else
  ok "Homebrew found"
fi

# ─────────────────────────────────────────────────────────
# 2. CLI tools
# ─────────────────────────────────────────────────────────
step "Installing modern CLI tools..."
TOOLS=(eza bat zoxide fzf)
for tool in "${TOOLS[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    echo "  Installing $tool..."
    brew install "$tool"
    ok "$tool installed"
  else
    ok "$tool already installed"
  fi
done

# ─────────────────────────────────────────────────────────
# 3. Nerd Font (MesloLGS NF)
# ─────────────────────────────────────────────────────────
step "Checking Nerd Font..."
if ! ls ~/Library/Fonts/MesloLGS* &>/dev/null 2>&1; then
  warn "MesloLGS NF not found. Installing..."
  FONT_DIR="$HOME/Library/Fonts"
  FONT_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
  curl -sL "$FONT_BASE/MesloLGS%20NF%20Regular.ttf"     -o "$FONT_DIR/MesloLGS NF Regular.ttf"
  curl -sL "$FONT_BASE/MesloLGS%20NF%20Bold.ttf"        -o "$FONT_DIR/MesloLGS NF Bold.ttf"
  curl -sL "$FONT_BASE/MesloLGS%20NF%20Italic.ttf"      -o "$FONT_DIR/MesloLGS NF Italic.ttf"
  curl -sL "$FONT_BASE/MesloLGS%20NF%20Bold%20Italic.ttf" -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf"
  ok "MesloLGS NF fonts installed"
else
  ok "MesloLGS NF already installed"
fi

# ─────────────────────────────────────────────────────────
# 4. Oh My Zsh
# ─────────────────────────────────────────────────────────
step "Checking Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  warn "Oh My Zsh not found. Installing..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ok "Oh My Zsh installed"
else
  ok "Oh My Zsh already installed"
fi

# ─────────────────────────────────────────────────────────
# 5. Powerlevel10k theme
# ─────────────────────────────────────────────────────────
step "Checking Powerlevel10k..."
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  warn "Powerlevel10k not found. Installing..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  ok "Powerlevel10k installed"
else
  ok "Powerlevel10k already installed"
fi

# ─────────────────────────────────────────────────────────
# 6. Custom ZSH plugins
# ─────────────────────────────────────────────────────────
step "Installing custom ZSH plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

PLUGINS="
zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting
zsh-history-substring-search https://github.com/zsh-users/zsh-history-substring-search
zsh-completions https://github.com/zsh-users/zsh-completions
fzf-tab https://github.com/Aloxaf/fzf-tab
"

echo "$PLUGINS" | while read -r plugin repo; do
  [[ -z "$plugin" ]] && continue
  if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
    echo "  Installing $plugin..."
    git clone --depth=1 "$repo" "$ZSH_CUSTOM/plugins/$plugin"
    ok "$plugin installed"
  else
    ok "$plugin already installed"
  fi
done

# ─────────────────────────────────────────────────────────
# 7. Apply configs
# ─────────────────────────────────────────────────────────
step "Applying configurations..."

# Backup existing configs
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
[[ -f "$HOME/.p10k.zsh" ]] && cp "$HOME/.p10k.zsh" "$BACKUP_DIR/" && echo "  Backed up .p10k.zsh"
[[ -f "$HOME/.zshrc" ]]    && cp "$HOME/.zshrc" "$BACKUP_DIR/"    && echo "  Backed up .zshrc"
ok "Backups saved to $BACKUP_DIR"

# Copy p10k config (Rainbow + Catppuccin)
cp "$DOTFILES_DIR/configs/p10k.zsh" "$HOME/.p10k.zsh"
ok "p10k.zsh applied (Rainbow + Catppuccin Mocha)"

# ─────────────────────────────────────────────────────────
# 8. Patch .zshrc
# ─────────────────────────────────────────────────────────
step "Configuring .zshrc..."

# Ensure ZSH_THEME is powerlevel10k
if grep -q 'ZSH_THEME=' "$HOME/.zshrc"; then
  sed -i '' 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$HOME/.zshrc"
  ok "ZSH_THEME set to powerlevel10k"
fi

# Ensure plugins are correct
if grep -q '^plugins=(' "$HOME/.zshrc"; then
  # Replace the plugins block
  PLUGIN_LIST="plugins=(\n  git\n  macos\n  z\n  fzf\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n  zsh-history-substring-search\n  zsh-completions\n  fzf-tab\n)"
  # Use perl for multiline replace
  perl -i -0pe "s/plugins=\([^)]*\)/$(/bin/echo "$PLUGIN_LIST")/s" "$HOME/.zshrc"
  ok "Plugins configured"
fi

# Add custom.zsh source if not already present
CUSTOM_SOURCE='[[ -f ~/.dotfiles/configs/custom.zsh ]] && source ~/.dotfiles/configs/custom.zsh'
if ! grep -qF 'dotfiles/configs/custom.zsh' "$HOME/.zshrc"; then
  # Add after oh-my-zsh source
  sed -i '' "/^source \$ZSH\/oh-my-zsh.sh/a\\
\\
# Dotfiles: modern CLI tools, aliases, and Catppuccin colors\\
${CUSTOM_SOURCE}
" "$HOME/.zshrc"
  ok "custom.zsh sourced in .zshrc"
else
  ok "custom.zsh already sourced"
fi

# Ensure p10k is sourced
if ! grep -qF 'p10k.zsh' "$HOME/.zshrc"; then
  echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "$HOME/.zshrc"
  ok "p10k.zsh sourced in .zshrc"
fi

# Ensure instant prompt block at top
if ! grep -qF 'p10k-instant-prompt' "$HOME/.zshrc"; then
  INSTANT_PROMPT='# Enable Powerlevel10k instant prompt.\nif [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then\n  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"\nfi\n'
  TMPFILE=$(mktemp)
  printf "%b\n" "$INSTANT_PROMPT" > "$TMPFILE"
  cat "$HOME/.zshrc" >> "$TMPFILE"
  mv "$TMPFILE" "$HOME/.zshrc"
  ok "Instant prompt added"
fi

# ─────────────────────────────────────────────────────────
# 9. bat theme
# ─────────────────────────────────────────────────────────
step "Installing bat Catppuccin theme..."
BAT_THEMES_DIR="$(bat --config-dir 2>/dev/null || echo "$HOME/.config/bat")/themes"
mkdir -p "$BAT_THEMES_DIR"
cp "$DOTFILES_DIR/themes/Catppuccin Mocha.tmTheme" "$BAT_THEMES_DIR/"
bat cache --build &>/dev/null
ok "Catppuccin Mocha theme for bat installed"

# ─────────────────────────────────────────────────────────
# Done!
# ─────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Terminal setup complete!${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════${NC}"
echo ""
echo "  What was installed:"
echo "    - Oh My Zsh + Powerlevel10k (Rainbow style)"
echo "    - MesloLGS NF (Nerd Font)"
echo "    - eza (ls), bat (cat), zoxide (cd), fzf"
echo "    - Catppuccin Mocha colors everywhere"
echo "    - 5 custom plugins"
echo ""
echo -e "  ${YELLOW}Next steps:${NC}"
echo "    1. Set your terminal font to 'MesloLGS NF'"
echo "       - iTerm2: Preferences > Profiles > Text > Font"
echo "       - Terminal.app: Preferences > Profiles > Font"
echo "       - VS Code: \"terminal.integrated.fontFamily\": \"MesloLGS NF\""
echo "    2. Open a new terminal window"
echo "    3. Enjoy your beautiful shell!"
echo ""
