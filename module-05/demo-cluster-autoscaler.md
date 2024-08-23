# Demo - Cluster Autoscaler.

Module 5 - After slide 26 (before we move on to Karpenter)


Can we demonstrate the Cluster Autoscaler? 

You bet.

Modify the hpa.yaml to have a CPU target of 1% instead of 30%
(This is rediculously low , by the way, but makes for a nice dramatic demo)
Update the HPA:
```
k apply -f hpa.yaml
```

Generate load again:
```
k apply -f load-generator.yaml
```

The Deployment will scale OUT - but it will hit a limit at some point (CPU/MEM/IP) and then the Cluster Autoscaler will see Pods stuck in PENDING ("Unschedulable") , and it will add nodes.

This will show you the number in Pending
```
k get po | grep Pending | wc -l
```

Pick any pod that is Pending and "describe" it. The Events should tell you what the issue is:

```
k describe po -n default po/NAME 
```

In the "Events" section, you will likely see "Insufficient cpu"
But there's other things we can run out of: IPs (Each pod needs it's own IP), Memory, Diskspace, etc.

NOTE: If you go check the EC2 ACTUAL CPU - it won't be very high.  Recall that we are REQUESTing .2 vCPU for each pod.  That's like a "reservation" - so "insufficient cpu" means k8s has run out of "available" CPU.  All the CPU is already spoken for.

Show the new nodes in EC2 console (EC2/ASG section) or via:
```
k get no
```

It will probably add nodes until it hits the Auto Scaling Group (ASG) Maximum (which is 4), so you can bump that up too (You can edit that via the console).

When done, kill the load-generator, and the pods will scale in, then the cluster (This will take a long time - so just explain it)

```
kubectl delete deploy/load-generator --force
```
