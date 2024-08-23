# Demo - Horizontal Pod Autoscaler 

Module 5 - Slide "Horizontal Pod Autoscaler" (Slide 6)

Change directories:
```
cd ~/environment/coreks/module-05
```

Show the Deployment YAML. Show that it has Requests = 200m = .2 vCPU

Note also that replicas is NOT SPECIFIED - we want the HPA to control that!

Create the Deployment, and note that there isn't anything exciting happening yet:
```
k apply -f deployment.yaml
k get all
```

Now, create the HPA. This should quickly get us the MINIMUM of 2 replicas:
```
k apply -f hpa.yaml
sleep 10
k get all 
```

You can "get" the HPA to see it's current status:
```
k get hpa
```

NOTE The "TARGETS" column - should show little to no CPU load.

Further autoscaling won't happen until we GENERATE SOME LOAD. This will spin up multiple pods that will hammer the service in an endless (tight) loop - and drive up CPU.
```
k apply -f load-generator.yaml
```

Run this and watch the scaling happening:
```
watch kubectl get all
```


You should see more and more Pod replicas - until the CPU target is reached.
Hit Ctrl+C when it reaches the target - which should happen in a minute or two.

When done, kill the load generator pod. The Deployment will scale back in.
```
kubectl delete deploy/load-generator --force
```

NOTE: The "scale in" is pretty conservative, I wouldn't sit and wait for it.