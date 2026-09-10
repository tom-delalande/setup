#!/usr/bin/env bash

setup_oh_my_zsh() {
  local install_directory="$HOME/.oh-my-zsh"

  if [[ -d "$install_directory/.git" ]]; then
    local origin
    origin="$(git -C "$install_directory" remote get-url origin)"
    case "$origin" in
      https://github.com/ohmyzsh/ohmyzsh.git | git@github.com:ohmyzsh/ohmyzsh.git)
        printf 'ok: Oh My Zsh is installed\n'
        return
        ;;
      *)
        die "refusing to use $install_directory: unexpected origin $origin"
        ;;
    esac
  fi

  if [[ -e "$install_directory" ]]; then
    die "refusing to overwrite existing non-repository path: $install_directory"
  fi

  run git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$install_directory"
}

setup_phase_packages() {
  log "Packages: core + $SETUP_PROFILE"

  local brew_bin
  brew_bin="$(brew_command)" || die "Homebrew is required before the packages phase"

  run "$brew_bin" bundle --file "$SETUP_ROOT/packages/Brewfile.core"
  run "$brew_bin" bundle --file "$SETUP_ROOT/packages/Brewfile.$SETUP_PROFILE"

  local mise_config="$SETUP_ROOT/config/mise/$SETUP_PROFILE.toml"
  if [[ "$SETUP_DRY_RUN" == "1" ]]; then
    printf '+ MISE_GLOBAL_CONFIG_FILE=%q mise install --yes\n' "$mise_config"
  else
    local mise_bin
    mise_bin="$("$brew_bin" --prefix mise)/bin/mise"
    [[ -x "$mise_bin" ]] || die "Mise was installed but its executable was not found"
    MISE_GLOBAL_CONFIG_FILE="$mise_config" "$mise_bin" install --yes
  fi

  setup_oh_my_zsh
}
