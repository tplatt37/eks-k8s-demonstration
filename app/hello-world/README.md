# Hello World Nodejs

A simple NodeJS container image that can be used in Docker and k8s demos.

The container listens on Port 3000 and returns a web page (for any GET request):

* "Hello World!"
* A version number
* CSS Styled
* Linux date/time stamp and the hostname (Pod name!) 

This is great for demonstrating helm install/update/rollback or anything else really.

There's a script that will easily, automatically build 3 different versions too - all with a distinct appearance and version number.

NOTE: Docker and AWS CLI v2 is required.

# Install

We need to create a private ECR Repo (in the current region) and then we'll build/tag/push three distinct versions of a container image to that repo.

Run the following:
```
./install.sh
```

Once done, you can reference the image by URI and Tag in your Docker commands or k8s manifests.

# Uninstall

Run this to delete the ECR Repo and ALL THE IMAGES IN IT (of course!)
```
./uninstall.sh
```

# How do I run it local? 

To run it local:
```
docker run -p 8080:3000 hello-world-nodejs:latest 
```

Then open up http://localhost:8080 (On Cloud9 use "Preview Running Application")

# Helm

The helm folder contains a Helm Chart.