#!/bin/bash

ARGUMENT=$1

ARN=${ARGUMENT:-$(aws sts get-caller-identity --query Arn --output text)}
echo "ARN=$ARN"

eksctl create iamidentitymapping \
 --cluster eks-demo \
 --arn $ARN \
 --group system:masters \
 --username admin
