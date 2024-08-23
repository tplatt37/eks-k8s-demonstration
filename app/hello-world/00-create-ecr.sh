#!/bin/bash

#
# Create a private ECR repo in the current region
#

# Get the current AWS REGION
REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

# Get the current AWS ACCOUNT ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create an ecr private repository named "hello-world-nodejs"
aws ecr create-repository --repository-name hello-world-nodejs --region $REGION
