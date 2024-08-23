# Demo - Fargate

Module 2 - Demonstration "Working with AWS Fargate" (Slide 24)

Show the Fargate profiles for the EKS cluster, via the Console.

Show the EC2 nodes. These are part of the Managed Node Group. We won't be using these here.
```
k get no -o wide
```

Run the following:
```
cd ~/environment/coreks/module-02
k apply -f nginx-fargate.yaml
```

Run the following to show that the labels are a "match" for one of the fargate profiles. This is a "label selector" in action.
```
k get pods -l stack=frontend -n prod
```

NOTE: It typcally takes 60 seconds for the pods to be up and running... because the Fargate service is provisioning on-demand, right-sized compute for each pod replica.

Show that the POD IP and the NODE IP are one and the same. 
i.e. Fargate is "right-sized" compute that runs ONE POD (1:1 Pod to Host mapping)
```
k get no -o wide
k get po -n prod -o wide
```

You *might* want to also show that nothing additional appears in the EC2 console - other than the ENIs that the Fargate pods will use to communicate with your VPC's resources and EKS control plane.

WHewn done, delete the deployment and you'll see the Fargate pods/nodes go away
```
k delete deploy/nginx -n prod --force
k get no
```