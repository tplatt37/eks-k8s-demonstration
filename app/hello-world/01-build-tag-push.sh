#!/bin/bash

# Build a v1.0.0, v2.0.0, and v3.0.0 of this app - for install/upgrade/rollback demos

# Get the current AWS REGION
REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

# Get the current AWS ACCOUNT ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Authenticate to private repo
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build / Tag / Push
VERSION="v1.0.0"
./customize.sh $VERSION black yellow

docker build -t hello-world-nodejs .

docker tag hello-world-nodejs:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/hello-world-nodejs:$VERSION

docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/hello-world-nodejs:$VERSION

# Build / Tag / Push
VERSION="v2.0.0"
./customize.sh $VERSION white blue

docker build -t hello-world-nodejs .

docker tag hello-world-nodejs:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/hello-world-nodejs:$VERSION

docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/hello-world-nodejs:$VERSION

# Build / Tag / Push
VERSION="v3.0.0"
./customize.sh $VERSION blue orange

docker build -t hello-world-nodejs .

docker tag hello-world-nodejs:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/hello-world-nodejs:$VERSION

docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/hello-world-nodejs:$VERSION
