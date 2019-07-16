#!/bin/bash

> /etc/exports

for X in $(seq 0 9); do
	mkdir -p /srv/nfs/v$X
	echo "/srv/nfs/v$X 27.11.90.0/24(rw,all_squash)" >> /etc/exports
done

chmod 0700 /srv/nfs/v*
chown nfsnobody: /srv/nfs/v*

exportfs -a
systemctl start rpcbind nfs-server
systemctl enable rpcbind nfs-server
