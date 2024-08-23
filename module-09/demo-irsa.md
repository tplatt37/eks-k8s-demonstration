# Demo - IRSA

Module 9 - Pods using AWS Services with IRSA (Slide 57)

Let's improve the security of our cluster by using an IRSA SA for a "least privilege" permission setup

# REMOVE overly broad permissions

REMOVE the "a-new-startup-app" policy from EC2 node role
You can do that via the console.
Show that a-new-startup is now broken - can't submit! A DynamoDB error will happen

NOTE: If you don't have a-new-startup installed, use the helm chart to install it.

# 
In the console, show the policy named "a-new-startup-app" 

Create IRSA account:
```
POLICY_ARN=$(aws cloudformation describe-stacks --stack-name a-new-startup-dev --query "Stacks[0].Outputs[?OutputKey=='PolicyArn'].OutputValue" --output text)
echo $POLICY_ARN

eksctl create iamserviceaccount --cluster=eks-demo --name=svc-a-new-startup --namespace=default --attach-policy-arn=$POLICY_ARN --approve
```

Please note that we used an option in the cluster.yaml file to have eksctl setup the OIDC Provider for us!

Show the newly created IAM Role, show that it has the policy attached.  It's easiest if you navigate from the Resources tab of the CFN stack.  Show the Trust Relationships tab too - because you should emphasize the "3 way trust" concept for the upcoming knowledge check.

Show the sa (ServiceAccount) in k8s.  Show the annotations:
```
k describe sa svc-a-new-startup 
```

BUT... our pod isn't using it yet.
Go into the helm chart's template/deployment.yaml file and UNCOMMENT the serviceAccount name line (line 48)
Be careful with the indentation - don't mess it up.

Save the file.

Then, run this
```
cd ~/environment/coreks/app/a-new-startup/helm
helm upgrade --install myrelease a-new-startup-amd64
```
It will do a ROLLING UPDATE - the new pods will be using the IRSA service account.

Show the app now works - yay!

And even better - we didn't increase or change the NODE permissions or the permissions of ANY OTHER POD (now or in the future.)