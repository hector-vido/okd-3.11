OKD - 3.11
==========

This **Vagrantfile** create 2 machines, one with the roles "master", "infra" and "node" and another one for storage/identity purposes:

| Machine             | Address       | Roles               |
|---------------------|---------------|---------------------|
| okd.example.com     | 172.27.11.10  | master, infra, node |
| extras.example.com  | 172.27.11.40  | storage, ldap       |

Everything is installed during the provisioning stage, this means that after the provisioning step, vagrant execute these two commands:

    ansible-playbook /root/openshift-ansible/playbooks/prerequisites.yml
    ansible-playbook /root/openshift-ansible/playbooks/deploy_cluster.yml

The ansible on master machine is preconfigured with the keys and the hosts to access the other machines without problems.
During provisioning step, the preconfigured **inventory** presented in **`files/hosts`** is copied to the master's **`/etc/ansible/hosts`**.

NAT
---

Some configurations on the inventory **`/etc/ansible/hosts`** was added to overcome problems with default NAT interface that vagrant creates:

 - etcd_ip

Disabled Services
-----------------

 - openshift_metrics_install_metrics
 - openshift_logging_install_logging
 - openshift_enable_olm
 - openshift_enable_service_catalog
 - ansible_service_broker_install
 - template_service_broker_install

Requirements
------------

From a software point of view, you will need a least **VirtualBox**.
From a hardware point of view, the **master** uses 2 cpu cores, and the **extras** only 1 core. The master is configured to use 4GiB of RAM and the storage 256MiB, so you will need at least 5GiB of **free** RAM.
If you are willing to install the **metrics** you'll need at least 6GiB of **free** RAM.

Installation
------------

This takes a lot of time, just go to the cloned folder and type:

    vagrant up

If you want to access the **webconsole** and/or see metrics you can add the hostnames and ip address on **/etc/hosts**:

	echo '172.27.11.10 okd.example.com' | sudo tee -a /etc/hosts

Remeber to access the address [https://hawkular-metrics.172-27-11-10.nip.io](https://hawkular-metrics.172-27-11-10.nip.io) and accept the self-signed certificate.

And then access the address [https://okd.example.com:8443](https://okd.example.com:8443).
The **username** and **password** are **developer** and **4linux**.
