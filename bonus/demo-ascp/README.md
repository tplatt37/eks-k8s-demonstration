# Demo of AWS Secrets Manager and Config Provider for Secret Store CSI Driver

Tutorial: Create and mount an AWS Secrets Manager secret in an Amazon EKS pod

This is a shell script version of :
https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver_tutorial.html


# Pre-requisites

IRSA is needed, but should already be there.

# Install

Run this first to install the CSI Driver:
```
./install.sh
```

Show that the CSI Driver is now running as a Daemonset (NOTE: Does NOT work on Fargate!)
```
kubectl get all -n kube-system
```

Then, create the Secret to be mounted - and the k8s SA (IRSA) that will be used to access it:
```
./create-secret.sh
```

Go show the Secret in AWS SecretsManager.  

Then, create the ProviderClass (CRD) and k8s Deployment that will mount the Secret:
```
./create-k8s.sh
```

Review the providerclass.yaml and deployment.yaml files.

The above will output a command you can run to show the Secret, mounted as a file.  It will be SIMILAR, but not exactly like this:
```
kubectl exec -it $(kubectl get pods | awk '/nginx-deployment/{print $1}' | head -1) cat /mnt/secrets-store/MySecret-RANDOM; echo
```

Alternatively, you can exec into the Pod and show the mounted secret from an interactive shell.

# Uninstall

To uninstall:
```
./uninstall.sh
```

The CSI Provider will not be uninstalled, but the Secret/IAM Policy/k8s Objects/ServiceAccount will be deleted.

NOTE: The Secret will be scheduled for deletion in 7 days.