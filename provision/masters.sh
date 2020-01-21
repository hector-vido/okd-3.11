#!/bin/bash

cp /vagrant/files/key /root/.ssh/id_rsa
cp /vagrant/files/key.pub /root/.ssh/id_rsa.pub
chmod 400 /root/.ssh/id_rsa*

yum install -y curl vim device-mapper-persistent-data lvm2 epel-release wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct httpd-tools docker-1.13.1
systemctl start docker

for IMAGE in origin-pod:v3.11 origin-node:v3.11 origin-docker-builder:v3.11.0 origin-deployer:v3.11.0; do
  docker pull docker.io/openshift/$IMAGE
  docker save docker.io/openshift/$IMAGE | ssh -o stricthostkeychecking=no root@node1.example.com docker load
  docker save docker.io/openshift/$IMAGE | ssh -o stricthostkeychecking=no root@node2.example.com docker load
done

yum install -y java python-passlib pyOpenSSL PyYAML python-jinja2 python-paramiko python-setuptools python2-cryptography sshpass
rpm -i https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.5.7-1.el7.ans.noarch.rpm
cp /vagrant/files/hosts /etc/ansible/hosts
cp /vagrant/files/ansible.cfg /etc/ansible/ansible.cfg
sed -i -e "s/#host_key_checking/host_key_checking/" /etc/ansible/ansible.cfg
sed -i -e "s@#private_key_file = /path/to/file@private_key_file = /root/.ssh/id_rsa@" /etc/ansible/ansible.cfg

git clone -b release-3.11 --single-branch https://github.com/openshift/openshift-ansible /root/openshift-ansible
cd /root/openshift-ansible
sed -i 's/openshift.common.ip/openshift.common.public_ip/' roles/openshift_control_plane/templates/master.yaml.v1.j2
sed -i 's,--listfile /tmp/heketi-storage.json,--listfile /tmp/heketi-storage.json  --durability none' roles/openshift_storage_glusterfs/tasks/heketi_init_db.yml

ansible-playbook /root/openshift-ansible/playbooks/prerequisites.yml
ansible-playbook /root/openshift-ansible/playbooks/deploy_cluster.yml

htpasswd -Bbc /etc/origin/master/htpasswd developer 4linux

oc delete -f /vagrant/files/glusterfs-storage.yml
oc create -f /vagrant/files/glusterfs-storage.yml
