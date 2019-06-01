#!/bin/bash

mkdir -p /volumes/v{1,2,3,4,5}

cat > /etc/exports <<EOF
/volumes/v1 192.168.1.0/255.255.255.0(rw,root_squash,no_subtree_check)
/volumes/v2 192.168.1.0/255.255.255.0(rw,root_squash,no_subtree_check)
/volumes/v3 192.168.1.0/255.255.255.0(rw,root_squash,no_subtree_check)
/volumes/v4 192.168.1.0/255.255.255.0(rw,root_squash,no_subtree_check)
/volumes/v5 192.168.1.0/255.255.255.0(rw,root_squash,no_subtree_check)
EOF

exportfs -a
systemctl start nfs-server
systemctl enable nfs-server
