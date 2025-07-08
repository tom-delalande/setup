#!/usr/bin/env bash

# Script name: dotfiles
# Description: Script to deploy my dotfiles easily.
# Dependencies: git, curl, zsh

export repo_host="https://github.com/"
export repo_path="tom-delalande/setup.git"
export dotfiles_dir="$HOME/setup"

export brewfile="brewfile-main.rb"

if [ "$1" == "work" ]; then
  brewfile="Brewfile_work.rb"
fi

set -e

install_brew() {
  if [[ $(command -v brew) == "" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew tap Homebrew/bundle
  fi
}

clone_repo() {
  if [ ! -d "${dotfiles_dir}" ]; then
    git clone "${repo_host}/${repo_path}" "${dotfiles_dir}"
  fi
}

install_dependencies() {
  brew bundle --file ${dotfiles_dir}/config/${brewfile} --cleanup
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
    ln -sfv "${dotfiles_dir}/config/$2" "$HOME/$1"
  else
    echo "$1 already exists."
  fi
}

symlink_files() {
  symlink_file .zshrc .zshrc
  symlink_file .ideavimrc ideavimrc
  symlink_file .config/git git
  symlink_file .config/nvim nvim
  symlink_file .config/tmux tmux
  symlink_file .config/fish fish
  symlink_file .config/lazygit lazygit
  symlink_file .config/starship.toml starship.toml
  symlink_file .config/wezterm wezterm
  symlink_file .config/aerospace aerospace
}

fonts=(
  JetBrainsMono
  RobotoMono
)

install_nerd_fonts() {
  for font in "${fonts[@]}"; do
    local font_path="$HOME/.local/share/fonts/${font}"
    if [[ ! -d "${font_path}" ]]; then
      curl -L --create-dirs "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/${font}.zip" -o "${font_path}.zip"
      unzip "${font_path}.zip" -d "${font_path}"
      rm -rf "${font_path}.zip"
    else
      echo "${font} is already on your system"
    fi
  done
}

update_nvim_plugins() {
  nvim --headless +Lazy update +qa
}

## Start of the script
install_brew
clone_repo
install_dependencies
create_dirs
symlink_files
install_nerd_fonts
update_nvim_plugins
