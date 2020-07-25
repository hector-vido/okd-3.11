#!/bin/bash

yum -y install vim openldap-servers openldap-clients

# LDAP
systemctl enable slapd
systemctl start slapd

ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

ldapmodify -Y EXTERNAL -H ldapi:/// -f /vagrant/files/ldap.ldif
ldapadd -h 'localhost' -D 'cn=admin,dc=extras,dc=example,dc=com' -w 'okdldap' -f /vagrant/files/base.ldif
ldapadd -h 'localhost' -D 'cn=admin,dc=extras,dc=example,dc=com' -w 'okdldap' -f /vagrant/files/users.ldif
ldapadd -h 'localhost' -D 'cn=admin,dc=extras,dc=example,dc=com' -w 'okdldap' -f /vagrant/files/groups.ldif

# NFS
> /etc/exports

for X in $(seq 0 9); do
        mkdir -p /srv/nfs/v$X
        echo "/srv/nfs/v$X 172.27.11.0/24(rw,all_squash)" >> /etc/exports
done

chmod 0700 /srv/nfs/v*
chown nfsnobody: /srv/nfs/v*

exportfs -a
systemctl start rpcbind nfs-server
systemctl enable rpcbind nfs-server
