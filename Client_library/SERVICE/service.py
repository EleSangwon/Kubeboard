from kubernetes import config, dynamic
from kubernetes.client import api_client
import yaml
import json
def main():
    # Creating a dynamic client
    client = dynamic.DynamicClient(
        api_client.ApiClient(configuration=config.load_incluster_config())
    )

    # fetching the service api
    
    api = client.resources.get(api_version="v1", kind="Service")
    services_info=[]
    service_ns = api.get().items[0]['metadata']['namespace']
    service_name = api.get().items[0]['metadata']['name']
    
    service_nodeport = api.get().items[0]['spec']['ports'][0]['nodePort']
    service_port = api.get().items[0]['spec']['ports'][0]['port']
    service_protocol = api.get().items[0]['spec']['ports'][0]['protocol']
    service_targetport = api.get().items[0]['spec']['ports'][0]['targetPort']
    service_hostname =  api.get().items[0]['status']['loadBalancer']['ingress'][0]['hostname']
    

    jsonString = json.dumps({"NAMESPACE":service_ns,"NAME":service_name,"HOSTNAME":service_hostname,"PROTOCOL":service_protocol,"NODEPORT":service_nodeport,"TARGETPORT":service_targetport,"PORT":service_port})
    
    services_info.append(jsonString)
    print(services_info)
    

if __name__ == "__main__":
    main()