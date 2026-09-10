#!/usr/bin/env bash

set -euo pipefail

readonly SETUP_REPOSITORY_URL="${SETUP_REPOSITORY_URL:-https://github.com/tom-delalande/setup.git}"
readonly SETUP_DIRECTORY="${SETUP_DIRECTORY:-$HOME/setup}"

profile="${1:-}"
if [[ "$profile" != "home" && "$profile" != "work" ]]; then
  printf 'Usage: bootstrap.sh <home|work> [setup options]\n' >&2
  exit 2
fi
shift

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This bootstrap currently supports macOS only.\n' >&2
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  printf 'Opening the Apple Command Line Tools installer. Setup will continue when installation finishes.\n'
  xcode-select --install 2>/dev/null || true

  for ((attempt = 0; attempt < 720; attempt++)); do
    if xcode-select -p >/dev/null 2>&1; then
      break
    fi
    sleep 10
  done

  xcode-select -p >/dev/null 2>&1 || {
    printf 'Command Line Tools were not installed within two hours.\n' >&2
    exit 1
  }
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ -d "$SETUP_DIRECTORY/.git" ]]; then
  origin="$(git -C "$SETUP_DIRECTORY" remote get-url origin)"
  case "$origin" in
    https://github.com/tom-delalande/setup.git|git@github.com:tom-delalande/setup.git)
      ;;
    *)
      printf 'Refusing to update %s: unexpected origin %s\n' "$SETUP_DIRECTORY" "$origin" >&2
      exit 1
      ;;
  esac

  if [[ -z "$(git -C "$SETUP_DIRECTORY" status --porcelain)" ]]; then
    git -C "$SETUP_DIRECTORY" pull --ff-only
  else
    printf 'The setup checkout has local changes; preserving them and skipping pull.\n'
  fi
elif [[ -e "$SETUP_DIRECTORY" ]]; then
  printf 'Refusing to overwrite existing non-repository path: %s\n' "$SETUP_DIRECTORY" >&2
  exit 1
else
  git clone "$SETUP_REPOSITORY_URL" "$SETUP_DIRECTORY"
fi

exec "$SETUP_DIRECTORY/bin/setup" "$profile" "$@"
