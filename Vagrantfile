# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  num_nodes = (ENV['NUM_OF_NODES'] || 1).to_i

  config.vm.provision "puppet" do |puppet|
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "base.pp"
  end

  num_nodes.times do |n|
    config.vm.define "node-#{n+1}", autostart: true do |node|
      node_index = n+1
      node.vm.hostname = "node-#{node_index}"
      node.vm.network "private_network", :adapter=>2, ip: "192.168.50.15#{node_index}", bridge: "en0: Wi-Fi (AirPort)"
      node.vm.box = "trusty64"
      node.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box"
      node.vm.provider "vmware_fusion" do |v, override|
        override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_ubuntu-14.04_chef-provisionerless.box"
      end
      node.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        # Adapter type: paravirtualized 
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
        vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
        # Adapter promiscuous mode: allow-all
        vb.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
        vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
        vb.name = "node-#{node_index}"
      end
      node.vm.provider "vmware_fusion" do |vf|
        vf.vmx["memsize"] = "2048"
        vf.name = "node-#{node_index}"
      end
      node.vm.provision "puppet" do |puppet|
        puppet.working_directory = "/vagrant/puppet"
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "base.pp"
      end
    end
  end

end
