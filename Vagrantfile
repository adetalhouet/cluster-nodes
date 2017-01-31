# -*- mode: ruby -*-
# vi: set ft=ruby :

# Copyright (c) 2017 Alexis de Talhouët
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$install_odl = <<SCRIPT
HOME=/home/vagrant/
mkdir opendaylight
cp -r /vagrant/opendaylight/* opendaylight/
nohup /vagrant/scripts/setup_odl.sh > setup_odl.log 2>&1 &
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  num_nodes = (ENV['NUM_OF_NODES'] || 1).to_i

  config.vm.box = "trusty-server-cloudimg-amd64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  num_nodes.times do |n|
     config.vm.define "odl-#{n+1}" do | node |
        node.vm.host_name = "odl-#{n+1}"
        node.vm.network "private_network", :adapter=>2, ip: "192.168.50.15#{n+1}", bridge: "en0: Wi-Fi (AirPort)"
        node.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--memory", 4096]
          v.customize ["modifyvm", :id, "--cpus", 4]
        end
        node.vm.provision "install_odl", type: "shell", inline: $install_odl
      end
  end
end
