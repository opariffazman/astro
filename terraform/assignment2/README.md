# Assignment 2

AWS EKS clusters come with default AWS VPC CNI plugin that provides some excellent features like getting an address
within the VPC subnet range. One limitation of AWS CNI comes from the number of IP addresses and ENI that you can
assign to the single instance.

Refer to the (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI) which shows
that limit.

In this assignment, to replace AWS VPC CNI (EKS default) with Calico for networking layer. The new EKS cluster should
have a mixture of spot and on demand node group. Deploy a sample service to illustrate that the cluster is using Calico
network layer instead of EKS VPC default.

## Delivery Outcome:
- Ideally the candidate should have installed Calico networking layer in the kube-system namespace (pods: calico-kubecontroller,
calico-node etc).
- Upon inspection (kubectl get pods –all-namespaces), only kubernetes system pods should be running on AWS VPC private
IP while the rest of the pods should be running on Calico network (different IP range).

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