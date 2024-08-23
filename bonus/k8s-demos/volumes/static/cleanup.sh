#
# Cleanup!
#
#

if [ -z $1 ]; then
  echo "Must pass in volume id!"
  exit 1
fi

sleep 5
kubectl delete pod/my-pod --force
sleep 5
kubectl delete pvc/ebs-statically-provisioned-claim
sleep 5
kubectl delete pv/my-statically-provisioned-pv
sleep 5

# We have to do this because the PV is set to "Retain"
echo "Deleting EC2 volume $1..."
aws ec2 delete-volume --volume-id $1

echo "Done."