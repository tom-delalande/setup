setup_phase_macos() {
  log "macOS preferences"

  if [[ "$SETUP_DRY_RUN" == "1" && "$SETUP_OPINIONATED" == "1" ]]; then
    /bin/bash "$SETUP_ROOT/config/osx/config" --dry-run --opinionated
  elif [[ "$SETUP_DRY_RUN" == "1" ]]; then
    /bin/bash "$SETUP_ROOT/config/osx/config" --dry-run
  elif [[ "$SETUP_OPINIONATED" == "1" ]]; then
    /bin/bash "$SETUP_ROOT/config/osx/config" --opinionated
  else
    /bin/bash "$SETUP_ROOT/config/osx/config"
  fi
}
