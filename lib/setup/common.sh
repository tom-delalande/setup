#!/usr/bin/env bash

log() {
  printf '\n==> %s\n' "$*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

run() {
  if [[ "$SETUP_DRY_RUN" == "1" ]]; then
    printf '+'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

phase_selected() {
  local candidate="$1"

  if [[ -n "$SETUP_ONLY" && ",$SETUP_ONLY," != *",$candidate,"* ]]; then
    return 1
  fi
  if [[ -n "$SETUP_SKIP" && ",$SETUP_SKIP," == *",$candidate,"* ]]; then
    return 1
  fi
  return 0
}

validate_phase_list() {
  local option_name="$1"
  local phase_list="$2"
  local phase
  local old_ifs="$IFS"

  [[ -n "$phase_list" ]] || die "$option_name requires at least one phase"
  IFS=','
  for phase in $phase_list; do
    case "$phase" in
      preflight|homebrew|packages|dotfiles|macos|postflight)
        ;;
      *)
        IFS="$old_ifs"
        die "unknown phase for $option_name: $phase"
        ;;
    esac
  done
  IFS="$old_ifs"
}

brew_command() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    printf '/opt/homebrew/bin/brew\n'
  elif [[ -x /usr/local/bin/brew ]]; then
    printf '/usr/local/bin/brew\n'
  else
    return 1
  fi
}
