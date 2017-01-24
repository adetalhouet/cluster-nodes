#Deploy Cluster
This repo provides a Vagrantfile and scripts, with provisioning, that one can use to easily get a cluster of nodes configured.

##Configuration
The VMs are provisioned using the scripts/properties defined under _scripts_ and the Vagrantfile.

###config.properties
This is where you can specify how many nodes to deploy, and which released OpenDaylight version to use. Default is 3 nodes using Boron-SR2.

###setup_cluster.sh
This is the main script; it basically ensures you have an available OpenDaylight distribution to deploy on the nodes, or will download it, and it will trigger vagrant to build the cluster of VMs.

###setup_odl.sh
That script provisions the VMs by installing JDK-8. It installs the OpenDaylight distribution under `/home/vagrant/OpenDaylight`. It also configure the OpenDaylight instance:

Feature installation:
    * odl-jolokia
    * odl-restconf
    * odl-mdsal-clustering
    If you want to install your own feature, fell free to add them here.
    
Shard configuration: see (configure-cluster-ipdetect.sh)[https://github.com/opendaylight/integration-distribution/blob/release/boron-sr2/distribution-karaf/src/main/assembly/bin/configure-cluster-ipdetect.sh]

###Advance shard setup
To define your own shards, and/or your own way of setting them up, feel free to modify the _custom_shard_config.txt_ by following the guideline mentioned in the file.

###Vagrantfile
Resources setup:

* 4GO RAM
* 4 CPUs

Network setup:

* Adapter 1: NAT
* Adapter 2: Bridge "en0: Wi-Fi (AirPort)"
* Static IP address: 192.168.50.15#{node_index}
* Adapter type: paravirtualized 
* Adapter promiscuous mode: allow-all

Sync the _scripts_ and the _temp_ folder

##Usage
Execute the _setup_cluster.sh__ script, and all should be ready within the next half hour, depending on your network.

```
./scripts/setup_cluster.sh
```