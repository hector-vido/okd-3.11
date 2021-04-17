#!/bin/bash

mkdir -p /root/.ssh
cp /vagrant/files/key.pub /root/.ssh/authorized_keys

HOSTS="$(head -n2 /etc/hosts)"
echo -e "$HOSTS" > /etc/hosts
cat >> /etc/hosts <<EOF
172.27.11.10 okd.example.com
172.27.11.20 node1.example.com
172.27.11.30 node2.example.com
172.27.11.40 extras.example.com
EOF

