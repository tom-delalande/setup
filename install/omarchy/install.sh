#!/usr/bin/env bash

### THIS FILE IS A WORK IN PROGRESS ###

export repo_host="https://github.com/"
export repo_path="tom-delalande/setup.git"
export setup="$HOME/setup"

set -e

clone_repo() {
  if [ ! -d "${setup}" ]; then
    git clone "${repo_host}/${repo_path}" "${setup}"
  fi
}

remove_packages() {
  sudo pacman -Rsu \
    1password-beta \
    1password-cli

}
install_packages() {
  sudo pacman -Syu \
    bitwarden \
    obs-studio \
    steam \
    syncthing \
    audacity \
    shotcut \
    tmux
}

create_dirs() {
  dirs=(
    ~/.config
    ~/dev
  )

  for name in "${dirs[@]}"; do mkdir -p "${name}"; done
}

symlink_file() {
  if [ ! -e "$HOME/$1" ]; then
    ln -sfv "${setup}/config/$2" "$HOME/$1"
  else
    echo "$1 already exists."
  fi
}

symlink_files() {
  # symlink_file .bashrc .bashrc
  symlink_file .config/git git
  rm -rf $HOME/.config/nvim
  symlink_file .config/nvim nvim
  symlink_file .config/tmux tmux
  symlink_file .config/fish fish

  rm -rf $HOME/.config/hypr/monitors.conf
  symlink_file .config/hypr/monitors.conf hypr/monitors.conf

  rm -rf $HOME/.bashrc
  symlink_file .bashrc bashrc

  # symlink_file .config/lazygit lazygit
  # symlink_file .config/starship.toml starship.toml
}

update_nvim_plugins() {
  nvim --headless +Lazy update +qa
}

configure_omarchy() {
  omarchy-webapp-remove Basecamp
  omarchy-webapp-remove HEY
  omarchy-webapp-remove WhatsApp
  omarchy-webapp-remove X
  omarchy-webapp-remove Zoom
  omarchy-webapp-remove Fizzy

  sed '3s/^/#' ~/.local/share/omarchy/default/hypr/autostart.conf
}

clone_repo
remove_packages
install_packages
create_dirs
symlink_files
update_nvim_plugins
configure_omarchy
