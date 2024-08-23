#!/bin/bash
# Run this as :  . ./switch.sh ARN
# Must "source" it so that ENV VARS exist in the parent shell

CREDENTIALS=$(aws sts assume-role --role-arn $1 --role-session-name eks001 --output json --duration-seconds 1800)

# 3) Set AWS Assumed Role Credentials on ENV
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=`echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId'`
export AWS_SECRET_ACCESS_KEY=`echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey'`
export AWS_SESSION_TOKEN=`echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken'`
export AWS_EXPIRATION=`echo ${CREDENTIALS} | jq -r '.Credentials.Expiration'`

echo "Role assumed:"
aws sts get-caller-identity
