#!/bin/bash
cat << END
Description : This script is sk cnc eks demo script.
Usage       : For AWS EKS, Install kubectl, eksctl, awscli2 and deploy Cluster
OS          : amazon linux2
version     : "1.19"
Author      : "sangwon lee" <lee2155507@gmail.com>
END

K8s(){
echo "Install kubectl"
sudo curl --silent --location -o /usr/local/bin/kubectl \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
if [[ "${?}" -ne 0 ]]
then
        echo "Kubectl Install Failed."
        exit 1
fi
echo "Install kubectl success"
sudo chmod +x /usr/local/bin/kubectl
kubectl
sudo yum install -y jq
sudo yum install -y bash-completion

echo "Install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

if [[ "${?}" -ne 0 ]]
then
        echo "eksctl Install Failed."
        exit 1
fi
sudo mv -v /tmp/eksctl /usr/local/bin
eksctl version
}

Amazon(){
echo "Install AWSCLI2"
#sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
echo "Install awscli2 success."
}

Iac()
{
    wget https://raw.githubusercontent.com/EleSangwon/Kubernetes-Enterprise-Log-Analysis-System/main/Iac/sk-cnc-dev-cluster.yaml
}


BAR="===================================="
echo "${BAR}"
echo "What do you want ? "
echo "${BAR}"
echo "[0] Install kubectl & eksctl"
echo "[1] Install Amazon CLI2"
echo "[2] Install EKS Cluster"
echo "${BAR}"
echo -n "Please insert a key as you need = "
read choice
echo "${BAR}"
case $choice in
        0) K8s;;
        1) Amazon;;
        2) Iac;;
        *) echo "Bad choice"
                exit 1
esac
