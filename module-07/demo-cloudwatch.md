# Demo - CloudWatch

Module 7 - CloudWatch metrics and log collection (Slide 15)

Container Insights is enabled as an Add-On for this cluster.

You can navigate to CloudWatch -> Container Insights to see the available information.


You can also go to CloudWatch Logs and see logs for the Control Plane (eks-demo/cluster), Data Plane (eks-demo/dataplane, eks-demo/host), and Pods (eks-demo/application)

You might browse through a few of these, and consider showing a Logs Insights query such as:

(Run this against the eks-demo/application log group for 3 days:)
```
fields @timestamp, @message | sort @timestamp desc | filter kubernetes.namespace_name="default"
```

or 
```
filter @message like 'rror' | filter kubernetes.namespace_name="kube-system"
```

Call out the face that these STRUCTURED logs (json!) give us great query capabilities.

You can also query Control Plane logs ( eks-demo/cluster log group):
```
filter @message like 'Insufficient'
```

The above should return log entries from the Scheduler for the Cluster Autoscaler demo of the last module.