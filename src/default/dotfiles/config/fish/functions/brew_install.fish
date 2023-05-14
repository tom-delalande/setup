function brew_install
	echo "brew install" $argv >> $HOME/setup/1-install/1-3-install-homebrew-formulae.sh
	brew install $argv
end
