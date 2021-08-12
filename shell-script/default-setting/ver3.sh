#!/bin/bash
cat << END
Description : This Script is for the 2021 hanium ICT project.
Usage       : For AWS EKS, Install kubectl, eksctl, awscli2, helm, argocd
OS          : amazon linux2
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

Helm()
{
    echo "Install Helm"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    helm
    echo "Install Helm success."
}

BAR="===================================="
echo "${BAR}"
echo "What do you want ? "
echo "${BAR}"
echo "[0] Install kubectl & eksctl"
echo "[1] Install Amazon CLI2"
echo "[2] Install Helm "
echo "[3] Install Ingress Controller"
echo "${BAR}"
echo -n "Please insert a key as you need = "
read choice
echo "${BAR}"
case $choice in
        0) K8s;;
        1) Amazon;;
        2) Helm;;
        3) echo "3";;
        *) echo "Bad choice"
                exit 1
esac

## issue : wget 으로 eksctl cluster 추가 ?