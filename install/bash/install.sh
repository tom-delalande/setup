#!/usr/bin/env bash

# Script name: dotfiles
# Description: Script to deploy my dotfiles easily.
# Dependencies: git, curl, zsh

export repo_host="https://github.com/"
export repo_path="tom-delalande/setup.git"
export setup="$HOME/setup"

export brewfile="brewfile-main.rb"

set -e

install_brew() {
  if [[ $(command -v brew) == "" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew tap Homebrew/bundle
  fi
}

clone_repo() {
  if [ ! -d "${setup}" ]; then
    git clone "${repo_host}/${repo_path}" "${setup}"
  fi
}

install_dependencies() {
  brew bundle --file ${setup}/config/${brewfile} --cleanup
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

configure_osx() {
  defaults write NSGlobalDomain InitialKeyRepeat -int 20
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write -g com.apple.mouse.scaling 9.0
  defaults write -g com.apple.trackpad.scaling 9.0
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  osascript -e 'tell application "System Events" to tell every desktop to set picture to "~/setup/wallpaper.png"'
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  defaults write com.apple.screencapture location -string "${HOME}/Downloads"
  defaults write com.apple.screencapture type -string "png"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.dock tilesize -int 30
  defaults write com.apple.dock expose-animation-duration -float 0.15
  osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
  defaults write com.apple.dock orientation -string right
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock "autohide-delay" -float "0.0"
  killall Dock
}

install_brew
clone_repo
install_dependencies
create_dirs
symlink_files
install_nerd_fonts
update_nvim_plugins
configure_osx
