#!/bin/bash

mkdir -p /volumes/v{1,2,3,4,5}
chmod 0700 /volumes/v{1,2,3,4,5}
chown nfsnobody: /volumes/v{1,2,3,4,5}

cat > /etc/exports <<EOF
/volumes/v1 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v2 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v3 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v4 27.11.90.0/255.255.255.0(rw,all_squash)
/volumes/v5 27.11.90.0/255.255.255.0(rw,all_squash)
EOF

exportfs -a
systemctl start rpcbind nfs-server
systemctl enable rpcbind nfs-server
