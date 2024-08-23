# Netshoot 

[Netshoot](https://github.com/nicolaka/netshoot) is a Docker image used as a troubleshooting and debugging for k8s clusters.
It's got just about every CLI tool you need to troubleshoot networking/dns/etc.

# Run as a Temporary Pod

```
kubectl run tmp-shell --rm -it --image nicolaka/netshoot
```

NOTE: The first time you run the above, it'll take awhile - it has to pull the large netshoot container image from a public repo.   It will start quickly once the image is cached on the host.

# Run as an Ephemeral container in an existing Pod (aka Kubectl Debug)

```
kubectl debug mypod -it --image=nicolaka/netshoot
```
