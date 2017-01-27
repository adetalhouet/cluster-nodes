#!/bin/bash

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

SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$SCRIPTS" && cd .. && pwd)"

function setup_env {
    source $SCRIPTS/config.properties
    export NUM_OF_NODES=$NUM_OF_NODES
    echo "Cluster will be deployed using $ODL_VERSION."
    echo "The cluster will have $NUM_OF_NODES nodes."
}

function dowload_odl {
    if [ ! -d "$ROOT/opendaylight" ]; then
        echo "Download OpenDaylight distribution"
        mkdir opendaylight
        curl $DISTRO_URL | tar xvz -C opendaylight --strip-components=1
    else
        echo "OpenDaylight distribution $ODL_VERSION already dowloaded."
    fi
}

function setup_odl {
    env_banner
    cd $ROOT/opendaylight

    # for the OSX users, know that BSD-sed doesn't work the same as GNU-sed, hence this command won't work.
    # see http://stackoverflow.com/a/27834828/6937994
    # this command is intended to work with GNU-sed binary
    sed -i "/^featuresBoot[ ]*=/ s/management.*/management,$USER_FEATURES/" etc/org.apache.karaf.features.cfg
    echo "Those features will be installed: $USER_FEATURES"

    # to configure (add/modify/remove) shards that will be 
    # spwaned and shared within the cluster, please refer to 
    # the custom_shard_config.txt located under /bin
}

function spwan_vms {
    env_banner
    cd $ROOT && vagrant up
}

function spwan_containers {
    env_banner
    # create docker network specific to ODL cluster
    if [ `docker network ls | grep -w odl-cluster-network | wc -l | xargs echo ` == 0 ]; then
        echo "Docker network for OpenDaylight don't exist - creating ..."
        docker network create -o com.docker.network.bridge.enable_icc=true -o com.docker.network.bridge.enable_ip_masquerade=true --subnet 192.168.51.0/24 --gateway 192.168.51.1  odl-cluster-network
    fi
    
    # create all the containers
    MAX=$NUM_OF_NODES
    for ((i=1; i<=MAX; i++))
    do
        export NODE_NUMBER=$i
        docker-compose -p cluster-node_odl-$i up -d
    done
}

function prerequisites {
    cat <<EOF
################################################
##              Setup environment             ##
################################################
EOF
    setup_env

    cat <<EOF
################################################
##                 Download ODL               ##
################################################
EOF
    dowload_odl

    cat <<EOF
################################################
##              Configure cluster             ##
################################################
EOF
    setup_odl
}

function env_banner {
cat <<EOF
################################################
##             Spawn cluster nodes            ##
################################################
EOF
}

function end_banner { 
cat <<EOF
################################################
##          Your environment is setup         ##
################################################
EOF
}

usage() { echo "Usage: $0 -p <docker|vagrant>" 1>&2; exit 1; }

while getopts ":p:" opt; do
    case $opt in
        p)
            p=$OPTARG
            ;;
        \?)
            echo "Invalid option -$OPTARG" >&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z $p ]; then
    echo "Option -p requires an argument." >&2
    usage
fi

if [ $p == "docker" ]; then
    prerequisites
    spwan_containers
elif [ $p == "vagrant" ]; then
    prerequisites
    spwan_vms
else
    echo "Invalid argument $p for option -p"
    usage
fi

end_banner
