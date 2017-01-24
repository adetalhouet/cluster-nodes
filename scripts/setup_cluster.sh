#!/bin/bash

SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$SCRIPTS" && cd .. && pwd)"

cat <<EOF
################################################
##              Setup environment             ##
################################################
EOF
source $SCRIPTS/config.properties
export NUM_OF_NODES=$NUM_OF_NODES
echo "Cluster will be deployed using $ODL_VERSION."
echo "The cluster will have $NUM_OF_NODES nodes."

if [ ! -d "$ROOT/logs" ]; then
    mkdir $ROOT/logs
fi

if [ ! -d "$ROOT/temp/distribution-karaf-$ODL_VERSION" ]; then
    echo "Download OpenDaylight distribution"
    mkdir $ROOT/temp && cd $ROOT/temp
    curl $DISTRO_URL | tar xvz > $ROOT/logs/download_odl.log 2>&1 &
else
    echo "OpenDaylight distribution $ODL_VERSION already dowloaded."
fi

cat <<EOF
################################################
##             Spawn cluster nodes            ##
################################################
EOF
cd $ROOT && vagrant up | tee logs/vagrant.log

cat <<EOF
################################################
##          Your environment is setup         ##
################################################
EOF
