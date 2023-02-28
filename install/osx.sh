#!/usr/bin/env bash

# Script name: dotfiles
# Description: Script to deploy my dotfiles easily.
# Dependencies: git, curl, zsh

export repo_host="https://github.com/"
export repo_path="thomas-delalande/.dotfiles.git"
export dotfiles_dir="$HOME/.dotfiles"

dirs=(
  ~/Library/Application\ Support/nushell/env.nu
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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew tap Homebrew/bundle
}

install_dependencies() {
    brew bundle --file ~/.dotfiles/src/Brewfile --cleanup
}

clone_repo() {
  if [ -d "$HOME/dotfiles" ]; then
    mv "$HOME/dotfiles" "${dotfiles_dir}";
  elif [ ! -d "${dotfiles_dir}" ]; then
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
    if [ ! -e "$name" ]; then
      ln -sfv "${dotfiles_dir}/src/${name}" "$HOME/${name}"
    else
      echo "${name} already exists."
    fi
  done
}

symlink_nushell() {
    ln -sfv "${dotfiles_dir}/src/nushell/config.nu" "$HOME/Library/Application\ Support/nushell/config.nu"
    ln -sfv "${dotfiles_dir}/src/nushell/env.nu" "$HOME/Library/Application\ Support/nushell/env.nu"
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



## Start of the script
install_brew
install_dependencies
clone_repo
create_dirs
symlink_files
symlink_nushell
install_nerd_fonts
