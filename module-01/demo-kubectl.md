# kubectl demo - Part 1

Module 1 "Kubectl tool" (Slide 33)

Demonstrate that kubectl has been installed:
```
kubectl version
```

Explain concept of the kubeconfig file (~/.kube/config)
```
kubectl config view
kubectl config get-contexts
kubectl config use-context ...
kubectl cluster-info
```

Show aws eks convenience command to point to your EKS cluster
```
rm ~/.kube/config
kubectl config view
aws eks update-kubeconfig --name eks-demo --region us-west-2
kubectl config view
```

What resources does this cluster support?
```
kubectl api-resources
kubectl api-resources | sort
```

Show some CRDs as well as basic objects.
Explain: Short Names, Namespaced True/False 

Tired of typing kubectl? run this:
```
alias k=kubectl
```

Nodes:
```
k get no
```

Pods (or lack thereof!)
```
k get po 
```

Namespaces:
```
k get ns
```

Explain: default, kube-system

kube-system is full of system stuff (which we'll learn about later)
```
k get po -n kube-system
```

Recognize anything? 
Highlight: coredns, kube-proxy
Highlight: Some of those things are Daemonsets (aws-node*, kube-proxy*, ebs-csi-node*). Some are Deployments (coredns)

Show these commands:
```
k get po --all-namespaces
k get po -A
k get all -n kube-system
```

Explain that "all" is NOT really "all" - but it's still pretty handy.  (For example Configmaps, Secrets, etc. are not listed)

Examine one of the pods:
NOTE: (Remember that kubectl autocompletion is enabled. If you put the -n first you can leverage it. after typing "po/" hit TAB TWICE)
```
k describe -n kube-system po/PODNAME | less
```

"less" is "more" - a Pager.  Hit q to quit, space to page down, or arrow keys to scroll up or down.

Show that we can retrieve a "YAML view" of any running object:
```
k get -n kube-system po/PODNAME -o yaml
```

# kubectl demo - Part 2 

Module 1 - Activity (Slide 54)

Create a namespace
```
k create ns my-ns
k get ns
k get all -n my-ns
```

It's got nothing in it! Let's fix that...
```
cd ~/environment/coreks/module-01
k apply -f nginx-deploy.yaml
k get all -n my-ns
```

Explain:
    2 Pod replicas, belonging to a Replicaset (rs) , managed by a Deployment (a hierarchy!)

Show IPs of pods - important concept in k8s - EACH POD GETS ITS OWN UNIQUE IP - that is how they talk back and forth:
```
k get po -o wide -n my-ns
```

A few things to note:
  STATUS = Running
  1/1 (1 container of 1 total) are READY
  NODE = the Worker node the pod has been scheduled on

It says it is running , can we prove it? 
```
k port-forward -n my-ns pod/PODNAME 8080:80 
```
Cloud9: "Preview Running Application" and you should see the Nginx welcome page
Ctrl+C to stop port forwarding.
By the way, that's a handy way to get a peek at something running "INSIDE" the cluster.  Kubectl is acting as the conduit.  That nginx pod is NOT reachable from outside the cluster. 

Quiz them on the Deployment -> ReplicaSet -> Pod replicas concept:

What will happen if I run this command? (ask them)
```
k delete -n my-ns po/ONE_OF_THE_PODS --force 
```

ANSWER: The Pod replica will be deleted, but the ReplicaSet will very quickly observe the difference between desired state and actual state, and fix the issue. 

You'll see a fresh new pod replica to replace the one deleted:
```
k get all -n my-ns
```

Kubernetes self-healing via control loops in action!

A Deployment lets you do declarative NO OUTAGE updates to your application.  We can see this by doing a simple "Reboot" of our pods too though:
```
k rollout restart -n my-ns deploy/nginx && watch kubectl get all -n my-ns

You should see a "Rolling Update" where a 2nd replicaset is created. It will be scaled out with replacement pods, while the original replicasest is scaled in.  Be sure to observe what's going on in the Pod listing, but also the ReplicaSets.  The Deployment is orchestrating the scale out/scale in by manipulating the replica sets.   

NOTE: We aren't really "rebooting" the pods - but we are re-creating them from a known good starting point.  This is sometimes helpful for resolving intermittent issues.

Hit Ctrl+C when done. If it was too quick, run it again. 

What will happen if we DELETE the deployment? Will it magically be resurrected like what we just saw with the Pod replicas and Replicas Set?   
```
k delete deploy/nginx -n my-ns
k get all -n my-ns
```

No - it will not.

There's not a self-healing control loop looking over the Deployments (or the Services, ConfigMaps, etc.). That's strictly a ReplicaSet / Pod replica thing.

(This is foreshadowing what GitOps will do for us)

By the way, don't we have a DNS service in this cluster?
YES:
```
k get svc -n kube-system
```

See DNS? It's listening on an IP and Port (53) INSIDE the cluster. 
More on this later, but we want to deal with friendly DNS names, not raw IPs - because the IPs come and go A LOT.

For now, just know that Kubernetes will wire up each Pod replica to use that DNS service auto-magically
