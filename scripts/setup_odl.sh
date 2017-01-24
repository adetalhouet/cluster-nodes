#!/bin/bash

SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $SCRIPTS/config.properties

function install_packages {
    #install java8
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    sudo add-apt-repository ppa:webupd8team/java -y
    sudo apt-get update -y
    sudo apt-get install oracle-java8-installer -y
    sudo update-java-alternatives -s java-8-oracle
    sudo apt-get install oracle-java8-set-default -y
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle
}

function install_odl {
    cd $HOME
    mkdir -p opendaylight
    cp -r temp/distribution-karaf-$ODL_VERSION/* opendaylight/
}

function start_odl {
    cd $HOME/opendaylight
    sed -i "/^featuresBoot[ ]*=/ s/$/,odl-mdsal-clustering,odl-restconf,odl-jolokia/" etc/org.apache.karaf.features.cfg;
    rm -rf journal snapshots
    ./bin/configure-cluster-ipdetect.sh 192.168.50.151 192.168.50.152 192.168.50.153``
    JAVA_MAX_MEM=4G JAVA_MAX_PERM_MEM=512m bin/karaf clean
}

echo "Install required packages" > $HOME/setup.prog
install_packages

echo "Install OpenDaylight" > $HOME/setup.prog
install_odl

echo "Starting OpenDaylight" > $HOME/setup.prog
start_odl