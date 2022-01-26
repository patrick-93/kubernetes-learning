# General Notes

### General container notes
* Containers are created using images
* Containers can either be the default image or be customized using a Dockerfile
* Images are downloaded from vendor repositories

### Google's distroless containers
```https://github.com/GoogleContainerTools/distroless```
* Documentation on images used to run kubernetes

### Offline Containers
* All possible images that a node can run have to be available on every node
* To export an image from an online machine that was downloaded using ```podman pull```
you need to export it to a file using ```podman save -o <filename> <image>``` and
import the image on the offline nodes using ```podman load --input <filename>```
* To confirm that kubelet sees the imported images after they're imported using podman 
you can use ```crictl img``` and to see containers that have been built use
```crictl ps -a```. If any errors happen during this process they are logged to 
syslog which can be viewed in /var/log/messages or using ```journalctl -xeu kubelet```

### Getting the dashboard working
* Apparently the default is to not have any graphical interface so the only available
GUI for this comes from the kubernetesui/dashboard and kubernetesui/metrics-scraper image
* The official recommended deployment settings for the dashboard are currently available at
https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml

### Structure of how things deployed
1. A deployment is the parent of all, and theoretically you only need to ever change deployments
2. Under each deployment is one or more replicasets, if a deployment gets modified new replicasets
are built
3. In each replicaset is one or more pods
4. Each pod is one or more containers
5. A service is used to expose pods to the outside, by default all pods have no external connection

### Create simple deployment
1. Run ```kubectl create deployment nginx-depl --image=nginx``` to 
create a new deployment of an nginx container
2. Run ```kubectl get deployment``` to show the new deployment 
and ```kubectl get pod``` to see the new pods once they are created
3. To see new replicasets created after changing a deployment run 
```kubectl edit deployment nginx-depl``` and edit the line under ```containers:```
to change the ```-image: nginx``` line to ```-image: nginx:1.16```
4. Save the changes and run ```kubectl get replicaset``` to see the new replicaset

### Useful commands
```
# Generate a deployment yaml file template using kubectl
kubectl create deployment \
	--namespace=my-namespace \
	--image=registry.domain.local/myapp:latest myapp \
	--replicas=4 --dry-run=client \
	-o yaml > myapp-deployment.yml

# Get logs of a pod
kubectl logs <pod-name> 

# Get logs from something other than a pod
kubectl logs deployment/<name>

# Execute something in a pod
kubectl exec -it <pod-name> -- bin/bash 

# Create and run a container from an image
podman run -it localhost/rhel8-java:v0.1

# Build a container from a Dockerfile, will produce 
# a new container named localhost/rhel8-java:v0.1
podman build --tag rhel8-java:v0.1 -f ./Dockerfile
```


### Sample Dockerfile to customize a RHEL8 UBI
```
FROM registry.access.redhat.com/ubi8:latest
env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin
RUN dnf -y upgrade && dnf install -y java-11-openjdk
COPY /local/file/custom.jar /custom.jar
EXPOSE 8080
ENTRYPOINT java -jar /custom.jar
```

### Repository folder structure
Sample folder structure in ```repo_structure/```