# General Notes

## Structure of how things deployed
1. A deployment is the parent of all, and theoretically you only need to ever change deployments
2. Under each deployment is a replicaset, if a deployments get modified a new replicaset is build
3. In each replicaset is one or more pods
4. Each pod is one or more containers

## Create simple deployment
1. Run ```kubectl create deployment nginx-depl --image=nginx``` to 
create a new deployment of an nginx container
2. Run ```kubectl get deployment``` to show the new deployment 
and ```kubectl get pod``` to see the new pods once they are created
3. To see new replicasets created after changing a deployment run 
```kubectl edit deployment nginx-depl``` and edit the line under ```containers:```
to change the ```-image: nginx``` line to ```-image: nginx:1.16```
4. Save the changes and run ```kubectl get replicaset``` to see the new replicaset

### View logs in a running pod
```kubectl logs <pod-name>```

### Open a Bash shell in a running pod
```kubectl exec -it <pod-name> -- bin/bash```