nix build ~/.dotfiles/src\#darwinConfigurations.yellow-child.system
cd ~/.dotfiles/src
./result/sw/bin/darwin-rebuild switch --flake .

