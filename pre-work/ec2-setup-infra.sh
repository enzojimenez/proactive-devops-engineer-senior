#!/bin/bash
##########################################
# Author: Enzo Jimenez - enzofjh@gmail.com
##########################################

# System update
sudo yum update -y
sudo yum install -y curl jq git yum-utils perl-Digest-SHA

# Terraform installation
# https://learn.hashicorp.com/tutorials/terraform/install-cli
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
# Enable terraform tab completion
touch ~/.bashrc
terraform -install-autocomplete

# Download & Setup Kubectl CLI v 1.23.7
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

# GitHub Runner setup for Infra Repo
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.298.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.298.2/actions-runner-linux-x64-2.298.2.tar.gz
echo "0bfd792196ce0ec6f1c65d2a9ad00215b2926ef2c416b8d97615265194477117  actions-runner-linux-x64-2.298.2.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.298.2.tar.gz
./config.sh --url https://github.com/enzojimenez/timeoff-management-application-infra \
    --token $1 --name 'ghr-aws-infra' --labels 'ec2-infra' --unattended
sudo ./svc.sh install
sudo ./svc.sh start