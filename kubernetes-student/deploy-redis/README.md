# Introduction

Hi , Here i will show you how to you can create a kubernetes cluster , installing helm for deploying complex applications and finally deploy a redis on your kubernetes cluster with configuration and security enabled.


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

3. Deploy Redis with security enables.

Download helm chart for Redis.

```
 helm repo add bitnami https://charts.bitnami.com/bitnami
 mkdir helm-redis
 cd helm redis
 helm pull bitnami/redis    
 tar xfv redis-15.5.2.tgz

```
Install CFFSL tool for certificates.

``` 
sudo apt-get update -y
sudo apt-get install -y golang-cfssl
```

Create TLS certificate with CFSSL

```
mkdir cert
cd cert
cfssl print-defaults config > config.json
cfssl print-defaults csr > csr.json
```
Create a JSON config file for generating the CA file, for example, ca-config.json
```
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
          "signing",
          "key encipherment",
          "server auth",
          "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
```
Create a JSON config file for CA certificate signing request (CSR), for example, ca-csr.json. Be sure to replace the values marked with angle brackets with real values you want to use
```
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names":[{
    "C": "<country>",
    "ST": "<state>",
    "L": "<city>",
    "O": "<organization>",
    "OU": "<organization unit>"
  }]
}
```
Generate CA key (ca-key.pem) and certificate (ca.pem):
```
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
```
Create a JSON config file for generating keys and certificates for the API server, for example, server-csr.json. Be sure to replace the values in angle brackets with real values you want to use. The MASTER_CLUSTER_IP is the service cluster IP for the API server . The sample below also assumes that you are using cluster.local as the default DNS domain name
```
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "<MASTER_IP>",
    "<MASTER_CLUSTER_IP>",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [{
    "C": "<country>",
    "ST": "<state>",
    "L": "<city>",
    "O": "<organization>",
    "OU": "<organization unit>"
  }]
}
```
Generate the key and certificate for the API server, which are by default saved into file server-key.pem and server.pem respectively:
```
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem \
--config=ca-config.json -profile=kubernetes \
server-csr.json | cfssljson -bare server

```

Create a secret for k8s 
```
kubectl create secret generic certificates-tls-secret --from-file=server.pem  --from-file=server-key.pem--from-file=ca.pem 

```

Now open values.yaml file and edit this lines:
```
  tls.enabled="true"
  tls.certificatesSecret="certificates-tls-secret"
  tls.certFilename="server.pem"
  tls.certKeyFilename="server-key.pem"
  tls.certCAFilename="ca.pem"
```
```
volumePermissions:
   enabled: true
```

```
persistence:
   enabled: true
   storageClass: "localdisk"
```

Create PV and StorageClass as storage.yaml and pv-redis.yaml:
NOTE* create 4 PVs , 1 for the master and 3 for replicas.

```
apiVersion: storage.k8s.io/v1
kind: StorageClass 
metadata:
 name: localdisk
provisioner: kubernetes.io/no-provisioner 
allowVolumeExpansion: true

```
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redispv4
spec:
  capacity:
    storage: 8Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: localdisk
  hostPath:
    path: /mnt

```
Run
```
kubectl apply -f storage.yaml 
kubectl apply -f pv-redis.yaml
helm install myredis -f values.yaml ../redis
```


