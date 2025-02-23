# Assignment 3:
Write pipeline-as-code to deploy containerised application. You can choose any sample application written in java, nodejs
or php.
- Prepare a dockerfile or docker-conpose.yaml to run the containerised application.
- Use any of the container orchestration tool, be it kubernetes, docker swarm, ecs, eks etc and deploy the above application
to that cluster.
- This deployment pipeline should be managed in a code format, you use can jenkinsfile, drone-ci, azure pipelines or
bitbucket-pipelines etc as the tool for achieving the same. Bitbucket-pipelines is most preferred for this assignmen
## Delivery Outcome:
- Once we make changes in the docker-compose.yaml or dockerfile or any of the code in the container and push it to git,
your pipeline as a code should build this container and deploy it accordingly to the mentioned services i.e kubernetes,
docker-swarm, ecs, eks etc.
- To test we should have an url endpoint which confirms that the application is running.

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