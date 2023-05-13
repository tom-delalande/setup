sudo chown -R "$USER":admin /usr/local
sudo pip3 install --upgrade pip
pip3 install ansible

cd ~/.dotfiles/install/ansible

ansible-galaxy install -r requirements.yml
ansible-playbook main.yml --ask-become-pass --ask-vault-pass
