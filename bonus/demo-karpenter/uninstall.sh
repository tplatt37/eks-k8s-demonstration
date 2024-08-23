#!/bin/bash

#
# This is meant to delete / cleanup anything we created to use with Karpenter
#

# It DOES NOT RESTORE CLUSTER AUTOSCALER on the EKS cluster!
# It DOES NOT :
#  remove tags from subnets
#  remove tags from security groups
#  remove tags from nodes

CLUSTER_NAME=eks-demo
KARPENTER_NAMESPACE=karpenter

# NOTE: if you invoke with --yes it will skip these "Are you sure?" prompts
if [[ $1 != "--yes" ]]; then
    read -p "This will delete the $KARPENTER_NAMESPACE namespace in cluster $CLUSTER_NAME and the IAM Roles needed for Karpenter. It will also terminate any running nodes created by Karpenter. Are you sure? (Yy) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
    
    read -p "Are you sure you are sure???? (Yy) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
fi


# Delete Karpenter namespace.  We don't want more nodes popping up while trying to uninstall
kubectl delete ns $KARPENTER_NAMESPACE --force

# Check for Karpenter nodes and terminate them
NODES=$(aws ec2 describe-instances --filters "Name=tag:karpenter.sh/managed-by,Values=${CLUSTER_NAME}" --query "Reservations[].Instances[].InstanceId" --output text)
ARRAY=($NODES)
for N in "${ARRAY[@]}"
do
    echo "Terminating $N... (A Karpenter created node)"
    aws ec2 terminate-instances --instance-ids $N
done


# Really should wait intelligently for them to be terminated, but sleeping 120 seconds is easier.
echo "Waiting 120 seconds for Karpenter created nodes to be terminated..."
sleep 120

ROLE_NAME="KarpenterNodeRole-${CLUSTER_NAME}"
echo "ROLE_NAME=$ROLE_NAME"

POLICIES=$(aws iam list-attached-role-policies --role-name $ROLE_NAME --query "AttachedPolicies[*].PolicyArn" --output text )
echo "Removing all policies attached to $ROLE_NAME"
# This is important because we might've added app specific policies, or CloudWatch, etc.
ARRAY=($POLICIES)
for P in "${ARRAY[@]}"
do
    echo "Detaching $P..."
    aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn $P
done

# Find all instance profiles using this role
# aws iam delete-instance-profile 
PROFILES=$(aws iam list-instance-profiles-for-role --role-name KarpenterNodeRole-eks-demo --query "InstanceProfiles[].InstanceProfileName" --output text)

ARRAY=($PROFILES)
for P in "${ARRAY[@]}"
do
    echo "Removing role from instance profile $P..."
    aws iam remove-role-from-instance-profile --instance-profile-name $P --role-name KarpenterNodeRole-eks-demo
    echo "Delete instance profile $P..."
    aws iam delete-instance-profile --instance-profile-name $P
done

# THEN we can delete the role.
aws iam delete-role --role-name $ROLE_NAME 

ROLE_NAME="KarpenterControllerRole-${CLUSTER_NAME}"
echo "ROLE_NAME=$ROLE_NAME"

POLICIES=$(aws iam list-attached-role-policies --role-name $ROLE_NAME --query "AttachedPolicies[*].PolicyArn" --output text )
echo "Removing all policies attached to $ROLE_NAME"
# This is important because we might've added app specific policies, or CloudWatch, etc.
ARRAY=($POLICIES)
for P in "${ARRAY[@]}"
do
    echo "Detaching $P..."
    aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn $P
done

# INLINE POLICY
aws iam delete-role-policy --role-name $ROLE_NAME --policy-name "KarpenterControllerPolicy-${CLUSTER_NAME}" 

# THEN we can delete the role.
aws iam delete-role --role-name $ROLE_NAME 
