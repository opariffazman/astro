# Assignment 2

- EKS cluster with custom networking layer
- Calico CNI replacement for AWS VPC CNI
- Hybrid node groups utilizing both spot and on-demand instances

# References

AWS EKS [Auto Cluster](https://hervekhg.medium.com/i-built-my-first-eks-cluster-in-auto-mode-and-was-shocked-by-the-simplicity-a-terraform-guide-df327dca7c8e)

Installing [Calico](https://docs.tigera.io/calico/latest/getting-started/kubernetes/managed-public-cloud/eks)

# Steps

## Setup backend
```
cd cloudformation
aws cloudformation create-stack --stack-name assignment2-tf-state-resources --template-body file://assignment2.yaml
```

## Setup EKS Cluster
```
cd terraform/assignment2
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Initialize kubeconfig
```
aws eks update-kubeconfig --name astro
```

## Delete AWS VPC CNI
```
kubectl delete daemonset -n kube-system aws-node
```

## Install Calico
```
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
```

## Configure Calico
```
kubectl create -f - <<EOF
kind: Installation
apiVersion: operator.tigera.io/v1
metadata:
  name: default
spec:
  kubernetesProvider: EKS
  cni:
    type: Calico
  calicoNetwork:
    bgp: Disabled
EOF
```

## Add node to cluster
```
eksctl create nodegroup --cluster astro --node-type t2.micro --max-pods-per-node 1
```