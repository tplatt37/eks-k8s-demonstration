# Demo - X-Ray

Module 7 - Example (Slide 27)

NOTE: This is strictly an X-Ray demo. The steps below DO NOT use ADOT/Prometheus/Grafana.


The a-new-startup app has X-Ray enabled.

NOTE: This demo works better if you have temporarily FIXED the missing IAM perms by adding the "a-new-startup-app" IAM Policy to the EC2 Node Role.   Otherwise, the tracing information won't be as useful.

You can show the code (src/app.js) to see where annotations, metadata, and subsegments are defined, etc.

The Pods have X-Ray Daemon running as a "side car" (listening on port 2000)

Run this and note that 2/2 are "Ready"
```
k get po -l app=a-new-startup
k describe po -l app=a-new-startup
```

Open the app and submit an email address or two, and then show the resulting telemetry in the CloudWatch X-Ray console.

Show the "Traces" or "Trace Map"

In traces, try sorting by "Response code" - look for non-200s - 404, 409, 500, etc.

If you submitted an email TWICE there will be a failure.  Can you use X-Ray to figure out the root cause (Yes - you can!)

(Show the Exceptions tab for the DynamoDB PutItem call)