# Helm Advanced Demo

This demo of helm shows the main RELEASE MANAGEMENT features:
* helm install
* helm upgrade
* helm ls
* helm history
* helm rollback
* helm uninstall

# Pre-requisistes

You must have built and pushed multiple versions of hello-world-nodejs (see bonus/hello-world)

# Demo

Let's install the "Hello World" application.

Show the contents of the helm directory under coreks/bonus/hello-world/helm

Install (from a local directory for simplicity)
```
cd ~/environment/coreks/app/hello-world/helm
```

Update the values.yaml using your preferred editor (Cloud9/vim/etc.)

You must set the "repository" values.yaml to YOUR hello-world-nodejs URI
Use tag of "v1.0.0"
Save the file.

NOTE: Technically, you should also ensure the Chart.yaml (the package metadata) reflects the app version being installed, so update "appVersion" to be "v1.0.0".  AND you technically should revise the package version too... then Save the file.

Then, you can install using:
```
helm install my-release hello-world-amd64
```

Show all the stuff that was created:
```
k get all
```

Show the service is up and running either using the NLB (takes 3-4 minutes) or using port-forward:
```
k port-forward svc/hello-world-clusterip 8080:80
(Open "Preview Running Application)
```

Note that the version displayed in the page is "v1.0.0"

Now, let's upgrade to version 2.0 - using helm.

Update the values.yaml file to use "tag" (values.yaml) of "v2.0.0" and appVersion (Chart.yaml) to "v2.0.0", and save
Then run:
```
helm upgrade my-release hello-world-amd64
```

Show the app again, now it's version 2.0 (A rolling update was done, so you MIGHT see v1.0.0 or v2.0.0 - but it'll settle on the new version eventually).

Helm defaults to keeping COMPLETE DETAILS of each version for up to 10 versions:
```
helm ls 
helm history my-release
```

Can we ROLLBACK to v1.0.0?  Yes - and it is easy?
```
helm rollback my-release 1
```

Can we ROLLBACK the ROLLBACK to v2.0.0? 
```
helm rollback my-release 2
```

Finally we can uninstall everything (deployments, services, etc.):
```
helm uninstall my-release
```

That's the power of Helm!

By the way - k8s itself tracks history of deployments but Helm is better for release management because it covers EVERYTHING in the templates folder (Deployments, Services, ConfigMaps, Secrets, etc.)