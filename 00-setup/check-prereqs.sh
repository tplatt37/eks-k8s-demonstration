#!/bin/bash

#
# This checks for various pre-requisites
#
EXIT_CODE=0

echo "Checking for pre-requisites..."

# Check AWS CLI version - must be v2.
AWS_CLI_VERSION=$(aws --version | awk '{print $1}' | awk -F/ '{print $2}' | awk -F. '{print $1}')
if [[ $AWS_CLI_VERSION -lt 2 ]]; then
    echo "You must install AWS CLI v2 to use this script."
    echo "You should probably UNINSTALL AWS CLI V1: https://docs.aws.amazon.com/cli/v1/userguide/install-linux.html#install-linux-pip"
    echo " and then "
    echo " INSTALL AWS CLI V2: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    EXIT_CODE=1
fi

command -v docker 1>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Please install docker."
    EXIT_CODE=1
fi

command -v kubectl 1>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Please install kubectl."
    EXIT_CODE=1
fi

MAJOR_VERSION=$(kubectl version --client | grep "Client Version:" | awk '{print $3}' |awk -F. '{print $1}')
#echo "MAJOR_VERSION=$MAJOR_VERSION"

MINOR_VERSION=$(kubectl version --client | grep "Client Version:" | awk '{print $3}' | awk -F. '{print $2}')
#echo "MINOR_VERSION=$MINOR_VERSION"

if [[ $MAJOR_VERSION -ne "v1" ]] || [[ $MINOR_VERSION -lt 28 ]]; then
    echo "You must have kubectl v1.28 or newer to use this script."
    EXIT_CODE=1
fi

command -v helm 1>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Please install helm."
    EXIT_CODE=1
fi

command -v eksctl 1>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Please install eksctl."
    EXIT_CODE=1
fi

# jq *should* be pre-installed on Cloud9 - but in case someone is running this elsewhere...
command -v jq 1>/dev/null
if [[ $? -ne 0 ]]; then
    echo "Please install jq."
    EXIT_CODE=1
fi

# Must be this version or newer! Output will be like 0.166.0 
EKSCTL_VERSION=$(eksctl version | cut -d '.' -f 2) 
#echo "EKSCTL_VERSION=$EKSCTL_VERSION"
if [[ $EKSCTL_VERSION < 170 ]]; then
    echo "Please install eksctl v0.170.0 or newer."
    EXIT_CODE=1
fi

if [[ EXIT_CODE -eq 0 ]]; then
    echo "No missing pre-requisites found."
else
    echo "Missing pre-requisites. Please take the suggested action."
fi

exit $EXIT_CODE