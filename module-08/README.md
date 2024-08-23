# Demo - Storage

Module 8 - Example: Amazon EBS Storage Class (Slide 24)

The best demo for this module is to show the nature of DYNAMIC Provisioning via a Storage Class. 

They'll work with EFS CSI driver in the lab, so we'll use EBS CSI here.

First, create a Storage Class:
```
cd ~/environment/coreks/module-08
k apply -f sc.yaml
k get sc
```

You are NOT going to create a PV directly.  We want to show the more popular DYNAMIC provisioning vs STATIC provisioning.

Let's create a PVC 
```
k apply -f pvc.yaml
k get pvc
```

Observe that there's still NO PV:
```
k get pv
```

Let's create a Pod that references the PVC - THIS will trigger the Dynamic Provisioning (and attachment of the EBS volume to the Worker Node upon which the Pod Replica is running)
```
k apply -f pod.yaml
watch kubectl get po,pv,pvc
```
NOTE: It will take a moment for the EBS Volume to come into existence. The pod will be in Pending a bit more than usual.

You can also show the EBS volume in the EC2 console. Look for the 9GiB GP3 volume.

Lastly, if we exec into the container, we'll see there's a /data path:
```
k exec -it po/ebs-demo -- /bin/sh
df -h
ls -lha /data
exit
```

When done:
```
k delete -f pod.yaml
```

Is the PV still there? It will be until the PVC is deleted too! It's set to "Delete" reclaim policy, so the EBS CSI Controller will get rid of it in a bit.
```
k get pv
```

```
k delete -f pvc.yaml
```

The PV should disappear shortly...
```
k get pv
```
