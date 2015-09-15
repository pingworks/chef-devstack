#!/bin/bash

cd /home/ubuntu/devstack
screen -X -S stack quit
./rejoin-stack.sh
