#!/bin/bash
#
# Installs the LATEST / STABLE AWS Load Balancer Controller, as per:
# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
#

# This is the name of the cluster
PREFIX="eks-demo"

echo "Preparing to setup the AWS Load Balancer Controller...using Helm."

  
# Recommended to use Regional STS endpoints - see install instructions.
kubectl annotate serviceaccount -n kube-system aws-load-balancer-controller eks.amazonaws.com/sts-regional-endpoints=true
  
helm repo add eks https://aws.github.io/eks-charts

# Make sure we have the latest and greatest.
helm repo update

# Per documentation, needed before upgrades
#kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

# This is an Upgrade/Install - it works in either situation.
# NOTE: an IRSA enabled SA named "aws-load-balancer-controller" will already exist because eksctl created it for us!
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$PREFIX \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller 
  
  # NOTE: If you've disabled IMDS you'll need to set vpcId and region manually
  # To see how these are used, : helm pull --untar eks/aws-load-balancer-controller
  #--set vpcId=vpc-0cda5b646c7936be5 \
  #--set region=us-east-2 
  
  # If you want a specific AWS LB version (like 1.4.8 - uncomment this line)
  # Don't forget to include a command continuation char like the above lines
  #--version 1.4.8 
 
  
sleep 15

kubectl get deployment -n kube-system aws-load-balancer-controller
  
echo "AWS Load Balancer Controller Setup Done."
 