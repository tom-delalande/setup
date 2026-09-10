#!/usr/bin/env bash

setup_phase_homebrew() {
  log "Homebrew"

  if brew_command >/dev/null 2>&1; then
    warn "Homebrew is already installed"
    return
  fi

  if [[ "$SETUP_DRY_RUN" == "1" ]]; then
    printf '+ install Homebrew using the official installer\n'
    return
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew_command >/dev/null 2>&1 || die "Homebrew installed but its executable was not found"
}
