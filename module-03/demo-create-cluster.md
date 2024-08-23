#

Module 3 - Demonstration - Deploying a cluster


Run the following to create another, new , different cluster in us-east-1:
```
cd ~/environment/coreks/module-03
eksctl create cluster -f cluster.yaml
```

NOTE: This config file is SIMILAR not IDENTITICAL to the example in the slides.

NOTE: While this is running your context WILL be switched (by eksctl) to this NEW CLUSTER.

After it installs fully, you'll need to switch back:
```
k config get-contexts
k config use-context arn:...
```

When it's done, consider showing all the stuff that EKSCTL created.  The easy way is go show the CFN Stacks / Resources - VPC, ServiceRole, cluster, node groups, etc.

When done, you can easily clean it all up with:
```
eksctl delete cluster --name MySecondEKScluster --region us-east-1
```

NOTE: Name is case sensitive!