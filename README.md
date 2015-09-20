#Deploy ubuntu VM
This repo provides a Vagrantfile with provisioning, that one can use to easily get a cluster of nodes configured with OpenJDK and Unzip.

##Configuration
The VM is provisioned using puppet, and it's [boostrap script](https://github.com/hashicorp/puppet-bootstrap/blob/master/ubuntu.sh). <br>
The network configuration of the VM is:

* Adapter 1: NAT
* Adapter 2: Bridge "en0: Wi-Fi (AirPort)"
* Static IP address: 192.168.50.15#{node_index}
* Adapter type: paravirtualized 
* Adapter promiscuous mode: allow-all

You can easily SSH into it using those credentials:
```vagrant/vagrant```
The VM is configured with 2048Mo of RAM.
##Usage
A Vagrantfile is provided to easily create an Ubuntu environment containing openJDK and unzip. All you have to do is:
```
vagrant up
```
If you would like more than one VM, you can set the following environment variable (default is 1):
```
export NUM_OF_NODES=4
```
##Exemple
Let's say you want to spawn 3 VMs, all you have to do is:
```
export NUM_OF_NODES=3
vagrant up
```
<br>
And the VMs will be available at the following IP address:<br>

* 192.168.50.151
* 192.168.50.152
* 192.168.50.153
* 192.168.50.154