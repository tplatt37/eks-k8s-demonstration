# Karpenter

Want to show Karpenter?  Let's do an MIGRATION from Cluster Autoscaler to Karpenter 

This is perfect for showing Karpenter AFTER you show the regular Cluster Autoscaler.

# Install 

WARNING: This is a one-way door.   This command will scale down the cluster autoscaler, then install and configure the Karpenter autoscaler.  
```
cd ~/environment/coreks/bonus/demo-karpenter
./migrate-to-karpenter.sh
```

When done, check for Karpenter deployment:
```
kubectl get all -n karpenter
```

Then, simply perform any autoscaling demo that you wish to do.

# Uninstall

The uninstall will stop Karpenter from running, terminate any Karpenter created nodes (possibly disrupting workload) and then remove the IAM roles/policies created.

The assumption is that you are going to stop using the cluster shortly thereafter.
```
./uninstall.sh
```

The uninstall DOES NOT restore cluster autoscaler to working condition - allthough that's probably as easy as just scale the deployment back out (not tested):
```
kubectl scale deploy/cluster-autoscaler -n kube-system --replicas 1
```