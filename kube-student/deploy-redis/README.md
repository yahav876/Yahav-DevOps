# Introduction

Hi , Here i will show you how to you can create a kubernetes cluster , installing helm for deploying and finally deploy a redis on your kubernetes cluster with configuration and security enabled.


# Requirements

1. Create 3 virtual machines with VirtualBox (1 for the master node and 2 slaves), use Ubuntu 20.04 image for the OS - *NOTE* make sure the master node has at least 2 vCPUs and 4GB ram.
2. For installing kubernetes i followed k8s official documentation in this link - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/
3. When you done bootstrap your cluster , you need to install helm (an application package manager for Kubernetes) follow this link - https://helm.sh/docs/intro/install/


# Solution

1. Create a K8s cluster with kubeadm.


Commands for installing k8s.

```
# Get the Docker gpg key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository:
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Get the Kubernetes gpg key:
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add the Kubernetes repository:
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update your packages:
sudo apt-get update

# Install Docker, kubelet, kubeadm, and kubectl:
sudo apt install -y docker-ce kubelet kubeadm kubectl

# Add the iptables rule to sysctl.conf:
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf

# Enable iptables immediately:
sudo sysctl -p

# Disable swap permanently
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Initialize the cluster (Run ONLY on the master):
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up local kubeconfig (Run ONLY on the master):
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Apply Calico CNI network overlay (Run ONLY on the master):
curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# Get the join command for your slaves
kubeadm token create --print-join-command 

# Join the worker nodes to the cluster:
sudo kubeadm join [your unique string from the kubeadm init command]

#Verify the worker nodes have joined the cluster successfully:
kubectl get nodes

  
```
2. Install helm.

```
OS - Ubuntu 20.04:

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

```

