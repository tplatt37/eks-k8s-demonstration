#!/bin/bash

REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

if [ -z "${REGION}" ]; then
    echo "No region set, exiting..."
    echo "Please set the AWS_DEFAULT_REGION environment variable, or run 'aws configure'"
    exit 1
fi

CLUSTERNAME=eks-demo
echo "CLUSTERNAME=$CLUSTERNAME"

# Pull in uniqe values from when we installed...
source state.txt

# Delete the k8s objects 
kubectl delete -f deployment.yaml
kubectl delete -f providerclass.yaml

sleep 10

# Delete the IRSA SA
eksctl delete iamserviceaccount --name nginx-deployment-sa --cluster $CLUSTERNAME

echo "Deleting $SECRET_ARN"
aws secretsmanager delete-secret --secret-id $SECRET_ARN --recovery-window-in-days 7

# Wait a bit to ensure CloudFormation stack is gone, otherwise policy delete might fail...
echo "Sleeping 60 seconds to ensure stack is gone..."
sleep 60 

echo "Deleting $POLICY_ARN"
aws iam delete-policy --policy-arn $POLICY_ARN

