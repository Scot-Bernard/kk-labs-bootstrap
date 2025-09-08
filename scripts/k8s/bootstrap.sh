#!/usr/bin/env bash
# KodeKloud CentOS 9 Kubernetes lab bootstrap
# - Installs tmux, vim, less (non-interactive, via yum)
# - Ensures tmux uses default-terminal "xterm"
# - Creates a tmux session with windows: work, info, edit
# Assumptions:
#   * Package manager is YUM
#   * Sudo always requires a password
#   * Sudo password is fixed for labs and stored read-only here

set -euo pipefail

# --- Config (read-only) -------------------------------------------------------
declare -r LAB_SUDO_PASS="mjolnir123"
declare -r TMUX_CONF="${HOME}/.tmux.conf"
declare -r TMUX_CONF_LINE='set -g default-terminal "xterm"'
declare -r SESSION="k8s"
declare -r -a PKGS=(tmux vim less)

# --- Helpers ------------------------------------------------------------------
sudo_run() {
  # Always supply password non-interactively; suppress sudo prompt text with -p ''
  printf '%s\n' "$LAB_SUDO_PASS" | sudo -S -p '' "$@"
}

ensure_line_once() {
  local line="$1" file="$2"
  if [[ -f "$file" ]]; then
    grep -Fxq "$line" "$file" || echo "$line" >> "$file"
  else
    printf '%s\n' "$line" > "$file"
  fi
}

# --- Install packages ---------------------------------------------------------
sudo_run yum -y install "${PKGS[@]}"

# --- Configure tmux -----------------------------------------------------------
ensure_line_once "$TMUX_CONF_LINE" "$TMUX_CONF"

# --- Start tmux session -------------------------------------------------------
tmux new-session -d -s "$SESSION" -n work
tmux new-window  -t "$SESSION:" -n info
tmux new-window  -t "$SESSION:" -n edit
tmux select-window -t "$SESSION:work"
tmux attach -t "$SESSION"

