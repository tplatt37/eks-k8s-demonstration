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

# Pull in uniqe values from when we installed...
source state.txt

#
# Download the YAML examples from the GitHub repo so they are easy to review.
# ALSO - we have to update "MySecret" to be whatever our dynamic Secret Name is
#
wget -O providerclass.yaml https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/examples/ExampleSecretProviderClass.yaml

# Replace "MySecret" with the dynamic Secret Name we created above.
sed -i "s/MySecret/$SECRET_NAME/g" providerclass.yaml

wget -O deployment.yaml https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/examples/ExampleDeployment.yaml


kubectl apply -f providerclass.yaml
kubectl apply -f deployment.yaml    

echo " "
echo " " 
echo "Run the following to show the secret in the pod:"
echo " "
echo 'kubectl exec -it $(kubectl get pods | awk '"'"'/nginx-deployment/{print $1}'"'"' | head -1) -- cat /mnt/secrets-store/'$SECRET_NAME'; echo'
echo " " 
echo " " 