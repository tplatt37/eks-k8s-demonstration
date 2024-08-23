# Demo - Configuring Amazon ECR

Module 4 - Demonstration - Configuring Amazon ECR (Slide 12)

## Overview

You will use the "a-new-startup" app code and Dockerfile to build/tag/push a container image to an ECR private repo.

NOTE: These steps assume you have created the backend infra via app/a-new-startup/01-create-iac.sh. If you haven't done that already run:

```
cd ~/environment/coreks/app/a-new-startup
./01-create-iac.sh
```

## ECR

Show ECR in console. Discuss briefly public vs private

Click "Create repository" (talk through options such as Image scan and Encryption).

Name the repository as "a-new-startup"

Show that it is empty but highlight the "URI" (Uniform Resource Identifier) of the repository.

COPY the URI to the clipboard, you'll need it later.

## Docker Build

Run these commands in Cloud9:
```
cd ~/environment/coreks/app/a-new-startup
```

Give a brief tour of the code. It is Nodejs (server side javascript and Express framework). Things you might want to highlight:
  * It uses DynamoDB via AWS JavaScript SDK - it's gonna need IAM perms! (src/app.js)
  * It handles the SIGTERM signal for clean shutdown (src/server.js)
  * It can utilize X-Ray tracing (We'll demo that later)

Show the Dockerfile.  Highlight:
  * It's a multistage build - unit tests are run on every image build
  * The Container will be listening on TCP 3000 port

Build it:
```
docker version
docker build -t a-new-startup . 
```

NOTE: The trailing "." on the 2nd command above is very, very important - don't miss it!  The "." means current directory context -it's going to look for the Dockerfile in the current directory.

The above is a multi-stage build and will run unit tests, then the final image

Once done, show the local images:
```
docker images
```

Run this to grab the current Account ID and Region:
```
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query="Account")
echo $ACCOUNT_ID
REGION=${AWS_DEFAULT_REGION:-$(aws configure get default.region)}
echo $REGION
```

The commands above are using "Command substitution" via $() and "Parameter expansion" (the ${}).  These are Bash concepts.

Docker Run:
```
docker run -p 8080:3000 \
  --env REGION=$REGION \
  --env APP_TABLE_NAME=a-new-startup-dev \
  --env XRAY=ON \
  a-new-startup:latest &
```

NOTE: That trailing "&" runs it in the background, you'll see the stdin/stderr output in your terminal window, but can still type commands too.

Use "Preview" -> "Preview Running Application" to show that it works.

NOTE: If you still see the "nginx" page from the last demo, add ":8080" (without the trailing /) to the end of the URL and hit enter. Seems there is a caching bug in "Preview Running Application"

If you try to submit an email address - it will fail.  Why?

The AWS credentials being used are that of the EC2 node (The credential provier chain of the SDK picks that as priority). You should see the error in the Terminal: "no identity-based policy allows the dynamodb:PutItem action".  (But if the IAM role associated with the EC2 has permissions - it's going to work)

The CloudFormation stack created a policy called "a-new-startup-app". If you Attach that Identity Policy to the Cloud9's EC2 Node Role, the app should then work.

Foreshadowing - Will we hit this problem in our EKS cluster? hmmm....

Once you show it works, stop the running container:
```
docker ps
docker kill XXXX
```

# Docker Tag

"Tag" the image.  In the world of docker "Tags" are actually "versions".   You will need the Private Repo's URI from earlier. We're gonna call this version v1.0
```
docker tag a-new-startup:latest PASTE_URI_HERE:v1.0
```

Show that there's now two tags - one image:
```
docker images
```

# Docker Push

Remember, this is a PRIVATE repo. We need to authenticate first.
NOTE: This is using the variables set previously (ACCOUNT_ID, REGION).
```
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
```

Then PUSH. Note, we're going to call this version v1.0:
```
docker push PASTE_URI_HERE:v1.0
```

Assuming it pushes successfully, go to the ECR console, and show the image now available.

# Consume

Let's get it running on the EKS cluster.

Edit the deployment.yaml file and change the image field (YOUR_IMAGE_URI_AND_TAG_HERE) to the URI:latest
Save, then run:
```
cd ~/environment/coreks/module-04
k apply -f deployment.yaml
```

There should now be 2 copies of the app running in the default namespace.


# Prove it

Is it Running? Let's see:
```
k get po 
```

You will likely catch it in "Container Creating" status - it takes a moment for the kubelet to pull down the container image.

NOTE: If the pods have some error status, make sure you put the correct URI and Tag into deployment.yaml. Fix that, then run the "k apply" from above again.

To "Prove" that it is running, you can do the port-forward command:
```
k port-forward -n default po/POD_NAME 8080:3000 
```

We could (and probably SHOULD) expose it via a service, but there's a bunch of best practices we should put in place, like using ConfigMaps , Services, and other stuff too (Segue to Helm!) 

Rather than handle all those individually, we'll solve that issue in a better way in the next topic.

# BUT ... the App doesn't work

Please also be aware - the app won't work. If you submit an name/email - it will fail due to lack of permissions.  


# Troubleshooting

Why is it failing? Check the logs

```
k logs -l app=a-new-startup --tail -1
```

and/or DESCRIBE
```
k describe po -l app=a-new-startup
```

The above will show ALL the Logs for ALL the currently running Pod Replicas.

Hey - isn't that a great use of a LABEL SELECTOR?   Yes, it is.


You can add the policy (a-new-startup-app) to the EC2 WORKER NODE ROLE to fix the problem, but that is overly broad - and we'll learn better ways later (IRSA)

I DO recommend you do that - so the App will be functional for the Observability (and X-Ray demo later)

QUESTION: If you fix it this way - why is this bad? 
ANSWER: It's NOT least privilege. You've upgraded permissions for every pod running on the NODES and every pod that will EVER in the future run on these NODES. 

BUT ... we'll fix that later.

