#!/bin/bash

ROLE_NAME="student"
TRUST_POLICY_FILE="trust-policy.json"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

cat > ${TRUST_POLICY_FILE} <<EoF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${ACCOUNT_ID}:root"
            },
            "Action": "sts:AssumeRole"
            }
        ]
}
EoF

aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://$TRUST_POLICY_FILE

rm $TRUST_POLICY_FILE

