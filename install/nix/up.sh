
if [ "$1" == "work" ]; then
    export WORK=thomas
else 
    export SYSTEM=yellow-child
fi

nix build ~/.dotfiles/install/nix\#darwinConfigurations.$SYSTEM.system
~/.dotfiles/src/result/sw/bin/darwin-rebuild switch --flake ./install/nix/
