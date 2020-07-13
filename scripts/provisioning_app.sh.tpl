#!/bin/bash
export HOME=/root
echo "stating provisioning"
cd /tmp
apt-get update && apt-get install -y python ansible unzip awscli
chmod 400 /home/ubuntu/.ssh/id_rsa
aws s3 cp s3://allanfvc/ansible/provisioning.zip provisioning.zip
unzip provisioning.zip -d provisioning
cd /tmp/provisioning
ansible-playbook -i hosts_app main.yml --extra-vars "db_name=${db_name} db_user=${db_user} db_password=${db_password} db_ip_addr=${db_ip_addr}"
