#!/bin/bash
cat << END
Description : This Script is for the 2021 hanium ICT project.
OS          : amazon linux2
Usage       : alb ingress for Ingress
Author      : "sangwon lee" <lee2155507@gmail.com>
END


export AWS_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
export AWS_REGION=${AWS_ZONE::-1}
export AWS_DEFAULT_REGION=${AWS_REGION}
export CLUSTER=`eksctl get cluster --region=${AWS_REGION} | awk '{print $1}' | tail -1`
export RANDOM=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w 7 | sed 1q)
export POLICY=AWSLoadBalancerControllerIAMPolicy
export IAMPOLICY=${POLICY}${RANDOM}
export ARN=arn:aws:iam::238856124133:policy/${IAMPOLICY}

albIngress()
{
    eksctl utils associate-iam-oidc-provider \
    --region ${AWS_REGION} \
    --cluster ${CLUSTER} \
    --approve
    
    curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
    
    aws iam create-policy \
    --policy-name ${IAMPOLICY} \
    --policy-document file://iam-policy.json
    
    eksctl create iamserviceaccount \
    --cluster=${CLUSTER} \
    --region=${AWS_REGION} \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=${ARN} \
    --approve

}

Deploy()
{
    helm repo add eks https://aws.github.io/eks-charts
    helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=${CLUSTER} --set region=${AWS_REGION} -n kube-system --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

}
Test()
{
    kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/examples/2048/2048_full.yaml
    kubectl get ingress ingress-2048 -n game-2048
}
Delete()
{
    kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/examples/2048/2048_full.yaml
}
BAR="===================================="
echo "${BAR}"
echo "What do you want ? "
echo "${BAR}"
echo "[0] Setting Alb-ingress"
echo "[1] Deploy ALB"
echo "[2] Test "
echo "[3] Delete "
echo "${BAR}"
echo -n "Please insert a key as you need = "
read choice
echo "${BAR}"
case $choice in
        0) albIngress;;
        1) Deploy;;
        2) Test;;
        3) Delete;;
        *) echo "Bad choice"
                exit 1
esac
