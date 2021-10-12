#!/bin/bash
cat << END
Description : This Script is for the 2021 hanium ICT project 
OS          : amazon linux2
Usage       : Install Loki&Promtail&Grafana&Prometheus Using Helm.
Author      : "sangwon lee" <lee2155507@gmail.com>
END

helmrepo()
{
    echo "Get Repo Info"
    kubectl create ns monitoring 2>> /dev/error.txt
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    helm upgrade --install loki --namespace=monitoring grafana/loki-stack \
    --set grafana.enabled=true,promtail.enabled=true,prometheus.enabled=true
    
}
getsecret()
{
    echo "Grafana PASSWORD"
    kubectl get secret --namespace monitoring loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
}
patch()
{
    echo "Patch SVC TYPE ClusterIP -> LoadBalancer"
    kubectl patch svc loki-prometheus-server --namespace monitoring -p '{"spec": {"type": "LoadBalancer"}}'
    kubectl patch svc loki-grafana --namespace monitoring -p '{"spec": {"type": "LoadBalancer"}}'
}

BAR="=========================="
echo "${BAR}"
echo "Get Repo Info - Grafana"
echo -n "Do you want install helm-chart for Loki-stack (y/n)?"


read choice
if [[ $choice == y ]]; then
    helmrepo
else
    echo "Cancle."
fi
sleep 5s
echo -n "Do you want deploy loki-stack (y/n)?"
read answer
if [[ $answer == y ]]; then
    getsecret
    patch
else
    echo "Cancle."
    exit 1
fi

exit 0




