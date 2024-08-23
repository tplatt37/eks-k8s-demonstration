# Deploy applications with Helm

Demonstration - Deploying applications with Helm (Slide 21)

# Show the Helm chart

Let's get this app running the right way - installed with a Service, ConfigMap, PodDisruptionBudget, Deployment, etc - all the "bells and whistles"

Run these commands:
```
cd ~/environment/coreks/app/a-new-startup/helm
k delete deploy/a-new-startup -n default --force
```

Show the contents of the "a-new-startup-amd64" folder.

Hightlight the fact that beyond just the Deployment and a Service we have:
multiple Services (not really needed, but for the networking module)
ConfigMap,
Pod Disruption Budget, ()
etc.

EDIT the values.yaml to have your URI and TAG, and REGION. Please note these settings are on THREE DIFFERENT LINES.  Save the file. 

Install :
```
k get all
helm install myrelease a-new-startup-amd64 
```

```
k get all 
```

Talk a bit, and after about 3-4 minutes you can pull up the NLB. You might want to give a glimpse of AWS LB Controller - or show over in the EC2 console that an NLB is being provisioned.
```
k get svc 
```
Grab the external URL and open it as HTTP:// (NOT HTTPS!)

Can we UPGRADE this existing installation? Yes, try changing the values.yaml Replicas count to 12, save, then run:
```
helm upgrade --install myrelease a-new-startup-amd64
k get all
```

Now there's 12 replicas!

Show that Helm REMEMBERS the last 10 installs:
```
helm ls 
helm history myrelease
```

Please also note that you can "helm uninstall" to remove ALL the resources that were created. It's not essential to demonstrate that, and we'll need this app install later.


# OPTIONAL

NOTE: Helm's ability to rollback is also impressive.  They will use this capability in the lab, but you can make some sort of simple change to the manifest templates, and then deploy, and then show a rollback, etc.

If you want to rollback to v1:
```
helm rollback myrelease 1
k get all
helm history myrelease
```

It should be back to 6 replicas.

They will do an "upgrade" in the Lab.

# Finally

You probably want to UNINSTALL all that stuff, so the default namespace is nice and clear for the next module:
```
helm uninstall myrelease
k get all
```

And it's all gone!