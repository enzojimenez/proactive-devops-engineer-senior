#!/bin/bash
##########################################
# Author: Enzo Jimenez - enzofjh@gmail.com
##########################################

# S3 Bucket for the Terraform state file
aws s3api create-bucket  \
    --bucket gorilla-devops-eng-tf \
    --region us-east-1

# Two EC2 machines as GitHub Action runners
aws ec2 run-instances \
    --count 2 \
    --image-id ami-0cff7528ff583bf9a \
    --subnet-id subnet-5ff12c06 \
    --security-group-ids sg-0b969b00e90f74873 \
    --instance-type t2.small \
    --iam-instance-profile Name=GitHubRunner-Role \
    --key-name RA-APPS \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=GitHubRunner-GorillaLogic}]' \
    --associate-public-ip-address > instances.txt

# Get EC2 Public IP Addresses for SSH into these machines
aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=GitHubRunner-GorillaLogic" \
    --query "Reservations[*].Instances[*].[PublicDnsName]" \
    --output text > dns.txt