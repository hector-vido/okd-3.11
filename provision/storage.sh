#!/bin/bash

mkdir -p /volumes/v{1,2,3,4,5}

cat > /etc/exports <<EOF
/volumes/v1 27.11.90.0/255.255.255.0(rw,root_squash)
/volumes/v2 27.11.90.0/255.255.255.0(rw,root_squash)
/volumes/v3 27.11.90.0/255.255.255.0(rw,root_squash)
/volumes/v4 27.11.90.0/255.255.255.0(rw,root_squash)
/volumes/v5 27.11.90.0/255.255.255.0(rw,root_squash)
EOF

exportfs -a
systemctl start nfs-server
systemctl enable nfs-server
