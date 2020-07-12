#!/bin/bash
# Bug do cloud-init vs ansible requer que a variável HOME esteja explicitamente setada.
# Ver https://github.com/ansible/ansible/issues/31617#issuecomment-337029203
export HOME=/root
cd /tmp
apt-get update && apt-get install -y python ansible unzip
wget https://allanfvc.s3.amazonaws.com/ansible/provisioning.zip
unzip provisioning.zip -d provisioning
cd /tmp/provisioning
ansible-playbook -i hosts_db provisioning.yml --extra-vars "db_name=${db_name} db_user=${db_user} db_password=${db_password} app_network=${app_network}"