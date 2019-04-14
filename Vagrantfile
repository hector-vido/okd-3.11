# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  
  config.vm.define "node1" do |srv|
    srv.vm.hostname = "node1.okd.os"
    srv.vm.network "private_network", ip: "192.168.1.20"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "2"
    end
  end
  
  config.vm.define "node2" do |srv|
    srv.vm.hostname = "node2.okd.os"
    srv.vm.network "private_network", ip: "192.168.1.30"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "2"
    end
  end

  config.vm.define "storage" do |srv|
    srv.vm.hostname = "storage.okd.os"
    srv.vm.network "private_network", ip: "192.168.1.40"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
      vb.cpus = "1"
    end
    srv.vm.provision "shell", path: "provision/storage.sh"
  end
  
  config.vm.define "master" do |srv|
    srv.vm.hostname = "master.okd.os"
    srv.vm.network "private_network", ip: "192.168.1.10"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
  end

  config.vm.provision "shell", path: "provision/generic.sh"
end
