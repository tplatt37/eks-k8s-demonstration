# Bonus Content

The bonus directories contain the following:

## Cloud9 Utilities

Some additionall info and helper scripts for Cloud9 

## Troubleshooting exercises

There are a few simple k8s pod troubleshooting exercises in folder debugging-exercises.  See the README.md for more detail.

## K8s Manifest Demos

The k8s-demos directory are a set of YAML manifests (and markdown files sometimes) that have simple demos that go beyond the content of the course.

Some of these utilize a special "Hello World" app image (and multiple versions of it!)

Before you attempt to use these demos, you should build the images and update the manifests.

To build the images:
```
cd ~/environment/coreks/app/hello-world
./install.sh
```

To update the manifests
```
cd ~/environment/coreks/bonus/k8s-demos
./update-image.sh
```