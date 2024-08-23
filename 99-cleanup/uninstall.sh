#!/bin/bash

PREFIX="eks-demo"

REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

if [ -z "${REGION}" ]; then
    echo "No region set, exiting..."
    echo "Please set the AWS_DEFAULT_REGION environment variable, or run 'aws configure'"
    exit 1
fi

# NOTE: if you invoke with --yes it will skip these "Are you sure?" prompts
if [[ $1 != "--yes" ]]; then
    read -p "This will delete the $PREFIX cluster in $REGION, the a-new-startup-dev stack, and a-new-startup ECR repo, and the student IAM role. Are you sure? (Yy) " -n 1 -r
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

~/environment/coreks/00-setup/fix-blank-session.sh

# Make sure SVC / LBs go away.
# (But eksctl will take care of this too)
helm uninstall myrelease 

eksctl delete cluster --name $PREFIX --region $REGION

# Also..
# delete cloudformation stack a-new-startup-dev
aws cloudformation delete-stack --stack-name a-new-startup-dev --region $REGION

# delete ecr a-new-startup
aws ecr delete-repository --repository-name a-new-startup --region $REGION --force

aws iam delete-role --role-name student