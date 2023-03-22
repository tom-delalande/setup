#!/bin/bash

# Instructions
# https://nixos.org/manual/nix/stable/installation/installing-binary.html#macos

echo "Step 1"
sudo sed -i '' '/#\ Nix/,/#\ End\ Nix/d' /etc/bashrc
sudo sed -i '' '/#\ Nix/,/#\ End\ Nix/d' /etc/zshrc

sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
sudo mv /etc/bashrc.backup-before-nix /etc/bashrc

echo "Step 2"
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist

echo "Step 3"
sudo dscl . -delete /Groups/nixbld
for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done

echo "Step 4"
sudo sed -i '' '/nix/d' /etc/fstab

echo "Step 5"
sudo sed -i '' '/nix/d' /etc/synthetic.conf

echo "Step 6"
sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels

echo "Step 7"
sudo diskutil apfs deleteVolume /nix
