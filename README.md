# Vagrant - OKD - 3.11
This *Vagrantfile* create 3 machines, one with the roles "master" and "infra" and other two with the "node" role.

Everything is installed during the provisioning stage unless the two steps necessary to install OKD:

 - prerequisites.yml
 - deploy_cluster.yml

The ansible on master machine is preconfigured with the keys and the hosts to access the other machines without problems.

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

# Requirements

Each machine in *Vagrantfile* uses 2 cpu cores. The master is configured to use 2GiB of RAM and the node ones 1GiB.

# Installation

After provisioning step, enter in the master via ssh, and run the two playbooks responsible to prepare the nodes and deploy OKD:

    vagrant ssh master
    sudo ansible-playbook /root/openshift-ansible/playbooks/prerequisites.yml
    sudo ansible-playbook /root/openshift-ansible/playbooks/deploy_cluster.yml

If you want to access the *webconsole* you can add the hostname and ip address on */etc/hosts*:

    sudo su
    echo '192.168.1.10 master.okd.os' >> /etc/hosts