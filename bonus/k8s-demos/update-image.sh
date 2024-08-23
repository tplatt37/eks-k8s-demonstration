#!/bin/bash

#
# This helper script will find any account specific Image URIs and update them with:
# Your AWS ACCOUNT ID
# Your current region
#

# Get the current AWS REGION
REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

# Get the current AWS ACCOUNT ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "Changing 123456789012 to $AWS_ACCOUNT_ID and us-east-1 to $REGION in all manifests..."

# NOTE: We DO NOT update this file (update-image.sh) 
find . -type f -not -name 'update-image.sh' -exec sed -i "s/123456789012/$AWS_ACCOUNT_ID/g" {} +
find . -type f -not -name 'update-image.sh' -exec sed -i "s/us-east-1/$REGION/g" {} +

echo "Done."