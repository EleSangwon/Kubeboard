#!/bin/bash
cat << END
Description : This Script is for the 2021 hanium ICT project.
OS          : amazon linux2
Usage       : helm for grafana
Author      : "sangwon lee" <lee2155507@gmail.com>
END

helmrepo()
{
    echo "Get Repo Info"
    kubectl create ns logging 2>> /dev/error.txt
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    helm upgrade --install loki --namespace=logging grafana/loki-stack \
    --set grafana.enabled=true,promtail.enabled=true
    
}
getsecret()
{
    echo "Grafana PASSWORD"
    kubectl get secret --namespace logging loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
}
deploy()
{
    echo "Deploy grafana service"
    echo "Access localhost:3000"
    kubectl port-forward --namespace logging service/loki-grafana 8080:80
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
echo -n "Do you want deploy grafana (y/n)?"
read answer
if [[ $answer == y ]]; then
    getsecret
    deploy
else
    echo "Cancle."
    exit 1
fi

exit 0




