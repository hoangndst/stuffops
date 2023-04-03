## Install K8S Cluster
### Install CRI - Containerd
- Install Containerd on all nodes using Ansible
- Ansible playbook file: [containerd.yml](./containerd.yml)
### Forwarding IPv4 and letting iptables see bridged traffic
- Forwarding IPv4 and letting iptables see bridged traffic on all nodes using Ansible
- Ansible playbook file: [network.yaml](./network.yaml)
### Configure CRI - Containerd
- Configure Containerd on all nodes using Ansible
- Ansible playbook file: [config_containerd.yml](./config_containerd.yaml)
### Installing kubeadm, kubelet and kubectl 
- Installing kubeadm, kubelet and kubectl on all nodes using Ansible
- Ansible playbook file: [kube.yaml](./kube.yaml)
### Creating a cluster with kubeadm
Before you begin
To follow this guide, you need:
- One or more machines running a deb/rpm-compatible Linux OS; for example: Ubuntu or CentOS.
- 2 GiB or more of RAM per machine--any less leaves little room for your apps.
- At least 2 CPUs on the machine that you use as a control-plane node.
- Full network connectivity among all machines in the cluster. You can use either a public or a private network.
1. Initializing your control-plane node
    ``` bash
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --control-plane-endpoint=master.local:6443
    ```

    ``` bash
    Your Kubernetes control-plane has initialized successfully!

    To start using your cluster, you need to run the following as a regular user:

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    Alternatively, if you are the root user, you can run:

    export KUBECONFIG=/etc/kubernetes/admin.conf

    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    https://kubernetes.io/docs/concepts/cluster-administration/addons/

    You can now join any number of control-plane nodes by copying certificate authorities
    and service account keys on each node and then running the following as root:

    kubeadm join master.local:6443 --token zxlyyr.bws8bpvo60tbt3js \
            --discovery-token-ca-cert-hash sha256:3a2a40e4adafe0fdcc19f6edfef8fb19d7275c15b8ea1c064b5291c462598143 \
            --control-plane 

    Then you can join any number of worker nodes by running the following on each as root:

    kubeadm join master.local:6443 --token zxlyyr.bws8bpvo60tbt3js \
            --discovery-token-ca-cert-hash sha256:3a2a40e4adafe0fdcc19f6edfef8fb19d7275c15b8ea1c064b5291c462598143
    ```
2. Installing a Pod network add-on 
    ``` bash
    curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
    kubectl apply -f calico.yaml
    ```
3. Join your nodes using Ansible
    - Ansible playbook file: [join_node.yaml](./join_node.yaml)