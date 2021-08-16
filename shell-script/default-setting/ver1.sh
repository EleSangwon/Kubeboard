#!/bin/bash
# Author: "sangwon lee" <lee2155507@gmail.com>

# This Script Install kubectl, eksctl, amazon linux2.

# Test for install k8s, eks, amazon linux2

echo "Install kubectl"
sudo curl --silent --location -o /usr/local/bin/kubectl \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl

if [[ "${?}" -ne 0 ]]
then
  echo "Kubectl Installing Failed."
  exit 1
fi
echo "Install kubectl success."

sudo chmod +x /usr/local/bin/kubectl
echo "Change mode kubectl"
kubectl

echo "Install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

if [[ "${?}" -ne 0 ]]
then
  echo 'Install eksctl Failed.'
  exit 1
fi

sudo mv -v /tmp/eksctl /usr/local/bin

eksctl version

echo "Install AWSCLI2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

if [[ "${?}" -ne 0 ]]
then
  echo "AWSCLI2 Installing Failed."
  exit 1
fi
echo "Install AWSCLI2 success."
