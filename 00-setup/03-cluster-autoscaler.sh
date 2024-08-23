#!/bin/bash
#
# Install the "in-tree" kubernetes Cluster Autoscaler
# See here:
# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
# 
#

./check-prereqs.sh
if [[ $? -ne 0 ]]; then
    echo "Missing prerequisites... exiting..."
    exit 1
fi

# This is the name of the cluster.
PREFIX="eks-demo"

echo "Preparing to setup the Cluster Auto Scaler..."
 
rm cluster-autoscaler-autodiscover.yaml

# See: https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
# NOTE: this will try to create an SA named "cluster-autoscaler" in kube-system, but that already exists
# because eksctl should've created it (an IRSA enabled SA)
#
curl -o cluster-autoscaler-autodiscover.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml

YAML_LINE_COUNT=$(cat cluster-autoscaler-autodiscover.yaml | wc -l )
echo "YAML_LINE_COUNT=$YAML_LINE_COUNT."
if [ $YAML_LINE_COUNT -eq 0 ]
then
    echo "Yaml file seems blank? Please investigate"
    exit 2
fi

# NOTE: We're replacing <YOUR CLUSTER NAME> but also adding two lines with the proper yaml indent of 12 spaces!
REPLACEMENT="$PREFIX\\r\\n            - --balance-similar-node-groups\\r\\n            - --skip-nodes-with-system-pods=false"
echo $REPLACEMENT

sed "s|<YOUR CLUSTER NAME>|$REPLACEMENT|g" cluster-autoscaler-autodiscover.yaml > cluster-autoscaler-customized.yaml

echo "Replacements in cluster-autoscaler-customized.yaml done. Applying..."

YAML_LINE_COUNT=$(cat cluster-autoscaler-customized.yaml | wc -l )
echo "YAML_LINE_COUNT=$YAML_LINE_COUNT."
if [ $YAML_LINE_COUNT -eq 0 ]
then
    echo "Yaml file seems blank? Please investigate"
    exit 2
fi

kubectl apply -f cluster-autoscaler-customized.yaml

# We don't want cluster autoscaler to ever be evicted.
kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'

echo "Patch deployment complete"

export K8S_VERSION=$(kubectl version | grep 'Server Version:' | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' | cut -d. -f1,2)
echo "K8S_VERSION=$K8S_VERSION"

# Make sure we are using the latest Autoscaler version for this particular version of Kubernetes
# The YAML manifest has an old version hardcoded, so we really need to udpate this...
export AUTOSCALER_VERSION=$(curl -s "https://api.github.com/repos/kubernetes/autoscaler/releases" | grep '"tag_name":' | sed -s 's/.*-\([0-9][0-9\.]*\).*/\1/' | grep -m1 ${K8S_VERSION})
echo "AUTOSCALER_VERSION=$AUTOSCALER_VERSION"

kubectl -n kube-system \
set image deployment.apps/cluster-autoscaler \
cluster-autoscaler=registry.k8s.io/autoscaling/cluster-autoscaler:v${AUTOSCALER_VERSION}
  
echo "cluster-auto-scaler install done."