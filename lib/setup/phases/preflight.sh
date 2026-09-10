#!/usr/bin/env bash

setup_phase_preflight() {
  log "Preflight checks"

  [[ "$(uname -s)" == "Darwin" ]] || die "macOS is required"
  command -v curl >/dev/null 2>&1 || die "curl is required"
  command -v git >/dev/null 2>&1 || die "git is required"

  local mkdir_command=(mkdir -p "$HOME/.config" "$HOME/.ssh" "$HOME/dev")
  run "${mkdir_command[@]}"
  run chmod 700 "$HOME/.ssh"
}
