#!/bin/bash

# Dependências
yum install -y curl vim device-mapper-persistent-data lvm2 epel-release wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct

# Docker mais recente, evita problemas em baixar cockpit
yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl start docker
sleep 10
echo '{                     
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",  
  "log-opts": {
  "max-size": "5m",
  "max-file": "3"
  }
}' > /etc/docker/daemon.json
systemctl enable docker
systemctl restart docker

#docker pull docker.io/openshift/origin-pod:v3.11
#docker pull docker.io/openshift/origin-node:v3.11
#docker pull docker.io/openshift/origin-docker-builder:v3.11.0
