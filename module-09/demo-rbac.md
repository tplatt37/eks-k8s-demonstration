# Simple RBAC demo

Module 9 - Demonstration Customizing RBAC Roles (Slide 37)

In the IAM Console, create an IAM Role,  call it student. Grab the ARN

This helper script will create it:
```
cd ~/environment/coreks/module-09    
./create-role.sh
```

Grab the Role ARN

NOTE: The Role does NOT need ANY AWS Permissions - don't attach any identity or inline policy whatsoever

```
k apply -f role.yaml
```

Then , create the rolebinding.  I normally like to explain the existence of "student" in here as being a REFERENCE, a POINTER, a PLACEHOLDER to something that is defined elsewhere...
```
k apply -f rolebinding.yaml
k describe rolebinding
```

Edit the aws-auth configmap, add this arn with a user mapping to "student"

First, get the YAML version of this object using "-o yaml"
```
k get cm aws-auth -n kube-system -o yaml > cm.yaml
```

Edit the file. Using your favorite editor, duplicate the two lines under "mapRoles" section addlines like this:
```
    - rolearn: ROLE_ARN_HERE
      username: student
```

Make sure the indentation matches the other entries.

SAVE the file.

Then update the ConfigMap:
```
k apply -f cm.yaml
```
Ignore any Warnings.

NOTE: If you have to edit again, you need to get the YAML using "-o" again.


Assume the role. There's a helper script named switch.sh  Note that you have to "SOURCE" this for it to work

NOTE: Replace the arn with YOUR ROLE'S ARN!
```
source ./switch.sh arn:aws:iam::123456789012:role/student
```

You are now that role.

Show what it does or does not have access to:
```
aws sts get-caller-identity
k get po -A (denied)
k get po -n default 
k delete ns default --force
```


NOTE: Close terminal window, and start a new one to revert back to prior role/credentials.