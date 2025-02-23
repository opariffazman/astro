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