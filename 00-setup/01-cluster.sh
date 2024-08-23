#!/bin/bash

./check-prereqs.sh
if [[ $? -ne 0 ]]; then
    echo "Missing prerequisites... exiting..."
    exit 1
fi

./fix-blank-session.sh

#
# This helps to ensure that the cluster is created with the correct identity
# And that the user has TURNED OFF MANAGED TEMPORARY CREDENTIALS in Cloud9
#
IDENTITY=$(aws sts get-caller-identity --query "Arn" --output text)
echo -e "\033[1;33m ****************************************************** \033[0m"
echo -e "\033[1;33m ****************************************************** \033[0m"
echo -e "\033[1;33m ********************** WARNING *********************** \033[0m"
echo " "
echo "    Cluster will be created using $IDENTITY"
echo "  If this is not correct, you have 20 seconds to cancel (Ctrl+c)..."
echo " "
echo -e "\033[1;33m ****************************************************** \033[0m"
echo -e "\033[1;33m ****************************************************** \033[0m"
sleep 20


eksctl create cluster -f cluster.yaml