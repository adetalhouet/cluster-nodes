#Deploy OpenDaylight Cluster
This repo provide a Vagrant file and a docker-compose.yml file so one can use to deploy an OpenDaylight cluster using one or the other.

##Configuration
The VMs / Containers are provisioned using the scripts/properties defined under _scripts_.

###config.properties
Specify how many nodes to deploy, and what OpenDaylight release to use. Default is 3 nodes using Boron-SR2.
Specify what features to be install on startup; add the ones you required.
The following will be installed:
   
* odl-jolokia
* odl-restconf
* odl-mdsal-clustering

##Usage
Execute the _setup_cluster.sh__ script, and all should be ready within the next half hour, depending on your network.

```
./scripts/setup_cluster.sh -p <docker|vagrant>
```

##Example
```
./scripts/setup_cluster.sh -p docker
```