# CF-Challenge

## Description
A proof of concept network with both public and private subnets, housing an Auto-scaling application running Red-Hat.

## Resources
Resources created as part of this plan:

- VPC
- Subnets
- Route-Tables
- IAM Role
- Instance Profile
- Security Groups
- EC2 Instance (Standalone)
- Auto-Scaling Group
- Launch Template
- Application Load Balancer
- Target Group
- S3 Buckets
- Internet Gateway

## Setup

There is an assumed existing Key-Pair within the creation of some resources under the name of "Newbie".  My reasoning is that in most cases, we would be using a provided Key-pair for resources unless otherwise stated.

All that is needed to run this is a configured role/access key.

Make modifications where applicable; IE Region

## Technicals

### ec2.tf
- Deployment of Standalone Instance
- The image it would use
- The ASG based resources
- Launch Template
- Auto-scaling Group itself.

### network.tf
- VPC creation
- Subnet creation
- Route-Tables
- Internet Gateway
- Application Load Balancer
- Listeners/Rules
- Security Groups (Technically EC2, but I like to keep it with networking)

### iam.tf
- IAM roles
- Instance Profiles
- Bucket Policy (Incomplete)

### s3.tf
- S3 Buckets
- Lifecycle configurations

### main.tf
- Providers/Configs required for Terraform.

### userData.sh
- User Data script I embedded into the ASG deployment
- Used to install httpd


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.2.0 |
