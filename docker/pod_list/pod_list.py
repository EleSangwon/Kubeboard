from kubernetes import client, config
import json
import boto3
# Configs can be set in Configuration class directly or using helper utility

#config.load_kube_config()
# 작성 - 2021-07-11 이상원 lee2155507#naver.com
# pod 내부에서 client library 이용하려면 load_incluster_config() 명령어 사용

config.load_incluster_config()
v1 = client.CoreV1Api()
ret = v1.list_pod_for_all_namespaces(watch=False)
pods_info=[]
for i in ret.items:
    if i.metadata.namespace=="sangwon":
        jsonString =json.dumps({"namespace :":i.metadata.namespace,"pod_ip :":i.status.pod_ip,"pod_name :":i.metadata.name})
        pods_info.append(jsonString)
    else:
        # 다른 네임스페이스 사용 시, 여기에 작성
        pass
for val in pods_info:
    print(val)
#exit()