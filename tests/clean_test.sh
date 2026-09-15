#!/usr/bin/env bash

set -euo pipefail

TEST_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
readonly TEST_ROOT
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

mkdir -p \
  "$fixture/bin" \
  "$fixture/home/Applications/AeroSpace.app/Contents" \
  "$fixture/home/Applications/Firefox.app/Contents" \
  "$fixture/home/Applications/Loose.app/Contents" \
  "$fixture/home/Applications/Orphan.app/Contents" \
  "$fixture/home/Applications/Protected.app/Contents" \
  "$fixture/home/Library/Application Support/Loose" \
  "$fixture/home/Library/Messages/Attachments" \
  "$fixture/home/Library/Caches/com.example.loose" \
  "$fixture/home/.npm/_cacache" \
  "$fixture/home/Downloads" \
  "$fixture/home/Desktop" \
  "$fixture/home/Documents" \
  "$fixture/home/Library/Caches/Homebrew" \
  "$fixture/home/.Trash" \
  "$fixture/home/.cache/empty-tool" \
  "$fixture/home/.android/avd/Pixel.avd" \
  "$fixture/home/Library/Developer/CoreSimulator/Devices/11111111-1111-1111-1111-111111111111"

printf 'application data\n' >"$fixture/home/Applications/Loose.app/data"
printf 'protected application data\n' >"$fixture/home/Applications/Protected.app/data"
printf 'support data\n' >"$fixture/home/Library/Application Support/Loose/data"
printf 'cache data\n' >"$fixture/home/Library/Caches/com.example.loose/data"
printf 'message attachment\n' >"$fixture/home/Library/Messages/Attachments/photo.jpg"
printf 'npm cache\n' >"$fixture/home/.npm/_cacache/package"
printf 'download\n' >"$fixture/home/Downloads/keep me.txt"
dd if=/dev/zero of="$fixture/home/Downloads/largest download.bin" bs=1024 count=8 2>/dev/null
printf 'brew cache\n' >"$fixture/home/Library/Caches/Homebrew/archive"
printf 'trashed file\n' >"$fixture/home/.Trash/old-file"
printf 'emulator\n' >"$fixture/home/.android/avd/Pixel.avd/disk"
printf 'avd metadata\n' >"$fixture/home/.android/avd/Pixel.ini"
printf 'simulator data\n' >"$fixture/home/Library/Developer/CoreSimulator/Devices/11111111-1111-1111-1111-111111111111/data"

cat >"$fixture/bin/gum" <<'GUM'
#!/usr/bin/env bash
case "${1:-}" in
  confirm)
    [[ "$*" == *'--default=false'* ]] || exit 2
    [[ "$*" == *'--affirmative Yes'* ]] || exit 2
    [[ "$*" == *'--negative No'* ]] || exit 2
    exit 0
    ;;
  style)
    printf '%s\n' "${!#}"
    ;;
  choose)
    input="$(cat)"
    if [[ "$*" == *'--no-limit'* ]]; then
      if printf '%s\n' "$input" | grep -Eq '^[0-9]+\)'; then
        printf 'numbered choice was displayed\n' >&2
        exit 2
      fi
      [[ "$*" == *'--unselected-prefix=[ ] '* ]] || exit 2
      [[ "$*" == *'--selected-prefix=[x] '* ]] || exit 2
    fi
    case "$*" in
      *'Applications not managed'*)
        [[ "$input" == *'approximately'* ]] || exit 2
        selected="$input"
        ;;
      *'Select folder contents'*)
        [[ "${input%%$'\n'*}" == *Downloads* ]] || exit 2
        selected="$(printf '%s\n' "$input" | grep 'Downloads')"
        ;;
      *'System — select'*)
        [[ "${input%%$'\n'*}" == *'Docker unused Images'* ]] || exit 2
        [[ "$input" == *'All application caches'* ]] || exit 2
        [[ "$input" == *'All developer caches'* ]] || exit 2
        [[ "$input" == *'All unavailable simulators (1 device)'* ]] || exit 2
        [[ "$input" == *'Unused Homebrew dependencies'* ]] || exit 2
        [[ "$input" != *'Unavailable simulator:'* ]] || exit 2
        [[ "$input" != *'Application cache:'* ]] || exit 2
        [[ "$input" != *'npm package cache'* ]] || exit 2
        selected="$input"
        ;;
      *) selected="$(printf '%s\n' "$input" | head -1)" ;;
    esac
    if [[ "$*" == *'--label-delimiter'* ]]; then
      printf '%s\n' "$selected" | awk -F '\t' '{ print $NF }'
    else
      printf '%s\n' "$selected"
    fi
    ;;
esac
GUM

cat >"$fixture/bin/brew" <<EOF
#!/usr/bin/env bash
case "\$*" in
  'list --cask -1') printf 'orphan\nheadless-cask\n' ;;
  'leaves') printf 'git\nlegacy-cli\n' ;;
  '--cache') printf '%s\n' '$fixture/home/Library/Caches/Homebrew' ;;
  'autoremove --dry-run') printf 'Would autoremove 1 unneeded formula:\nunused-dependency\n' ;;
  'uninstall legacy-cli') [[ "${HOMEBREW_NO_AUTOREMOVE:-}" == 1 ]] || exit 2; printf 'simulated uninstall failure\n' >&2; exit 1 ;;
  *) printf 'brew %s\n' "\$*" ;;
esac
EOF

cat >"$fixture/bin/mdls" <<'MDLS'
#!/usr/bin/env bash
case "${!#}" in
  *Loose.app) printf 'com.example.loose\n' ;;
  *) printf '(null)\n' ;;
esac
MDLS

cat >"$fixture/bin/defaults" <<'DEFAULTS'
#!/usr/bin/env bash
exit 1
DEFAULTS

cat >"$fixture/bin/docker" <<'DOCKER'
#!/usr/bin/env bash
if [[ "${1:-}" == system && "${2:-}" == df ]]; then
  printf 'Images\t1.5GB (75%%)\nBuild Cache\t250MB\n'
else
  printf 'docker %s\n' "$*"
fi
DOCKER

cat >"$fixture/bin/xcrun" <<'XCRUN'
#!/usr/bin/env bash
if [[ "$*" == 'simctl list devices unavailable' ]]; then
  printf '    iPhone 15 (11111111-1111-1111-1111-111111111111) (unavailable, runtime profile not found)\n'
else
  printf 'xcrun %s\n' "$*"
fi
XCRUN

cat >"$fixture/bin/trash" <<'TRASH'
#!/usr/bin/env bash
[[ "${1:-}" != -- ]] || exit 2
if [[ "${1:-}" == *Protected.app ]]; then
  printf 'permission denied\n' >&2
  exit 1
fi
printf 'trash %s\n' "$*"
TRASH

cat >"$fixture/bin/osascript" <<'OSASCRIPT'
#!/usr/bin/env bash
printf 'osascript %s\n' "$*"
OSASCRIPT
chmod +x "$fixture/bin/"*

export HOME="$fixture/home"
export PATH="$fixture/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export CLEAN_APPLICATION_DIRS="$HOME/Applications"
export CLEAN_USER_FOLDERS="$HOME/Downloads:$HOME/Desktop:$HOME/Documents"

"$TEST_ROOT/bin/clean" --help | grep -q 'apps|files|system|trash' || fail 'help omitted direct cleaners'
"$TEST_ROOT/bin/tom" clean --help | grep -q 'apps|files|system|trash' || fail 'tom did not route the clean command'

apps_output="$("$TEST_ROOT/bin/clean" apps --dry-run)"
printf '%s\n' "$apps_output" | grep -q 'Loose.app' || fail 'unmanaged application was not offered'
printf '%s\n' "$apps_output" | grep -q 'Application Support/Loose' || fail 'application support data was not included'
printf '%s\n' "$apps_output" | grep -q 'Caches/com.example.loose' || fail 'bundle cache was not included'
printf '%s\n' "$apps_output" | grep -q 'brew uninstall --cask --zap --force orphan' || fail 'unmanaged cask did not use brew zap'
printf '%s\n' "$apps_output" | grep -q 'brew uninstall legacy-cli' || fail 'unmanaged Homebrew formula was not included'
printf '%s\n' "$apps_output" | grep -q 'brew uninstall --cask --zap --force headless-cask' || fail 'unmanaged non-app cask was not included'
if printf '%s\n' "$apps_output" | grep -q 'Firefox.app'; then
  fail 'managed Brewfile application was offered for removal'
fi
if printf '%s\n' "$apps_output" | grep -q 'AeroSpace.app'; then
  fail 'managed tapped application was offered for removal'
fi

apps_removal_output="$("$TEST_ROOT/bin/clean" apps 2>&1)"
printf '%s\n' "$apps_removal_output" | grep -q 'trash .*Loose.app' || fail 'ordinary application did not use trash'
printf '%s\n' "$apps_removal_output" | grep -q 'osascript - .*Protected.app' || fail 'protected application did not request administrator access'
printf '%s\n' "$apps_removal_output" | grep -q 'brew uninstall --cask --zap --force headless-cask' || fail 'cleanup stopped after a failed item'
printf '%s\n' "$apps_removal_output" | grep -q 'Skipped 1 item(s)' || fail 'failed cleanup was not summarized at the end'
printf '%s\n' "$apps_removal_output" | grep -q 'brew uninstall legacy-cli' || fail 'failed cleanup command was not logged'
if printf '%s\n' "$apps_removal_output" | grep -q 'trash --'; then
  fail 'unsupported trash option was used'
fi

files_output="$("$TEST_ROOT/bin/clean" files --dry-run)"
printf '%s\n' "$files_output" | grep -q 'keep me.txt' || fail 'selected folder contents were not cleaned'
printf '%s\n' "$files_output" | grep -q '^    largest download.bin' || fail 'largest folder files were not summarized'
if printf '%s\n' "$files_output" | grep -q 'Would move to Trash:.*Documents'; then
  fail 'unselected folder was removed'
fi

system_output="$("$TEST_ROOT/bin/clean" system --dry-run)"
printf '%s\n' "$system_output" | grep -q 'docker image prune --all --force' || fail 'Docker images cleanup was not routed'
printf '%s\n' "$system_output" | grep -q 'docker builder prune --all --force' || fail 'Docker build cache cleanup was not routed'
printf '%s\n' "$system_output" | grep -q 'brew autoremove' || fail 'unused Homebrew dependencies were not cleaned'
printf '%s\n' "$system_output" | grep -q 'xcrun simctl delete 11111111-1111-1111-1111-111111111111' || fail 'unavailable simulators were not cleaned as a group'
printf '%s\n' "$system_output" | grep -q 'Pixel.avd' || fail 'Android emulator was not included'
printf '%s\n' "$system_output" | grep -q 'Pixel.ini' || fail 'Android emulator metadata was not included'
printf '%s\n' "$system_output" | grep -q 'Messages/Attachments' || fail 'Messages attachments were not included'
printf '%s\n' "$system_output" | grep -q 'Library/Caches$' || fail 'all application caches were not included'
printf '%s\n' "$system_output" | grep -q '.npm/_cacache' || fail 'all developer caches were not included'
if printf '%s\n' "$system_output" | grep -q 'empty the trash'; then
  fail 'Trash cleanup was included in System'
fi
if printf '%s\n' "$system_output" | grep -q 'empty-tool'; then
  fail 'empty cache directory was included'
fi

trash_output="$("$TEST_ROOT/bin/clean" trash --dry-run)"
printf '%s\n' "$trash_output" | grep -q 'osascript -e .*empty' || fail 'standalone Trash cleanup was not routed'
printf '%s\n' "$trash_output" | grep -q 'Trash emptied' || fail 'standalone Trash cleanup did not finish'

printf 'All clean tests passed.\n'
