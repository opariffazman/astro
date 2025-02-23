# Assignment 3:

- ECR and EKS orchestration platform
- CI/CD infrastructure for containerized applications
- Automated build and deployment pipeline
- Health check endpoint infrastructure

# Steps

## Setup backend
```
cd cloudformation
aws cloudformation create-stack --stack-name assignment3-tf-state-resources --template-body file://assignment3.yaml
```

## Setup ECR Repo & Github Actions Role
```
cd terraform/assignment3
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

- Make changes to any of the files inside nodejs/assignment3 to trigger automated build and deployment on GitHub