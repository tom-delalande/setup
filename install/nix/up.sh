
if [ "$1" == "work" ]; then
    export WORK=thomas
else 
    export SYSTEM=yellow-child
fi

nix build ~/.dotfiles/src\#darwinConfigurations.$SYSTEM.system
cd ~/.dotfiles/src
./result/sw/bin/darwin-rebuild switch --flake .

