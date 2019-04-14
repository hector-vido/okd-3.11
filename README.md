OKD - 3.11
==========

This **Vagrantfile** create 4 machines, one with the roles "master" and "infra", other two with the "node" role and another one for storage purposes:

| Machine        | Address      | Roles         |
|----------------|--------------|---------------|
| master.okd.os  | 192.168.1.10 | master, infra |
| node1.okd.os   | 192.168.1.10 | node          |
| node2.okd.os   | 192.168.1.10 | node          |
| storage.okd.os | 192.168.1.10 | -             |

Everything is installed during the provisioning stage, this means that after the provisioning step, vagrant execute these two commands:

    ansible-playbook /root/openshift-ansible/playbooks/prerequisites.yml
    ansible-playbook /root/openshift-ansible/playbooks/deploy_cluster.yml

The ansible on master machine is preconfigured with the keys and the hosts to access the other machines without problems.
During provisioning step, the preconfigured **inventory** presented in *files/hosts* is copied to the master's */etc/ansible/hosts*.

NAT
---

Some configurations on the inventory */etc/ansible/hosts* was added to overcome problems with default NAT interface that vagrant creates:

 - openshift_ip
 - openshift_public_ip
 - openshift_public_hostname

Disabled Services
-----------------

 - openshift_metrics_install_metrics
 - openshift_logging_install_logging
 - openshift_enable_olm
 - ansible_service_broker_install
 - template_service_broker_install

Requirements
------------

From a software point of view, you will need a least **VirtualBox**.
From a hardware point of view, each machine uses 2 cpu cores, unless the storage one. The master is configured to use 2GiB of RAM, the node ones 1GiB and the storage 256MiB, so you will need at least 6GiB of RAM, or even less if you lower the memory of each vm.

Installation
------------

This takes a lot of time, just go to the cloned folder and type:

    vagrant up

If you want to access the *webconsole* you can add the hostname and ip address on */etc/hosts*:

    echo '192.168.1.10 master.okd.os' | sudo tee -a /etc/hosts

And then access the address [https://master.okd.os:8443](https://master.okd.os:8443).
The **username** and **password** are created in the first login attempt from the username you choose.
