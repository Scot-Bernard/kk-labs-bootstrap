# kk-labs-bootstrap

Bootstrap scripts for **KodeKloud** labs on CentOS Stream 9.
Start with Kubernetes shell conveniences (tmux/vim/less + a ready-to-use tmux session), and grow from here.

## Contents

- `scripts/k8s/bootstrap.sh`: Installs `tmux`, `vim`, and `less` using **YUM**, ensures tmux uses `xterm`, and opens a 3-window session (`work`, `info`, `edit`).

Planned structure for more lab types:

```
kk-labs-bootstrap/
├─ README.md
├─ scripts/
│  ├─ k8s/
│  │  └─ bootstrap.sh
│  ├─ ansible/            # (future)
│  └─ linux-basics/       # (future)
└─ LICENSE                # (MIT recommended)
```

## Quick start (K8s lab)

Run directly (non-interactive):

```bash
curl -fsSL https://raw.githubusercontent.com/Scot-Bernard/kk-labs-bootstrap/main/scripts/k8s/bootstrap.sh | bash
```
This will:

Install tmux, vim, and less via yum -y.

Ensure ~/.tmux.conf contains set -g default-terminal "xterm".

Create/attach a tmux session named work with windows: work, info, edit.

## Assumptions

- **YUM** is available as the package manager.

- **sudo requires a password** in the lab environment.

- The lab’s password is public for training purposes. The script stores it as a read-only variable.

## Security note

Piping a remote script into bash is convenient but only do this from sources you trust.
For transparency, you can download and inspect first:

```bash
curl -fsSLO https://raw.githubusercontent.com/Scot-Bernard/kk-labs-bootstrap/main/scripts/k8s/bootstrap.sh
less bootstrap.sh
bash bootstrap.sh
```