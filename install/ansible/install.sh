sudo chown -R "$USER":admin /usr/local
sudo pip3 install --upgrade pip
pip3 install ansible

cd ./install/ansible

export PATH="$HOME/Library/Python/3.8/bin:"$PATH 
ansible-galaxy install -r requirements.yml
ansible-playbook main.yml --ask-become-pass --ask-vault-pass
