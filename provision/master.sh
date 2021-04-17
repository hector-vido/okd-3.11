#!/bin/bash

# Dependências
yum install -y curl vim device-mapper-persistent-data lvm2 epel-release wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct docker python-ipaddress PyYAML

systemctl start docker
systemctl enable docker

for IMAGE in 'origin-node:v3.11' 'origin-pod:v3.11'; do
	docker pull "quay.io/openshift/$IMAGE"
	for IP in 20 30; do
		docker save "quay.io/openshift/$IMAGE" | ssh -o stricthostkeychecking=no root@172.27.11.$IP docker load
	done
done

yum install -y java python-passlib pyOpenSSL python-jinja2 python-paramiko python-setuptools python2-cryptography sshpass
rpm -i https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.2-1.el7.ans.noarch.rpm
cp /vagrant/files/hosts /etc/ansible/hosts
cp /vagrant/files/ansible.cfg /etc/ansible/ansible.cfg
cp /vagrant/files/key /root/.ssh/id_rsa; chmod 400 /root/.ssh/id_rsa 
cp /vagrant/files/key.pub /root/.ssh/id_rsa.pub
sed -i -e "s/#host_key_checking/host_key_checking/" /etc/ansible/ansible.cfg
sed -i -e "s@#private_key_file = /path/to/file@private_key_file = /root/.ssh/id_rsa@" /etc/ansible/ansible.cfg

git clone -b release-3.11 --single-branch https://github.com/openshift/openshift-ansible /root/openshift-ansible
cd /root/openshift-ansible
sed -i 's/openshift.common.ip/openshift.common.public_ip/' roles/openshift_control_plane/templates/master.yaml.v1.j2

ansible-playbook /root/openshift-ansible/playbooks/prerequisites.yml
ansible-playbook /root/openshift-ansible/playbooks/deploy_cluster.yml

htpasswd -Bbc /etc/origin/master/htpasswd developer 4linux
