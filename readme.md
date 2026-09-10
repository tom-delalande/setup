
# Instructions

## macOS window workflow

The AeroSpace configuration is stored in `config/aerospace/aerospace.toml`.
`Option` below corresponds to `alt` in the configuration. Workspaces use the
accordion layout by default, with a small part of adjacent windows kept visible.

### Workspaces

| Workspace | Purpose |
| --------- | ------- |
| 1 | LLM harness (ChatGPT/Codex, Claude, and OpenCode) |
| 2 | Browsers (Firefox and Google Chrome) |
| 3 | Communications and lightweight productivity (Slack, Spotify, TickTick) |
| 4 | Workbench (Finder, IntelliJ IDEA, Affinity, Obsidian, Bitwarden, SourceTree, TablePro, Bruno, Sublime Text) |
| 5 | Terminals, development processes, and monitoring (WezTerm, Neovim, DBUI, tmux `processes`, btop, Lazydocker) |
| 6 | Steam |
| 7–8 | Spare/manual workspaces |
| 9 | Default destination for any app without an explicit routing rule |

Apps are routed when AeroSpace detects a new window, including apps opened from
Spotlight or the Dock. Every WezTerm window is routed to workspace 5, including
windows opened outside an AeroSpace binding. System notification windows are
exempt.

### AeroSpace application shortcuts

| Binding | Action |
| ------- | ------ |
| `Option-Q` | Open a new WezTerm window in workspace 5 |
| `Option-F` | Open `~/Documents` in Finder on workspace 4 |
| `Option-B` | Open Firefox on workspace 2 |
| `Option-I` | Open Spotify on workspace 3 |
| `Option-N` | Open Neovim in WezTerm on workspace 5 |
| `Option-T` | Open btop in WezTerm on workspace 5 |
| `Option-D` | Open Lazydocker in WezTerm on workspace 5 |
| `Option-S` | Open `nvim +DBUI` in WezTerm on workspace 5 |
| `Option-G` | Open SourceTree on workspace 4 |
| `Option-O` | Open Obsidian on workspace 4 |
| `Option-P` | Open TickTick on workspace 3 |
| `Option-Z` | Open Bitwarden on workspace 4 |
| `Option-A` | Open ChatGPT in Firefox on workspace 2 |
| `Option-C` | Open Google Calendar in Firefox on workspace 2 |
| `Option-E` | Open Gmail in Firefox on workspace 2 |
| `Option-M` | Open Google Messages in Firefox on workspace 2 |
| `Option-Control-B` | Open Google Chrome on workspace 2 |
| `Option-Control-A` | Open ChatGPT in Chrome on workspace 2 |
| `Option-Control-C` | Open Google Calendar in Chrome on workspace 2 |
| `Option-Control-E` | Open `main.google.com` in Chrome on workspace 2 |
| `Option-Control-D` | Open Google Meet in Chrome on workspace 2 |
| `Option-Control-M` | Open Slack on workspace 3 |
| `Option-Control-N` | Open IntelliJ IDEA on workspace 4 |
| `Option-Control-T` | Open or attach to the tmux session `processes` on workspace 5 |

The macOS Shortcuts **Open Workbench Terminal**, **Open SourceTree**, and
**Open Processes Terminal** invoke `Option-Q`, `Option-G`, and
`Option-Control-T` respectively and are searchable from Spotlight.

### AeroSpace window and layout shortcuts

| Binding | Action |
| ------- | ------ |
| `Option-W` | Close the focused window |
| `Option-Shift-Return` | Toggle AeroSpace fullscreen without outer gaps |
| `Option-V` | Toggle the focused window between floating and tiling |
| `Option-.` | Cycle tile layouts and orientation |
| `Option-,` | Cycle accordion layouts and orientation |
| `Option-Backtick` | Focus the next window in the workspace |
| `Option-Shift-Backtick` | Focus the previous window in the workspace |
| `Option-H/J/K/L` | Focus left/down/up/right |
| `Option-Shift-H/J/K/L` | Move the focused window left/down/up/right |
| `Option-Shift-Arrow keys` | Move the focused window left/down/up/right |
| `Option-Shift--` | Reduce the focused window size |
| `Option-Shift-=` | Increase the focused window size |

### AeroSpace workspace shortcuts

| Binding | Action |
| ------- | ------ |
| `Option-1` … `Option-9` | Switch to workspace 1 … 9 |
| `Option-Shift-1` … `Option-Shift-9` | Move the focused window to workspace 1 … 9 and follow it |
| `Option-Tab` | Switch back to the previously focused workspace |
| `Option-Shift-Tab` | Move the current workspace to the next monitor |
| `Option-Shift-;` | Enter service mode |

### AeroSpace service mode

Press `Option-Shift-;`, then use one of these bindings. Most actions return to
the normal mode automatically.

| Binding | Action |
| ------- | ------ |
| `Escape` | Reload the AeroSpace configuration |
| `R` | Flatten/reset the current workspace tree |
| `F` | Toggle the focused window between floating and tiling |
| `Backspace` | Close every window on the workspace except the focused one |
| `Option-Shift-H/J/K/L` | Join the focused window with its neighbour |
| `Option-Shift-Arrow keys` | Join the focused window with its neighbour |
| `Down` / `Up` | Lower / raise system volume |
| `Shift-Down` | Mute system volume and return to normal mode |

### WezTerm

WezTerm starts in `~/dev`, displays its tab bar even with one tab, and provides
the standard `Command-T` binding for a new tab. `Command-W` closes the current
tab without confirmation.

### Bitwarden SSH agent

The shared OpenSSH configuration is stored in `config/ssh/config`. It directs
SSH clients, including SourceTree when it uses OpenSSH, to the Bitwarden desktop
app's SSH agent at `~/.bitwarden-ssh-agent.sock`.

Enable **SSH agent** in Bitwarden's settings and select **System Git** in
SourceTree under **Settings → Git**. Repositories must use SSH remote URLs, such
as `git@github.com:owner/repository.git`, rather than HTTPS URLs.

The Bash installer links the configuration to `~/.ssh/config`; the Ansible
`ssh` task installs the same file. Private keys are not copied from this
repository because Bitwarden manages them. Verify the agent with:

```sh
SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock" ssh-add -L
ssh -T git@github.com
```

## Ansible

1. Upgrade pip
```sh
sudo pip3 install --upgrade pip
export PATH="$HOME/Library/Python/3.8/bin:"$PATH
```

2. Install Ansible
```sh
pip3 install ansible
```

3. Run Ansible
```sh
cd install/ansible
ansible-galaxy install -r requirements.yml
ansible-playbook main.yml --ask-become-pass --ask-vault-pass

// Or work
ansible-playbook main.yml --ask-become-pass --ask-vault-pass -l work

// Or specific tags
ansible-playbook main.yml --ask-become-pass --ask-vault-pass --tags brew nvim ssh dotfiles osx
```

I don't think I should need to run this but I'm leaving it here incase
```
sudo chown -R "$USER":admin /usr/local
```

## Nix

### OS
1. New Partition Table: GPT

| Name     | Size    | File System    | Mount Point | Flags     |
| -------- | ------- | -------------- | ----------- | --------- |
| Boot     | 100MB   | FAT32          | /boot       | boot      |
| Grub     | 8MB     | unformatted    | *None*      | bios-grub |
| Swap     | 8GB     | linuxswap      | *None*      | swap    |
| Root     | *       | ext4           | /           | root

2. Install Boot Loader on /boot

My Nix configuration is based off https://github.com/Misterio77/nix-starter-configs and takes inspiration from https://github.com/vasujain275/rudra.

```sh
nix-shell -p git neovim
git clone https://github.com/tom-delalande/setup.git ~/setup
cd ~/setup/install/nix
nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#nixos
```
