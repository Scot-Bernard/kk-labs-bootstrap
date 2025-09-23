#!/usr/bin/env bash
set -euo pipefail

declare -r EXT_ID="hashicorp.terraform"
declare -r LAB_SUDO_PASS="mjolnir123"

# --- Helpers ------------------------------------------------------------------
sudo_run() {
  # Always supply password non-interactively; suppress sudo prompt text with -p ''
  printf '%s\n' "$LAB_SUDO_PASS" | sudo -S -p '' "$@"
}

# Determine whether VS Code CLI is code or code-server.
if command -v code >/dev/null 2>&1; then
    VSC_CLI=code
elif command -v code-server >/dev/null 2>&1; then
    VSC_CLI=code-server
else
    echo "VS Code CLI not found. Ensure the lab exposes 'code' or 'code-server'."
    exit 1
fi

# Install only if not already present.
if "$VSC_CLI" --list-extensions | grep -qx "$EXT_ID"; then
    echo "$EXT_ID already installed."
else
    "$VSC_CLI" --install-extension "$EXT_ID" --force
    echo "$EXT_ID installed."
fi

# Install less (on ubuntu 22.04)
if ! command -v less >/dev/null 2>&1; then
    echo "Installing less..."
    sudo_run apt-get update
    sudo_run apt-get install -y less
else
    echo "less is already installed."
fi
