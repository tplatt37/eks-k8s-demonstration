# Demos - Networking

If you installed "a-new-startup" using the Helm package there will be Services and Ingress:
* ClusterIP
* NodePort
* LoadBalancer (resulting in an NLB in Instance mode - Target group are the Node IPs)
* Ingress (resulting in an ALB in IP mode - target group are the Pod IPs)

For "demos" I recommend just using the above as examples

If you uninstalled, just re-install:
```
cd ~/environment/coreks/app/a-new-startup/helm
helm upgrade --install myrelease a-new-startup-amd64
```

The above will upgrade or install as needed! It doesn't hurt to run it a 2nd or 3rd time.

Notice when you run "k get all" -there's a ClusterIP Service, a NodePort Service, a LoadBalancer Service, and an Ingress!
```
k get svc 
k get ingress
```

Don't forget Ingress is NOT a Service. It is a separate Object type that sits IN FRONT of Services.