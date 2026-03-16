find ~/.local/share/nvim -name "*.so" | while read lib; do
	sudo codesign --force --sign - "$lib"
done

