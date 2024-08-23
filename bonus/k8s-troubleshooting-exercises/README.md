# Overview
This is a collection of k8s troubleshooting/debugging exercises you can work with.

## How to start

In any directory, take a look at the setup.yaml file - that will explain the problem at hand.
```
k apply -f setup.yaml
```

Try to solve it yourself, or look at potential solutions in the solution.yaml file.

NOTE: We assume you've aliased:
```
alias k='kubectl'
```
to save yourself a zillion keystrokes!

You probably want to "set-context" for each problem.
```
k config set-context --current --namespace=q1
```

## Stuck?

The solution (or solutions) is provided in the solution.yaml

You probably will need to delete the pod from the setup.yaml, but you should be able to:
```
k apply -f solution.yaml
```

## Cleanup

Note that each problem is in it's own namespace (q1,q2,q3, etc.). 
To cleanup after working on an issue:

```
k delete ns/q1 --force &
```

NOTE: That's a CASCADING DELETE. It's going to blow away everything in the Namespace
