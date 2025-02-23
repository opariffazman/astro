# Assignment 1

1. Write IAAC script for provision of a 3-tier application in AWS. You can choose terraform or cloudformation to provide
the infrastructure. Your code should provision the following:
- VPC with a public and private subnet.
- Route tables for each subnet, private subnet shall have a NAT gateway.
- Application tier and data tier shall be launched in private subnet.
- Web-tier shall be launched in public subnet.
- Web-tier and application-tier both must have autoscaling enabled and shall be behind an ALB
- Proper security groups attached across the tiers for proper communication.

## Bonus points will be given to the assignments with following items:
- Proper DNS mappings with a privately hosted zone in Route53 for application and data-tier.
- IAM roles attached to the application tier to access RDS, cloudwatch and s3 bucket.
- Key Infra Alert being integrated with SNS and CloudWatch

## Delivery Outcome:
- Once the IAAC script is executed, it should create a VPC with valid CIDR block, which contains all VPC related
Resources such as valid subnets, route tables (public, private), security groups, NAT gateway, Internet Gateway etc.
- It should also create EC2 servers for application-tier and web-tier with autoscaling groups and ALB, and RDS instances
for data-tier.
- Proper security groups and IAM roles should be in place.
- Architecture Diagram is proper referenced with configuration enabled via terraform or cloudformation.