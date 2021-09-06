from kubernetes import client, config
import json
#config.load_kube_config()
config.load_incluster_config()
v1 = client.CoreV1Api()
ret = v1.list_pod_for_all_namespaces(watch=False)
pods_info=[]
for i in ret.items:
    if i.metadata.namespace=="monitoring":
        jsonString=json.dumps({"NAMESPACE":i.metadata.namespace,"POD_NAME":i.metadata.name,"POD_IMAGE":i.spec.containers[0].image, "POD_IP":i.status.pod_ip,"NODE_IP":i.spec.node_name})
        pods_info.append(jsonString)

#print(pods_info)
#for val in pods_info:
#print(pods_info[0])
# List 형태로 Json 저장
app=[]
for val in pods_info:
    app.append(val)
print(app)