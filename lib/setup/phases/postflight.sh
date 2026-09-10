setup_phase_postflight() {
  log "Postflight checks"

  local brew_bin
  if [[ "$SETUP_DRY_RUN" == "1" ]]; then
    if brew_bin="$(brew_command 2>/dev/null)"; then
      printf '+ %q bundle check --file %q\n' "$brew_bin" "$SETUP_ROOT/packages/Brewfile.core"
      printf '+ %q bundle check --file %q\n' "$brew_bin" "$SETUP_ROOT/packages/Brewfile.$SETUP_PROFILE"
    else
      printf '+ check Homebrew package state\n'
    fi
  elif brew_bin="$(brew_command 2>/dev/null)"; then
    "$brew_bin" bundle check --verbose --file "$SETUP_ROOT/packages/Brewfile.core" ||
      warn "Some core packages are missing or outdated"
    "$brew_bin" bundle check --verbose --file "$SETUP_ROOT/packages/Brewfile.$SETUP_PROFILE" ||
      warn "Some $SETUP_PROFILE packages are missing or outdated"
  else
    warn "Homebrew was not found"
  fi

  if [[ "$SETUP_DRY_RUN" == "1" ]]; then
    printf '+ record active profile %q\n' "$SETUP_PROFILE"
  else
    mkdir -p "$HOME/.local/state/setup"
    printf '%s\n' "$SETUP_PROFILE" >"$HOME/.local/state/setup/profile"
  fi

  if [[ -S "$HOME/.bitwarden-ssh-agent.sock" ]]; then
    printf 'Bitwarden SSH agent socket is available.\n'
  else
    warn "Bitwarden SSH agent must be enabled in the desktop app"
  fi

  printf 'Manual steps may remain: sign in to the App Store and applications, and enable Accessibility permissions.\n'
  if [[ "$SETUP_DRY_RUN" == "1" ]]; then
    printf '+ %q %q\n' "$SETUP_ROOT/bin/setup-doctor" "$SETUP_PROFILE"
  else
    "$SETUP_ROOT/bin/setup-doctor" "$SETUP_PROFILE"
  fi
}
