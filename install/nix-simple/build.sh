#!/bin/sh

NIX_CONFIG="experimental-features = nix-command flakes"
sudo nixos-rebuild switch --flake .#nixos
