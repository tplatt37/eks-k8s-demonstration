# Static Provisioning

NOTE: You MUST ensure the ebs-volume exists in the proper AZ first via:
```
 ./make-volume.sh "us-west-2a"
```

NOTE: the volume MUST be in the AZ of the worker node!

Then edit pv.yaml and modify the volumeHandle

You must also modify pod.yaml and update the nodeName to be one of the worker nodes in the same AZ.  It doesn't seem that the scheduler can figure this out on it's own.

Run these steps:
```
k apply -f pv.yaml
k get pv
k apply -f pvc.yaml
k get pv,pvc
k apply -f pod.yaml
k get pv,pvc,pod
```


When done, you can clean up with:
```
./cleanup.sh
```