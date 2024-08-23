# Static Provisioning Demo
# Creates a volume in the AZ of your choice (defaults to us-west-2a)
#
if [ -z $1 ]; then
  AZ="us-west-2a"
else
  AZ=$1
fi

export VOLUME_ID=$(aws ec2 create-volume --availability-zone=$AZ --size=4 --volume-type=gp2 --tag-specifications 'ResourceType=volume,Tags=[{Key=demo,Value=eks-volume},{Key=Name,Value=eks-volume}]' --output text --query "VolumeId")
echo "VOLUME_ID=$VOLUME_ID"

aws ec2 describe-volumes --volume-ids $VOLUME_ID