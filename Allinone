# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
  'extras' => {'memory' => '256', 'cpus' => 1, 'ip' => '40', 'host' => 'extras', 'provision' => 'extras.sh'},
  'master' => {'memory' => '4096', 'cpus' => 4, 'ip' => '10', 'host' => 'okd', 'provision' => 'allinone.sh'}
}

Vagrant.configure('2') do |config|

  config.vm.box = 'centos/7'
  config.vm.box_check_update = false

  vms.each do |name, conf|
    config.vm.define "#{name}" do |k|
      k.vm.hostname = "#{conf['host']}.example.com"
      k.vm.network 'private_network', ip: "172.27.11.#{conf['ip']}"
      k.vm.provider 'virtualbox' do |vb|
        vb.memory = conf['memory']
        vb.cpus = conf['cpus']
      end
      k.vm.provider 'libvirt' do |lv|
        lv.memory = conf['memory']
        lv.cpus = conf['cpus']
        lv.cputopology :sockets => 1, :cores => conf['cpus'], :threads => '1'
      end
      k.vm.provision 'shell', path: "provision/#{conf['provision']}"
    end
  end

  config.vm.provision 'shell', path: 'provision/provision.sh'
end
