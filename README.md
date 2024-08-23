# COREKS DEMOS - v2.1.3

This package will create a simple EKS cluster for teaching the COREKS 2.0 class.

It uses eksctl, helm, and kubectl - plus a little extra cloudformation for a full-featured demonstration app.


# Cloud9

It is assumed you are using this on Cloud9 (see Appendix for how to use EC2 or CloudShell instead).  In either case, you should be using Amazon Linux 2023.

Do the following to prepare the Cloud9 Environment:

1. Setup a Cloud9 instance in the Console:
* Region us-west-2 
* Use Amazon Linux 2023.  
* Use ".large" size instance.
* Use SSM settings (So it gets patched!).
* Launch into an existing Public subnet of your choosing.

2. Open the Cloud9 instance. Under Settings (gear icon on the right) -> "AWS Settings", turn OFF the "AWS managed temporary credentials"

3. Use "aws configure" to:
* Configure an Access Key and Secret Access Key.
* Set the default region to us-west-2 (It will work in other regions, but let's keep things simple)

4. Confirm "Who" you are by running:
```
aws sts get-caller-identity
```
5. The above identity will be the cluster admin

6. Copy over the coreks*.zip file and unzip using the linux command. Assuming you have been given a Pre-Signed S3 URL for download, do the following:
```
cd ~/environment
wget -O coreks.zip "PRESIGNED_S3_URL_IN_DOUBLE_QUOTES"
unzip coreks.zip
```

NOTE: DO NOT unzip on Windows. It will strip the POSIX file permissions.  Copy the .zip file to Cloud9, then unzip using "unzip"!

Also, consider copying the original zip file to a bucket of your own, because that Presigned URL will expire soon:
```
aws s3 cp coreks.zip s3:\\SOME_BUCKET_YOU_HAVE
```

# Install

ASSUMING you have unzipped the coreks file, from a terminal, run the following:

This will install eksctl (REQUIRED), helm (REQUIRED), and kubectl (REQUIRED)
```
cd ~/environment/coreks/00-setup
./00-tools.sh
```

"Source" the .bashrc file to make sure some shortcut aliases (like "k" for kubectl) are active:
```
source ~/.bashrc
```

Run the "alias" command - to confirm what other aliases might be availble:
```
alias
```

Review cluster.yaml file. 
Then, create the cluster.  (This is done via eksctl and will take 25-30 minutes, see script for details):
```
./01-cluster.sh
```
eksctl is doing 99% of the work for us.  See "cluster.yaml" for details.

The cluster will be named "eks-demo" and will be in us-west-2

Make sure everything is in order:
```
k get po -A
```

(This is "kubectl get pods --all-namespaces")

If you get ANY SORT OF ERROR, run this:

```
./fix-blank-session.sh
```

Then, re-run the kubectl command.  (Congratulations, you've experienced the Cloud9 Blank Session Token line bug.  It'll happen again eventually, but the above command fixes it.)

Go ahead and "cat" out that file to see how it works (it's a sed "Stream Editor" command. It is simply DELETING the bad line)
```
cat ./fix-blank-session.sh
```

Next add key components that we will need for demos:

Metrics Server (needed for the Cluster Autoscaler)
```
./02-metrics-server.sh
```

Cluster Autoscaler
```
./03-cluster-autoscaler.sh
```

AWS Load Balancer Controller:
```
./04-lb-controller.sh
```

Observe that all 3 things are now running in kube-system namespace:
```
k get po -n kube-system
```

NOTE: Whichever IAM identity you are using to run the above will have permanent admin permissions on the cluster. To add another IAM Role/User as a cluster admin, use this helper script:
```
./addl-admin.sh arn:aws:iam::123456789012:role/developer
```
(The above is a custom IAM role - you must pre-create that)

or (for an IAM User)
```
./addl-admin.sh arn:aws:iam::123456789012:user/developer
```

Also remember, you can initialize the "kubeconfig" (~/.kube/config) file easily on ANY MACHINE with:
```
aws eks update-kubeconfig --name eks-demo --region us-west-2
```

It is also recommended that you setup the CloudFormation stack that the demo app (used in the Application modules) will need:
```
cd ~/environment/coreks/app/a-new-startup
./01-create-iac.sh
```


# Demos

There is a directory for each Module of the course.  There are Markdown (.md) files and .yaml files explaining the demo steps.

# Karpenter Demo

There's an optional Karpenter demo in the bonus/demo-karpenter folder.

In the course, Cluster Autoscaler is discussed first, I consider that demo to be "required".

But, if you want to show Karpenter AFTERWARDS, you can run this command:
```
cd ~/environment/coreks/bonus/demo-karpenter
./migrate-to-karpenter.sh
```

Please note that will disable the Cluster Autoscaler, and configure and install Karpenter. You DO NOT want two autoscalers running at the same time!

You can then run the autoscaling demo of your choice, including re-running the one provided in module-05.

*IF* you use this Karpenter demo, you should run the Karpenter uninstaller before you delete the cluster:
```
cd ~/environment/coreks/bonus/demo-karpenter
./uninstall.sh
```

That uninstall *WILL* nuke any Karpenter nodes. Which will disrupt workloads.  So only run this right before you are going to get rid of the cluster.


# Bonus Content

There is a bonus directory that includes:
* Cloud9 info and utilities
* Advanced demos, such as Karpenter and ASCP
* k8s troubleshooting exercises
* k8s-demos - Additional manifests that demonstrate various kubernetes concepts. They don't necessarily relate to any of the course content.

I sometimes use these in a class *if* (*and only if*) someone asks about a CronJob, Job, etc.

# Cleanup

After class, run the following to cleanup.

NOTE: If you have run the optional karpenter demo, it is recommended to uninstall that first:
```
cd ~/environment/coreks/bonus/demo-karpenter
./uninstall.sh
```

THEN - delete the cluster itself.

NOTE: This will delete EVERYTHING eksctl created.  E.V.E.R.Y.T.H.I.N.G.

```
cd ~/environment/coreks/99-cleanup
./uninstall.sh 
```


hello-world-nodejs ECR Repo (if you went through the "bonus" k8s-demos)
```
cd ~/environment/coreks/app/hello-world
./uninstall.sh
```


# Appendix - Additional Information

## But ... I really, really don't want to use Cloud9

Ok, fine. You don't have to use Cloud9.   To use this package you will need:

1. Something that can run Bash scripts (MacOS, Linux, Windows + WSL, etc.)
2. Docker, Kubectl, Eksctl, Helm, and jq (You can get these running on pretty much anything)
3. Create a symlink so that the ~/environment path points to wherever you want to unzip the files.  "environment" is a cloud9 directory, and so the demo steps refer to it quite a bit:
```
ln -s ~/WHEREVER ~/environment
```

## Using an EC2 Instance or CloudShell instead of Cloud9

Did you know CloudShell is an Amazon Linux 2023 instance? 

It will have everything needed, the only thing missing is the "~/environment" directory.

To run on CloudShell:
```
cd ~
mkdir environment
cd environment
```

Then... just run the regular steps.  

NOTE: There is no "blank session token" issue with EC2 or CloudShell.  There is no need to turn off Temporary Credentials either.

The above will also work for an Amazon Linux 2023 EC2 instance also.

## Cloud9 Blank Session Token Bug

Cloud9 will randomly inject a blank aws_session_token line into your ~/.aws/credentials.

This happens whether you are using "Managed temporary credentials" or not.  Really. It doesn't matter

This blank line will cause kubectl to return permission issues, such as:
```
error: You must be logged in to the server (Unauthorized)
```

The blank line looks like this (in ~/.aws/credentials):
```
[default]
aws_access_key_id = AKIA2EXAMPLE12345678
aws_secret_access_key = IEXAMPLEEXAMPLEEXAMPLEEXAMPLEEXAMPLE9999
aws_session_token =
```

To fix the problem, you simply need to run the helper script (or edit the file to remove the blank line):
```
~/environment/coreks/00-setup/fix-blank-session.sh
```

If you ran 00-setup/00-tools.sh , you can simply run as follows, because it's in the PATH:
```
fix-blank-session.sh
```

# Region

For simplicity, we assume region us-west-2.

If you want to use a different region, you will need to change:
* 00-setup/cluster.yaml
** The region...
** ... and the availabilityZones

You will have to ensure the Region appears correctly in some of the Manifest YAML files and Helm Charts too.

It is possible to use this setup in more than one region, for instance you can have a "backup" environment in a different region.  You cannot install it more than one time per region (there will be naming conflicts)