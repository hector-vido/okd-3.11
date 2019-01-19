# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.box_check_update = false

  config.vm.define "master" do |srv|
    srv.vm.hostname = "master.okd.os"
    srv.vm.network "private_network", ip: "10.0.0.10"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "2"
    end
    srv.vm.provision "shell", inline: <<-SHELL
      sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
      yum -y --enablerepo=epel install ansible pyOpenSSL
      cd ~
      git clone https://github.com/openshift/openshift-ansible
      cd openshift-ansible
      git checkout release-3.11
      cp /vagrant/files/hosts /etc/ansible/hosts
      cp /vagrant/files/key /root/.ssh/id_rsa 
      cp /vagrant/files/key.pub /root/.ssh/id_rsa.pub
      sed -i -e "s/#host_key_checking/host_key_checking/" /etc/ansible/ansible.cfg
      sed -i -e "s@#private_key_file = /path/to/file@private_key_file = /root/.ssh/id_rsa@" /etc/ansible/ansible.cfg
    SHELL
  end
  
  config.vm.define "node1" do |srv|
    srv.vm.hostname = "node1.okd.os"
    srv.vm.network "private_network", ip: "10.0.0.20"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end

  end
  
  config.vm.define "node2" do |srv|
    srv.vm.hostname = "node2.okd.os"
    srv.vm.network "private_network", ip: "10.0.0.30"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end

  end

  config.vm.provision "shell", inline: <<-SHELL
    #for X in $(seq 1 9999); do sed -i 's#10.0.2.15#10.0.0.10#g' /etc/etcd/etcd.conf; sleep 1; done
    mkdir -p /root/.ssh
    cp /vagrant/files/key.pub /root/.ssh/authorized_keys
    yum install -y curl vim device-mapper-persistent-data lvm2 epel-release wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct docker-1.13.1
    HOSTS="$(head -n3 /etc/hosts)"
    echo -e "$HOSTS" > /etc/hosts
    echo -e '10.0.0.10 master.okd.os\n10.0.0.20 node1.okd.os\n10.0.0.30 node2.okd.os' >> /etc/hosts
    systemctl start docker
    docker pull docker.io/cockpit/kubernetes
    docker pull docker.io/openshift/origin-deployer:v3.11
    docker pull docker.io/openshift/origin-docker-registry:v3.11
    docker pull docker.io/openshift/origin-haproxy-router:v3.11
    docker pull docker.io/openshift/origin-pod:v3.11
    if [ "$HOSTNAME" == "master.okd.os" ]; then
      docker pull docker.io/openshift/origin-control-plane:v3.11
      docker pull quay.io/coreos/etcd:v3.2.22
    fi
  SHELL
end
