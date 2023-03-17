if [ "$1" == "work" ]; then
    export WORK = true
fi

nix build ~/.dotfiles/src\#darwinConfigurations.yellow-child.system
cd ~/.dotfiles/src
./result/sw/bin/darwin-rebuild switch --flake .

