#!/bin/bash

#
# This will run all the steps in sequence.
# OR 
# You can run each step individually - it doesn't really matter
#

./00-tools.sh
./01-cluster.sh
./fix-blank-session.sh
./02-metrics-server.sh
./03-cluster-autoscaler.sh
./04-lb-controller.sh