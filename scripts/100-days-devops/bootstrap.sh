#!/usr/bin/env bash
# KodeKloud 100 Days of DevOps bootstrap
# - Optionally installs Ansible
# - Installs tmux, vim, less via DNF
# - Ensures tmux uses default-terminal "xterm"

set -euo pipefail

# --- Config -------------------------------------------------------------------
declare -r TMUX_CONF="${HOME}/.tmux.conf"
declare -r TMUX_CONF_LINE='set -g default-terminal "xterm"'
declare -r -a PKGS=(vim less tmux)

# --- Prompt for Ansible -------------------------------------------------------
read -rp "Install Ansible? [y/N]: " ansible_choice
if [[ "$ansible_choice" =~ ^[Yy]$ ]]; then
  sudo dnf install ansible -y
fi

# --- Install packages ---------------------------------------------------------
sudo dnf install -y "${PKGS[@]}"

# --- Configure tmux -----------------------------------------------------------
ensure_line_once() {
  local line="$1" file="$2"
  if [[ -f "$file" ]]; then
    grep -Fxq "$line" "$file" || echo "$line" >> "$file"
  else
    printf '%s\n' "$line" > "$file"
  fi
}

ensure_line_once "$TMUX_CONF_LINE" "$TMUX_CONF"
