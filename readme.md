# macOS setup

This repository configures a new home or work Mac while keeping the shared
Zsh, editor, terminal, Git, and AeroSpace configuration identical.

Run one of these commands on a new Mac:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tom-delalande/setup/main/bootstrap.sh)" -- home --include-opinionated
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tom-delalande/setup/main/bootstrap.sh)" -- work --include-opinionated
```

The bootstrap installs Apple's Command Line Tools and Homebrew when necessary,
clones this repository to `~/setup`, and runs the selected profile. If macOS
starts the interactive Command Line Tools installer, the command waits and
continues automatically after installation finishes.

To update an existing machine or preview changes:

```sh
~/setup/bin/setup home
~/setup/bin/setup work --dry-run
~/setup/bin/setup work --only packages,dotfiles
~/setup/bin/setup-doctor
```

AeroSpace is distributed through its publisher's Homebrew tap. Its cask is
trusted explicitly in the Brewfile; the setup never trusts the entire tap.

Core packages live in `packages/Brewfile.core`. Profile-specific applications
live in `packages/Brewfile.home` and `packages/Brewfile.work`. Existing
dotfiles are backed up below `~/.local/state/setup/backups` before replacement.

Mise installs and switches developer runtimes. Both profiles use Node 26; the
work profile also uses OpenJDK 25, Gradle 9, and Terraform 1. Project-level
`mise.toml` files can override these global defaults automatically.

The default macOS phase preserves existing Dock applications and tracking
speeds. To apply the complete opinionated configuration, including clearing the
Dock and using the fast mouse and trackpad speeds:

```sh
~/setup/bin/setup home --include-opinionated
```

The setup command supports comma-separated `--only` and `--skip` phase
lists. Run `~/setup/bin/setup --help` for the complete interface. After setup,
`setup-doctor` runs automatically at the end and verifies packages, managed
links, Mise tools, PATH in a fresh login shell, Git, the Bitwarden SSH agent,
and Neovim. It exits unsuccessfully when required configuration is missing,
making it suitable for troubleshooting and CI.

If setup replaces an existing dotfile, recover it from the newest directory
under `~/.local/state/setup/backups`. Package removal is intentionally not
automatic; Homebrew software outside these manifests is left untouched.

Some setup remains interactive: macOS may request Accessibility permissions,
the App Store and applications require sign-in, Bitwarden's SSH agent must be
enabled, and browsers need their account sync configured.

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
| 4 | Workbench (Finder, IntelliJ IDEA, Affinity, Obsidian, Bitwarden, SourceTree, TablePro, Bruno, Zed) |
| 5 | Terminals, development processes, and monitoring (Ghostty, Neovim, DBUI) |
| 6 | Steam |
| 7–8 | Spare/manual workspaces |
| 9 | Default destination for any app without an explicit routing rule |

Apps are routed when AeroSpace detects a new window, including apps opened from
Spotlight or the Dock. Every Ghostty window is routed to workspace 5, including
windows opened outside an AeroSpace binding. System notification windows are
exempt.

### AeroSpace application shortcuts

| Binding | Action |
| ------- | ------ |
| `Option-Q` | Open a new Ghostty window in workspace 5 |
| `Option-F` | Open `~/Documents` in Finder on workspace 4 |
| `Option-B` | Open Firefox on workspace 2 |
| `Option-I` | Open Spotify on workspace 3 |
| `Option-N` | Open Neovim in Ghostty on workspace 5 |
| `Option-S` | Open `nvim +DBUI` in Ghostty on workspace 5 |
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

The macOS Shortcuts **Open Workbench Terminal** and **Open SourceTree** invoke
`Option-Q` and `Option-G` respectively and are searchable from Spotlight.

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

### Ghostty

Ghostty starts in `~/dev` and provides the standard `Command-T` binding for a
new native tab. `Command-W` closes the current surface without confirmation.

### Bitwarden SSH agent

The shared OpenSSH configuration is stored in `config/ssh/config`. It directs
SSH clients, including SourceTree when it uses OpenSSH, to the Bitwarden desktop
app's SSH agent at `~/.bitwarden-ssh-agent.sock`.

Enable **SSH agent** in Bitwarden's settings and select **System Git** in
SourceTree under **Settings → Git**. Repositories must use SSH remote URLs, such
as `git@github.com:owner/repository.git`, rather than HTTPS URLs.

The setup tool links the configuration to `~/.ssh/config`. Private keys are
not copied from this repository because Bitwarden manages them. Verify the
agent with:

```sh
SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock" ssh-add -L
ssh -T git@github.com
```
