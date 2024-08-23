#!/bin/bash

# 
echo " ***** "
echo "This will install: eksctl, helm, and kubectl."
echo " ***** " 

# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

#
# Download eksctl and install it
# https://eksctl.io/installation/
#
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

eksctl version

#
# Install helm also - will need for aws lb controller install
#
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm version

#
# Need kubectl so eksctl create cluster doesn't fail
#
./install-kubectl.sh

# Other recommended stuff
# We're appending it to bashrc so it will take effect in all future sessions.
cat <<EoF >> ~/.bashrc
alias c=clear
alias k=kubectl
# Put 00-setup folder in the path to make it easy to run fix-blank-session.sh
export PATH=$PATH:$HOME/environment/coreks/00-setup
EoF


echo " ***** "
eksctl version
kubectl version --client=true
helm version

./fix-blank-session.sh