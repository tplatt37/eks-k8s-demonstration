#!/bin/bash

AWS_REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

if [ -z "${AWS_REGION}" ]; then
    echo "No region set, exiting..."
    echo "Please set the AWS_DEFAULT_REGION environment variable, or run 'aws configure'"
    exit 1
fi

KARPENTER_NAMESPACE=kube-system
CLUSTER_NAME=eks-demo

AWS_PARTITION="aws" # if you are not using standard partitions, you may need to configure to aws-cn / aws-us-gov
OIDC_ENDPOINT="$(aws eks describe-cluster --name "${CLUSTER_NAME}" \
    --query "cluster.identity.oidc.issuer" --output text)"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' \
    --output text)

# Dynamically determine k8s version using kubectl
export K8S_VERSION=$(kubectl version | grep 'Server Version:' | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' | cut -d. -f1,2)
echo "K8S_VERSION=$K8S_VERSION"

# Get the manifest YAML for aws-auth
kubectl get cm aws-auth -n kube-system -o yaml > aws-auth.yaml


sed "/  mapRoles: |/a \    - groups:\n      - system:bootstrappers\n      - system:nodes\n      rolearn: arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}\n      username: system:node:{{EC2PrivateDNSName}}" aws-auth.yaml > aws-auth-updated.yaml

# Apply it!
kubectl apply -f aws-auth-updated.yaml