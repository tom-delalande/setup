setup_phase_packages() {
  log "Packages: core + $SETUP_PROFILE"

  local brew_bin
  brew_bin="$(brew_command)" || die "Homebrew is required before the packages phase"

  run "$brew_bin" bundle --file "$SETUP_ROOT/packages/Brewfile.core"
  run "$brew_bin" bundle --file "$SETUP_ROOT/packages/Brewfile.$SETUP_PROFILE"

  local mise_config="$SETUP_ROOT/config/mise/$SETUP_PROFILE.toml"
  if [[ "$SETUP_DRY_RUN" == "1" ]]; then
    printf '+ MISE_GLOBAL_CONFIG_FILE=%q mise install --yes\n' "$mise_config"
    return
  fi

  local mise_bin
  mise_bin="$("$brew_bin" --prefix mise)/bin/mise"
  [[ -x "$mise_bin" ]] || die "Mise was installed but its executable was not found"
  MISE_GLOBAL_CONFIG_FILE="$mise_config" "$mise_bin" install --yes
}
