#!/bin/bash
##########################################
# Author: Enzo Jimenez - enzofjh@gmail.com
##########################################

# System update
sudo yum update -y
sudo yum install -y curl git yum-utils perl-Digest-SHA \
    gcc glibc glibc-devel glibc-utils gcc-c++

# Install NVM on Amazon Linux
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
# Logut/Login
source ~/.bashrc
# Check for latest version required
nvm ls-remote
# Latest LTS: Boron
nvm install v14.20.1
npm --version && node --version # 6.14.17 && v14.20.1
# Global dependencies for TEST
npm install -g selenium-webdriver phantomjs bluebird

# Install Docker runtime
sudo yum install -y docker
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service
id ec2-user
newgrp docker

# Download & Setup Kubectl CLI v 1.23.7
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm version --short | cut -d + -f 1

# GitHub Runner setup for App Repo
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.298.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.298.2/actions-runner-linux-x64-2.298.2.tar.gz
echo "0bfd792196ce0ec6f1c65d2a9ad00215b2926ef2c416b8d97615265194477117  actions-runner-linux-x64-2.298.2.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.298.2.tar.gz
./config.sh --url https://github.com/enzojimenez/timeoff-management-application \
    --token $1 --name 'ghr-aws-app' --labels 'ec2-app' --unattended
sudo ./svc.sh install
sudo ./svc.sh start