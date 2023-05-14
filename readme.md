
# Instructions

1. Upgrade pip
```sh
sudo pip3 install --upgrade pip
export PATH="$HOME/Library/Python/3.8/bin:"$PATH 
```

2. Install Ansible
```sh
pip3 install ansible
```

3. Install requirements
```sh
ansible-galaxy install -r install/ansible/requirements.yml
```

4. Run Playbook

```sh
ansible-playbook main.yml --ask-become-pass --ask-vault-pass
```
or work

```sh
ansible-playbook main.yml --ask-become-pass --ask-vault-pass -l vgw
```


I don't think I should need to run this but I'm leaving it here incase
```
sudo chown -R "$USER":admin /usr/local
```
