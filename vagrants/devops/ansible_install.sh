#!/bin/bash -xe

echo '==> Installing ansible'

python3 -m pipx install --include-deps ansible==$(cat .ansible.version)
python3 -m pipx inject ansible python-consul boto3

cat <<- EOF > ~/.ansible.cfg
[defaults]
callbacks_enabled = profile_tasks
EOF

echo '==> Versions:'

ansible --version
ansible-playbook --version