#
# The AWS CNI is responsible for:
# IPAM - IP Address Management - getting the VPC IPs needed for pods , and associating them with ENIs on the worker nodes
# and also wiring up the local connectivity for the Pod/Containers to be reachable via the Host
#
# Documented here:
# https://github.com/aws/amazon-vpc-cni-k8s/blob/master/docs/cni-proposal.md
#
#
# To find a Pod for this demo:
k describe no

# (Find the pod from the list of pods running on each node. You need to know the worker node it's running on!)
# Also look at the labels and make a note of the instance ID.
#
#

# Assuming you have a Pod you want to use, run a bash shell IN THE POD:

k exec -it po/PODNAME -n a-new-startup -- /bin/bash

# Show the IP
ip a
ip link
ip route

# Then, SSH into the worker node where this is running

aws ssm start-session --target INSTANCEID

# Show the pod is running here:
docker ps | grep PODNAME

# Note there will be a pause container (always) - that holds the network namespace

# Show the links
ip link show

# THese are the VETHs:
ip -c link show type veth

# Show the routes:
ip route show

# Note that the IP for the Pod is listed somewhere with the VETH name (This is the host side of the VETH Pair)
# This is how the host hands traffic destined for the Pod to the pod.

# NOTE: You can't see the Network Namespace using ip netns list, because Docker doesn't setup the symlink for this to work, but 
# The Pod is using it's own Network Namespace.