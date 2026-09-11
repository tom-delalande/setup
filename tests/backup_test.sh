#!/usr/bin/env bash

set -euo pipefail

TEST_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT

mkdir -p "$fixture/bin" "$fixture/source" "$fixture/inbox" "$fixture/repo-a" "$fixture/repo-b" "$fixture/home"
touch "$fixture/repo-a/config" "$fixture/repo-b/config" "$fixture/inbox/photo.jpg"

cat >"$fixture/backup.conf" <<EOF
BACKUP_REPOSITORIES=("$fixture/repo-a" "$fixture/repo-b")
BACKUP_SOURCES=("$fixture/source" "$fixture/inbox")
ANDROID_PHOTO_INBOX="$fixture/inbox"
BACKUP_REQUIRE_EXTERNAL_VOLUMES=0
BACKUP_EXCLUDES=(".DS_Store")
EOF

cat >"$fixture/bin/restic" <<'EOF'
#!/usr/bin/env bash
printf 'restic %s\n' "$*" >>"$BACKUP_TEST_LOG"
EOF
cat >"$fixture/bin/security" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
cat >"$fixture/bin/osascript" <<'EOF'
#!/usr/bin/env bash
printf 'osascript %s\n' "$*" >>"$BACKUP_TEST_LOG"
EOF
cat >"$fixture/bin/pgrep" <<'EOF'
#!/usr/bin/env bash
[[ "${BACKUP_TEST_SYNCTHING_RUNNING:-0}" == "1" && "${2:-}" == "syncthing" ]]
EOF
cat >"$fixture/bin/open" <<'EOF'
#!/usr/bin/env bash
printf 'open %s\n' "$*" >>"$BACKUP_TEST_LOG"
EOF
cat >"$fixture/bin/launchctl" <<'EOF'
#!/usr/bin/env bash
printf 'launchctl %s\n' "$*" >>"$BACKUP_TEST_LOG"
EOF
chmod +x "$fixture/bin/"*

export BACKUP_TEST_LOG="$fixture/log"
export BACKUP_CONFIG="$fixture/backup.conf"
export HOME="$fixture/home"
export PATH="$fixture/bin:/usr/bin:/bin:/usr/sbin:/sbin"

"$TEST_ROOT/bin/backup" doctor | grep -q '^ok:'
"$TEST_ROOT/bin/backup" --dry-run >"$fixture/dry-run"
grep -q 'photo.jpg' "$fixture/dry-run"
grep -q 'repo-a.*backup' "$fixture/dry-run"
grep -q 'repo-b.*backup' "$fixture/dry-run"

"$TEST_ROOT/bin/backup" >/dev/null
grep -q '^osascript .*photo.jpg' "$BACKUP_TEST_LOG"
[[ "$(grep -c ' backup ' "$BACKUP_TEST_LOG")" -eq 2 ]]
[[ "$(grep -c ' forget ' "$BACKUP_TEST_LOG")" -eq 2 ]]

: >"$BACKUP_TEST_LOG"
"$TEST_ROOT/bin/backup" >/dev/null
if grep -q 'photo.jpg' "$BACKUP_TEST_LOG"; then
  printf 'FAIL: previously imported photo was imported twice\n' >&2
  exit 1
fi

# iCloud-only sync must work without either restic repository being available.
touch "$fixture/inbox/second-photo.jpg"
rm "$fixture/repo-a/config" "$fixture/repo-b/config"
: >"$BACKUP_TEST_LOG"
"$TEST_ROOT/bin/backup" sync >/dev/null
grep -q '^osascript .*second-photo.jpg' "$BACKUP_TEST_LOG"
grep -q '^open -a Photos' "$BACKUP_TEST_LOG"
if grep -q '^restic ' "$BACKUP_TEST_LOG"; then
  printf 'FAIL: sync command accessed a restic repository\n' >&2
  exit 1
fi

# With no configuration at all, sync uses the conventional Android inbox.
default_inbox="$HOME/Pictures/Android Camera"
mkdir -p "$default_inbox"
touch "$default_inbox/default-photo.jpg"
: >"$BACKUP_TEST_LOG"
BACKUP_CONFIG="$fixture/missing.conf" "$TEST_ROOT/bin/backup" sync >/dev/null
grep -q '^osascript .*default-photo.jpg' "$BACKUP_TEST_LOG"
grep -q '^open -a Photos' "$BACKUP_TEST_LOG"

# The scheduled wrapper alerts once on failure and once when service recovers.
rm -f "$HOME/.local/state/setup/backup/imported-photos.txt"
: >"$BACKUP_TEST_LOG"
if BACKUP_TEST_SYNCTHING_RUNNING=0 "$TEST_ROOT/bin/backup-sync-agent" >/dev/null 2>&1; then
  printf 'FAIL: scheduled sync succeeded while Syncthing was stopped\n' >&2
  exit 1
fi
grep -q 'Photo sync failed' "$BACKUP_TEST_LOG"

: >"$BACKUP_TEST_LOG"
BACKUP_TEST_SYNCTHING_RUNNING=0 "$TEST_ROOT/bin/backup-sync-agent" >/dev/null 2>&1 || true
if grep -q 'Photo sync failed' "$BACKUP_TEST_LOG"; then
  printf 'FAIL: repeated scheduled failure sent a duplicate notification\n' >&2
  exit 1
fi

: >"$BACKUP_TEST_LOG"
BACKUP_TEST_SYNCTHING_RUNNING=1 "$TEST_ROOT/bin/backup-sync-agent" >/dev/null
grep -q 'Photo sync recovered' "$BACKUP_TEST_LOG"
[[ -f "$HOME/.local/state/setup/backup/last-success" ]]
[[ ! -f "$HOME/.local/state/setup/backup/failure-active" ]]

# Installation produces a valid hourly user LaunchAgent and can remove it.
: >"$BACKUP_TEST_LOG"
"$TEST_ROOT/bin/backup" install-sync >/dev/null
agent_plist="$HOME/Library/LaunchAgents/com.setup.photo-sync.plist"
plutil -lint "$agent_plist" >/dev/null
grep -q '<integer>3600</integer>' "$agent_plist"
grep -q '^launchctl bootstrap ' "$BACKUP_TEST_LOG"
"$TEST_ROOT/bin/backup" sync-status >"$fixture/sync-status"
grep -q 'installed and loaded' "$fixture/sync-status"
"$TEST_ROOT/bin/backup" uninstall-sync >/dev/null
[[ ! -e "$agent_plist" ]]

printf 'All backup tests passed.\n'
