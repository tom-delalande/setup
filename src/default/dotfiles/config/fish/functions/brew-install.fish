function brew-install
    echo "brew install" $argv >> $HOME/setup/scripts/1-install/1-3-install-brew-formulae.sh
    brew install $argv
end
