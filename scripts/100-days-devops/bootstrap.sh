#!/usr/bin/env bash
# KodeKloud 100 Days of DevOps bootstrap
# - Optionally installs Ansible
# - Installs tmux, vim, less via DNF
# - Ensures tmux uses default-terminal "xterm"

set -euo pipefail

# --- Config -------------------------------------------------------------------
declare -r LAB_SUDO_PASS="mjolnir123"
declare -r TMUX_CONF="${HOME}/.tmux.conf"
declare -r TMUX_CONF_LINE='set -g default-terminal "xterm"'
declare -r -a PKGS=(vim less tmux git)

# --- Helpers ------------------------------------------------------------------
sudo_run() {
  # Always supply password non-interactively; suppress sudo prompt text with -p ''
  printf '%s\n' "$LAB_SUDO_PASS" | sudo -S -p '' "$@"
}

# --- Prompt for Ansible -------------------------------------------------------
read -rp "Install Ansible? [y/N]: " ansible_choice
ansible_choice="${ansible_choice:-N}"
if [[ "$ansible_choice" =~ ^[Yy]$ ]]; then
  sudo dnf install ansible -y
fi

# --- Install packages ---------------------------------------------------------
sudo_run dnf install -y "${PKGS[@]}"

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

# --- Configure git -----------------------------------------------------------
read -rp "Enter your Git user name: " git_user_name
read -rp "Enter your Git user email: " git_user_email
git config --global user.name "$git_user_name"
git config --global user.email "$git_user_email"

