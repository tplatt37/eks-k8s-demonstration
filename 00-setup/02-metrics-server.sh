#!/bin/bash

#
# Install the k8s metrics server
# https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
# The Cluster Autoscaler needs this.
#

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get deployment metrics-server -n kube-system