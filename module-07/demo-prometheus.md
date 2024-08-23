# Demo - Prometheus

Module 7 - Example: Control Plane metrics (slide 11)

Prometheus has been embraced by the k8s community.


You can run the main example shown in the slides:
```
kubectl get --raw /metrics
```

Many of the components are generating detailed metrics constantly.
For example - how is our DNS (CoreDNS) doing?

Run these commands:

```
POD_NAME=$(kubectl get pods -l eks.amazonaws.com/component=coredns -o=jsonpath='{.items..metadata.name}' -n kube-system | tr ' ' '\n' | tail -1) 
echo $POD_NAME
k port-forward -n kube-system po/$POD_NAME 8080:9153
```

Then "Preview" -> "Preview Running Application"... 
and add "/metrics" to the URL

You should then see DNS related metrics. 


If you want another example, the AWS Load Balancer Controller also generates Prometheus metrics:

```
POD_NAME=$(kubectl get pods -l app.kubernetes.io/name=aws-load-balancer-controller -o=jsonpath='{.items..metadata.name}' -n kube-system | tr ' ' '\n' | tail -1) 
echo $POD_NAME
k port-forward -n kube-system po/$POD_NAME 8080:8080
```

Then "Preview" -> "Preview Running Application"... 
and add "/metrics" to the URL

These are RAW metrics.  The slides show an example architecture that use Amazon Managed Service for Prometheus and Grafana to aggregate and visualize. 

I recommend using the slide architectures and static screenshots and talk through that.