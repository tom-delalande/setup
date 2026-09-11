# macOS setup

This repository configures a new home or work Mac while keeping the shared
Oh My Zsh, editor, terminal, Git, and AeroSpace configuration identical.

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

Oh My Zsh is installed non-interactively in `~/.oh-my-zsh` and loaded from the
managed Zsh configuration with the `robbyrussell` theme and Git plugin.

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
making it suitable for troubleshooting and CI. Interactive terminals show
colored status; set `NO_COLOR=1` to force plain output.

If setup replaces an existing dotfile, recover it from the newest directory
under `~/.local/state/setup/backups`. Package removal is intentionally not
automatic; Homebrew software outside these manifests is left untouched.

Some setup remains interactive: macOS may request Accessibility permissions,
the App Store and applications require sign-in, Bitwarden's SSH agent must be
enabled, and browsers need their account sync configured.

## Photos and documents backup

The home profile installs Syncthing and restic. Together they replace recurring
Google Takeout exports with this flow:

```text
Android DCIM -> Syncthing mirror on Mac -> Apple Photos/iCloud
                                      `-> encrypted snapshots on SSD A and SSD B
iCloud Drive --------------------------^
```

One-time setup:

1. In Photos > Settings > iCloud, enable **iCloud Photos** and **Download
   Originals to this Mac**. An optimised library is not a complete local copy.
2. Install Syncthing on Android and share `DCIM/Camera` with the Mac as
   `~/Pictures/Android Camera`. Use send-only on Android and receive-only on the
   Mac. The Mac mirror is allowed to follow phone deletions because restic keeps
   versioned snapshots.
3. Format and name two external SSDs, copy `config/backup.conf.example` to
   `~/.config/setup/backup.conf`, and replace the example volume names.
4. Run `~/setup/bin/backup init`. Enter one strong repository password and save
   a recovery copy in Bitwarden; the command stores it in macOS Keychain and
   initialises both disks.

For every subsequent backup, connect both SSDs and run:

```sh
~/setup/bin/backup
```

To send new Android photos to Apple Photos/iCloud when the SSDs are not
available, run (no `backup.conf` is required):

```sh
~/setup/bin/backup sync
```

This command does not access either restic repository. It imports new media and
leaves Photos open so iCloud can continue uploading. A later full backup still
captures the Photos library on both SSDs.

To run this automatically every hour and after login, first run `backup sync`
manually once so macOS can request Photos automation permission, then install
the user LaunchAgent:

```sh
brew services start syncthing
~/setup/bin/backup install-sync
```

The scheduled job stays quiet on successful runs. On its first consecutive
failure it sends a macOS Notification Center alert, suppresses duplicate alerts,
and sends a recovery notification after the next success. It checks that
Syncthing is running, records the last successful run, and logs under
`~/.local/state/setup/backup`. Inspect or remove it with:

```sh
~/setup/bin/backup sync-status
~/setup/bin/backup uninstall-sync
```

The command refuses to continue if a source or either disk is missing. It asks
Photos to import only new Android media (with duplicate checking), closes Photos
for a consistent snapshot, backs up every configured source to both encrypted
repositories, and applies retention of 7 daily, 8 weekly, 24 monthly, and 10
yearly snapshots. It reopens Photos if it was open before the run.

Useful diagnostics and verification:

```sh
~/setup/bin/backup doctor
~/setup/bin/backup --dry-run
~/setup/bin/backup check
```

Keep both SSDs disconnected between runs, and preferably store one away from
home. iCloud Photos is synchronisation rather than an independent backup:
deletions propagate, while the offline restic snapshots preserve earlier data.
Google Takeout is still appropriate for one final historical Google Photos
export; the ongoing phone-to-Mac path makes future exports unnecessary.

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
