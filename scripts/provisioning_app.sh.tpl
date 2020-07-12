#!/bin/bash
# Bug do cloud-init vs ansible requer que a variável HOME esteja explicitamente setada.
# Ver https://github.com/ansible/ansible/issues/31617#issuecomment-337029203
export HOME=/root
cd /tmp
apt-get update && apt-get install -y python ansible unzip
wget https://allanfvc.s3.amazonaws.com/ansible/provisioning.zip
unzip provisioning.zip -d provisioning
cd /tmp/provisioning
ansible-playbook -i hosts_app provisioning.yml --extra-vars "db_name=${db_name} db_user=${db_user} db_password=${db_password} db_ip_addr=${db_ip_addr}"
cd /www/app
npm install
npm start