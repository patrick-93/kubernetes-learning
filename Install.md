# Kubernetes notes

## RHEL 8 Setup

### All Nodes
1. Add the Google Kubernetes repos to download the latest kubectl/kubeadm
2. Add the cri-o repos to install cri-o (Docker not supported on RHEL 8)
3. Install cri-o, kubectl, and kubeadm
4. Copy the settings files in files/modules-load.d and files/sysctl.d
to /etc/modules-load.d/ and /etc/sysctl.d/ and apply that config
5. Start and enable the crio and kubelet services
6. (Possibly) Set SELinux to permissive

### Master (Control Plane) node
Open firewall ports
* 6443/tcp: kubernetes api
* 2379-2380/tcp: etcd api 
* 10250/tcp: kubelet api
* 10259/tcp: kube-scheduler 
* 10257/tcp: kube-controller-manager

### Worker nodes
Open firewall ports
* 10250/tcp: kubelet api 
* 30000-32767/tcp: node services

## Initialize a cluster and join worker nodes
1. On the node chosen to be master run
```kubeadm init```
This will generate a lot of output and at the end will
generate a string used to join worker nodes to the master.
This join string is only good for 24 hours.
2. To join worker nodes to the new cluster run the command from step 1
3. To confirm a new cluster was initialized on the master run
```kubectl cluster-info``` and to confirm the new nodes were joined
successfully run ```kubectl get nodes```

## Join token is expired or lost
1. On the master node run ```kubeadm token list``` to see all valid tokens
2. To generate a new token run ```kubeadm token create --print-join-command```

## Remove a worker node from a cluster
1. First remove all pods from the node using ```kubectl drain <node-name> --delete-local-data --ignore-daemonsets```
2. Prevent new pods being added to the worker using ```kubectl cordon <node-name>```
3. Revert changes kubernetes made to a node using ```kubeadm reset```