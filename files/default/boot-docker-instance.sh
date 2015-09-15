#!/bin/bash

DOCKER_IMG=$1
NAME=$2
DOMAIN=$3
PORT=$4

if [ -z "$DOCKER_IMG" -o -z "$NAME" -o -z "$DOMAIN" ]; then
  echo "Usage: $0 <docker-img> <name> <domain> [<port>]"
  exit 1
fi

set -e

docker images | grep $DOCKER_IMG \
  || docker pull $DOCKER_IMG

~/openstack.sh demo nova image-list | cut -d'|' -f3 | grep $DOCKER_IMG \
  || docker save $DOCKER_IMG | ~/openstack.sh admin glance image-create \
  --name $DOCKER_IMG \
  --is-public true \
  --container-format docker \
  --disk-format raw

~/openstack.sh demo nova list | cut -d'|' -f3 | grep $NAME \
  || ~/openstack.sh demo nova boot --image $DOCKER_IMG --flavor m1.small $NAME
sleep 5

IP=$(~/openstack.sh demo nova floating-ip-create | grep public | cut -d '|' -f3 | sed -e 's;^ *;;' -e 's; *$;;')
~/openstack.sh demo nova floating-ip-associate $NAME $IP

[ -z "$PORT" ] || ~/openstack.sh demo nova secgroup-add-rule default tcp $PORT $PORT $IP/32

~/openstack.sh demo designate domain-list | grep $DOMAIN. \
  || ~/openstack.sh demo designate domain-create --name $DOMAIN. --email christoph.lukas@gmx.net
DID=$(~/openstack.sh demo designate domain-list | grep $DOMAIN. | cut -d'|' -f2)

~/openstack.sh demo designate record-create --name $NAME.$DOMAIN. --data $IP --type A ${DID//[[:blank:]]/}

~/openstack.sh demo nova list
