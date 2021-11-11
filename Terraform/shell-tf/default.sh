#!/bin/bash
cat << END
Description : This Script is for the 2021 GroundX Bolt Demo.
Usage       : For AWS EKS, Install kubectl, eksctl, awscli2, helm, argocd
OS          : amazon linux2
Author      : "sangwon lee" <lee2155507@gmail.com>

END


echo "Install kubectl"
sudo curl --silent --location -o /usr/local/bin/kubectl \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
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


echo "Install AWSCLI2"
#sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
echo "Install awscli2 success."
echo "Install Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm
echo "Install Helm success."


echo "Install Argocd"
kubectl create namespace argocd 2>> /home/ec2-user/environment/error.txt
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 2>> /home/ec2-user/environment/error.txt
sleep 10
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' 2>> /home/ec2-user/environment/error.txt
sleep 3m
echo "========== Check ==========="
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
argocd
ARGOCD_SERVER=`kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2` 
echo "==== ARGOCD_SERVER ===="
echo "${ARGOCD_SERVER}"
echo "==== ARGOCD_PASSWORD ===="
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    
echo "Kubernetes metrics-server install"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get deployment metrics-server -n kube-system

echo "===== Done ====="