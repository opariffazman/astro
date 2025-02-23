# Assignment 1

- Three-Tier Application Architecture
- Multi-tier VPC architecture with public and private subnets
- Load-balanced web and application tiers with autoscaling
- Secured database tier in private subnet
- NAT Gateway and routing configuration
- IAM roles integration with AWS services
- CloudWatch monitoring with SNS alerts
- Route53 private hosted zones

# Steps

## Setup backend
```
cd cloudformation
aws cloudformation create-stack --stack-name assignment1-tf-state-resources --template-body file://assignment1.yaml
```

## Setup EKS Cluster
```
cd terraform/assignment1
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```