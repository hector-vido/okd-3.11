# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.box_check_update = false
  
  config.vm.define "node1" do |srv|
    srv.vm.hostname = "node1.example.com"
    srv.vm.network "private_network", ip: "172.27.11.20"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
    srv.vm.provider "libvirt" do |lv|
      lv.memory = "2048"
      lv.cpus = "2"
      lv.cputopology :sockets => 1, :cores => 1, :threads => 2
    end
  end
  
  config.vm.define "node2" do |srv|
    srv.vm.hostname = "node2.example.com"
    srv.vm.network "private_network", ip: "172.27.11.30"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
    srv.vm.provider "libvirt" do |lv|
      lv.memory = "2048"
      lv.cpus = "2"
      lv.cputopology :sockets => 1, :cores => 1, :threads => 2
    end
  end

  config.vm.define "extras" do |srv|
    srv.vm.hostname = "extras.example.com"
    srv.vm.network "private_network", ip: "172.27.11.40"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
      vb.cpus = "1"
    end
    srv.vm.provider "libvirt" do |lv|
      lv.memory = "256"
      lv.cpus = "1"
      lv.cputopology :sockets => 1, :cores => 1, :threads => 1
    end
    srv.vm.provision "shell", path: "provision/extras.sh"
  end
  
  config.vm.define "master" do |srv|
    srv.vm.hostname = "okd.example.com"
    srv.vm.network "private_network", ip: "172.27.11.10"
    srv.vm.provider "virtualbox" do |vb|
      vb.memory = "6144"
      vb.cpus = "4"
    end
    srv.vm.provider "libvirt" do |lv|
      lv.memory = "6144"
      lv.cpus = "4"
      lv.cputopology :sockets => 1, :cores => 2, :threads => 2
    end
  end

  config.vm.provision "shell", path: "provision/generic.sh"
end
