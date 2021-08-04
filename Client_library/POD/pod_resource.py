from kubernetes import client, config
import json
import boto3

config.load_kube_config()
v1 = client.CoreV1Api()
ret = v1.list_pod_for_all_namespaces(watch=False)
pods_info=[]
for i in ret.items:
    if i.metadata.namespace=="client-library":
        jsonString=json.dumps({"NAMESPACE":i.metadata.namespace,"POD_NAME":i.metadata.name,"POD_IMAGE":i.spec.containers[0].image, "POD_IP":i.status.pod_ip,"NODE_IP":i.spec.node_name})
        pods_info.append(jsonString)

print(pods_info)
# List 형태로 Json 저장 

#for val in pods_info:
#    print(val)
