#!/usr/bin/env bash

setup_each_managed_link() {
  local callback="$1"
  local profile="$2"

  "$callback" "$SETUP_ROOT/config/zshrc" "$HOME/.zshrc"
  "$callback" "$SETUP_ROOT/config/zprofile" "$HOME/.zprofile"
  "$callback" "$SETUP_ROOT/config/ideavimrc" "$HOME/.ideavimrc"
  "$callback" "$SETUP_ROOT/config/git" "$HOME/.config/git"
  "$callback" "$SETUP_ROOT/config/nvim" "$HOME/.config/nvim"
  "$callback" "$SETUP_ROOT/config/lazygit" "$HOME/.config/lazygit"
  "$callback" "$SETUP_ROOT/config/ghostty" "$HOME/.config/ghostty"
  "$callback" "$SETUP_ROOT/config/aerospace" "$HOME/.config/aerospace"
  "$callback" "$SETUP_ROOT/config/mise/$profile.toml" "$HOME/.config/mise/config.toml"
  "$callback" "$SETUP_ROOT/config/ssh/config" "$HOME/.ssh/config"
}
