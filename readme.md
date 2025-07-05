
# Instructions

## Ansible

1. Upgrade pip
```sh
sudo pip3 install --upgrade pip
export PATH="$HOME/Library/Python/3.8/bin:"$PATH
```

2. Install Ansible
```sh
pip3 install ansible
```

3. Run Ansible
```sh
cd install/ansible
ansible-galaxy install -r requirements.yml
ansible-playbook main.yml --ask-become-pass --ask-vault-pass

// Or work
ansible-playbook main.yml --ask-become-pass --ask-vault-pass -l work

// Or specific tags
ansible-playbook main.yml --ask-become-pass --ask-vault-pass --tags brew nvim ssh dotfiles osx
```

I don't think I should need to run this but I'm leaving it here incase
```
sudo chown -R "$USER":admin /usr/local
```

## Nix

My Nix configuration is based off https://github.com/Misterio77/nix-starter-configs and takes inspiration from https://github.com/vasujain275/rudra.

```sh
nix-shell -p git nvim
git clone https://github.com/tom-delalande/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles/install/nix
nixos-generate-config --show-hardware-config > nixos/harware-configuration.nix
sudo nixos-rebuild switch --flake .#nixos
```
```
