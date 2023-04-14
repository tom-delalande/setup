#!/usr/bin/env bash

# Script name: dotfiles
# Description: Script to deploy my dotfiles easily.
# Dependencies: git, curl, zsh

export repo_host="https://github.com/"
export repo_path="thomas-delalande/.dotfiles.git"
export dotfiles_dir="$HOME/.dotfiles"

export brewfile="Brewfile.rb"

if [ "$1" == "work" ]; then
    brewfile="Brewfile_work.rb"
fi

dirs=(
  ~/.config
  ~/dev
  ~/vgw
)

symlinks=(
  .config/git
  .config/alacritty
  .config/nvim
  .config/skhd
  .config/yabai
  .config/tmux
  .config/fish
  .config/lazygit
  .config/starship.toml
  .config/wezterm
  .zshrc
)

## End of configuration
set -e

install_brew() {
	if [[ $(command -v brew) == "" ]]; then
	    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	    brew tap Homebrew/bundle
	fi
}

install_dependencies() {
    brew bundle --file ~/.dotfiles/src/${brewfile} --cleanup
}

clone_repo() {
  if [ ! -d "${dotfiles_dir}" ]; then
    git clone "${repo_host}/${repo_path}" "${dotfiles_dir}"
  fi

  if [ -d "${dotfiles_dir}" ]; then 
    cd ${dotfiles_dir} && git submodule update --init --recursive
    ## Change to ssh url
    git remote set-url origin git@github.com:${repo_path}
  fi
}

create_dirs() {
  for name in "${dirs[@]}"; do mkdir -p "${name}"; done
}

symlink_files() {
  for name in "${symlinks[@]}"; do
    if [ ! -e "$HOME/$name" ]; then
      ln -sfv "${dotfiles_dir}/src/${name}" "$HOME/${name}"
    else
      echo "${name} already exists."
    fi
  done
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
install_dependencies
clone_repo
create_dirs
symlink_files
install_nerd_fonts
update_nvim_plugins
