#!/bin/bash


# Ref: https://karpenter.sh/docs/getting-started/migrating-from-cas/
#
# NOTE: Had to rework quite a few things to get this to work
#

AWS_REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

if [ -z "${AWS_REGION}" ]; then
    echo "No region set, exiting..."
    echo "Please set the AWS_DEFAULT_REGION environment variable, or run 'aws configure'"
    exit 1
fi
echo "AWS_REGION=$AWS_REGION"

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


ARM_AMI_ID="$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/${K8S_VERSION}/amazon-linux-2-arm64/recommended/image_id --query Parameter.Value --output text)"
AMD_AMI_ID="$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/${K8S_VERSION}/amazon-linux-2/recommended/image_id --query Parameter.Value --output text)"
GPU_AMI_ID="$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/${K8S_VERSION}/amazon-linux-2-gpu/recommended/image_id --query Parameter.Value --output text)"



#
# Add tags to subnets and security groups
#

for NODEGROUP in $(aws eks list-nodegroups --cluster-name "${CLUSTER_NAME}" --query 'nodegroups' --output text); do
    echo "NODEGROUP=$NODEGROUP" 

    SUBNETS_SPACE_DELIMITED=$(aws eks describe-nodegroup --cluster-name "${CLUSTER_NAME}" --nodegroup-name "${NODEGROUP}" --query 'nodegroup.subnets' --output json | jq -r 'join(" ")' )
    echo "SUBNETS_SPACE_DELIMITED=$SUBNETS_SPACE_DELIMITED"

    aws ec2 create-tags \
        --tags "Key=karpenter.sh/discovery,Value=${CLUSTER_NAME}" \
        --resources $SUBNETS_SPACE_DELIMITED
done

# Add tags to security groups
NODEGROUP=$(aws eks list-nodegroups --cluster-name "${CLUSTER_NAME}" \
    --query 'nodegroups[0]' --output text)

LAUNCH_TEMPLATE=$(aws eks describe-nodegroup --cluster-name "${CLUSTER_NAME}" \
    --nodegroup-name "${NODEGROUP}" --query 'nodegroup.launchTemplate.{id:id,version:version}' \
    --output text | tr -s "\t" ",")
echo "LAUNCH_TEMPLATE=$LAUNCH_TEMPLATE"

# If your EKS setup is configured to use only Cluster security group, then please execute -

#SECURITY_GROUPS=$(aws eks describe-cluster \
#   --name "${CLUSTER_NAME}" --query "cluster.resourcesVpcConfig.clusterSecurityGroupId" --output text)
#
# If your setup uses the security groups in the Launch template of a managed node group, then :

SECURITY_GROUPS="$(aws ec2 describe-launch-template-versions \
    --launch-template-id "${LAUNCH_TEMPLATE%,*}" --versions "${LAUNCH_TEMPLATE#*,}" \
    --query 'LaunchTemplateVersions[0].LaunchTemplateData.[NetworkInterfaces[0].Groups||SecurityGroupIds]' \
    --output text)"
echo "SECURITY_GROUPS=$SECURITY_GROUPS"

aws ec2 create-tags \
    --tags "Key=karpenter.sh/discovery,Value=${CLUSTER_NAME}" \
    --resources "${SECURITY_GROUPS}"
