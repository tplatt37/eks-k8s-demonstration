#!/bin/bash

#
# Tutorial: Create and mount an AWS Secrets Manager secret in an Amazon EKS pod
# https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver_tutorial.html
#
# See also:
# https://github.com/aws/secrets-store-csi-driver-provider-aws
#

REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}

if [ -z "${REGION}" ]; then
    echo "No region set, exiting..."
    echo "Please set the AWS_DEFAULT_REGION environment variable, or run 'aws configure'"
    exit 1
fi

CLUSTERNAME=eks-demo
echo "CLUSTERNAME=$CLUSTERNAME"

SUFFIX=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 5 | head -n 1)
echo "SUFFIX=$SUFFIX"

# We "remember" certain things for subsequent scripts using this simple state file.
echo "SUFFIX=$SUFFIX" > state.txt

SECRET_NAME="MySecret-$SUFFIX"
echo "SECRET_NAME=$SECRET_NAME"
echo "SECRET_NAME=$SECRET_NAME" >> state.txt

SECRET_ARN=$(aws --region "$REGION" secretsmanager  create-secret --name $SECRET_NAME --secret-string '{"username":"lijuan", "password":"hunter2"}' --query "ARN" --output text)
echo "SECRET_ARN=$SECRET_ARN"
echo "SECRET_ARN=$SECRET_ARN" >> state.txt

POLICY_ARN=$(aws --region "$REGION" --query Policy.Arn --output text iam create-policy --policy-name nginx-deployment-policy-$SUFFIX --policy-document '{
    "Version": "2012-10-17",
    "Statement": [ {
        "Effect": "Allow",
        "Action": ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
        "Resource": ["'$SECRET_ARN'"]
    } ]
}')
echo $POLICY_ARN
echo "POLICY_ARN=$POLICY_ARN" >> state.txt

eksctl create iamserviceaccount --name nginx-deployment-sa --region="$REGION" --cluster "$CLUSTERNAME" --attach-policy-arn "$POLICY_ARN" --approve --override-existing-serviceaccounts