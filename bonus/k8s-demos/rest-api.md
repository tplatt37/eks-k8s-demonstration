# To demonstrate the k8s REST API 
# k8s REST API demo: https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/
# k8s REST API examples: https://kubernetes.io/docs/reference/using-api/api-concepts/
#
# We only demo GETs (READS) but PUT/POST/DELETE does things too.
#
# Run this:
kubectl proxy --port 8080 
#
# In another terminal, run:
#
curl http://localhost:8080/api/
#
# List namespaces
curl http://localhost:8080/api/v1/namespaces
#
# Pods in default (may be none)
curl http://localhost:8080/api/namespaces/default/pods
#
# Pods in kube-system
curl http://localhost:8080/api/v1/namespaces/kube-system/pods
#
# A WATCH is an efficient way for a process to "subscribe" to add/changes/deletes
# Run this in a terminal window (NOTE: It won't exit!)
curl http://localhost:8080/api/v1/namespaces/default/pods?watch=1&resourceVersion=0
#
# Start a Pod in another window
k run -it --rm debug --image=busybox:1.28 --restart=Never -- sh
# Go back to the curl window and you should see output (JSON)
# If you run another pod, there will be more output .
#
# NOTE: There's also a -w flag on kubectl to do a watch:
k get po -w
#

# To access the REST API from within a Pod/Container
# 1. Inside the cluster, the REST API is available via Service named "kubernetes"
# 2. The pod will have a service account (SA) that it can use (default!)
# 3. Certificate Authority (ca) files are mounted automatically to validate the HTTPS connection.
#
# 4. NOTE that you will be LIMITED to whatever k8s permissions the SA (default) has
#
# Run this inside an nginx pod:

# Point to the internal API server hostname
APISERVER=https://kubernetes.default.svc

# Path to ServiceAccount token
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# Read this Pod's namespace
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)

# Read the ServiceAccount bearer token
# NOTE: This is a JWT. You can decode the value with a JWT Debugger.
TOKEN=$(cat ${SERVICEACCOUNT}/token)

# Reference the internal certificate authority (CA)
CACERT=${SERVICEACCOUNT}/ca.crt

# Explore the API with TOKEN
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api

# Trying to list namespaces will result in 403 forbidden because the default SA has NO K8S PERMISSIONS
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces

