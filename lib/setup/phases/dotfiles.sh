setup_link() {
  local source_path="$1"
  local destination_path="$2"

  if [[ -L "$destination_path" && "$(readlink "$destination_path")" == "$source_path" ]]; then
    printf 'ok: %s\n' "$destination_path"
    return
  fi

  run mkdir -p "$(dirname "$destination_path")"

  if [[ -e "$destination_path" || -L "$destination_path" ]]; then
    local relative_path
    relative_path="${destination_path#"$HOME"/}"
    run mkdir -p "$SETUP_BACKUP_DIRECTORY/$(dirname "$relative_path")"
    run mv "$destination_path" "$SETUP_BACKUP_DIRECTORY/$relative_path"
  fi

  run ln -s "$source_path" "$destination_path"
}

setup_remove_obsolete_link() {
  local source_path="$1"
  local destination_path="$2"

  if [[ -L "$destination_path" && "$(readlink "$destination_path")" == "$source_path" ]]; then
    run rm "$destination_path"
  fi
}

setup_phase_dotfiles() {
  log "Dotfiles"

  export SETUP_BACKUP_DIRECTORY="$HOME/.local/state/setup/backups/$(date +%Y%m%d-%H%M%S)"
  setup_remove_obsolete_link "$SETUP_ROOT/config/fish" "$HOME/.config/fish"
  setup_remove_obsolete_link "$SETUP_ROOT/config/starship.toml" "$HOME/.config/starship.toml"
  setup_remove_obsolete_link "$SETUP_ROOT/config/tmux" "$HOME/.config/tmux"

  # shellcheck source=../managed-links.sh
  source "$SETUP_ROOT/lib/setup/managed-links.sh"
  setup_each_managed_link setup_link "$SETUP_PROFILE"
}
