from kubernetes import client, config
import json
import boto3
# Configs can be set in Configuration class directly or using helper utility
config.load_kube_config()

s3=boto3.client('s3',region_name='ap-northeast-2')
response=s3.list_buckets()
#print(response)
buckets = [bucket['Name'] for bucket in response['Buckets']]
print(buckets)
v1 = client.CoreV1Api()
print("Listing pods with their IPs:")
ret = v1.list_pod_for_all_namespaces(watch=False)
pods_info=[]
for i in ret.items:
    if i.metadata.namespace=="sangwon":
        print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))
        jsonString =json.dumps({"namespace :":i.metadata.namespace,"pod_ip :":i.status.pod_ip,"pod_name :":i.metadata.name})
        pods_info.append(jsonString)
        #print(jsonString)
print(pods_info)

for val in pods_info:
    print(val)
