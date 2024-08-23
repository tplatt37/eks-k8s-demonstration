#!/bin/bash


REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

# NOTE: if you invoke with --yes it will skip these "Are you sure?" prompts
if [[ $1 != "--yes" ]]; then
    read -p "This will delete the ECR Repo hello-world-nodejs in $REGION. Are you sure? (Yy) " -n 1 -r
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


# Create an ecr private repository named "hello-world-nodejs"
aws ecr delete-repository --repository-name hello-world-nodejs --region $REGION --force

