from kubernetes import config, dynamic
from kubernetes.client import api_client
import yaml
import json
def main():
    #config.load_kube_config()
    # config.load_incluster_config()
    # Creating a dynamic client
    client = dynamic.DynamicClient(
        api_client.ApiClient(configuration=config.load_incluster_config())
    )

    # fetching the service api

    api = client.resources.get(api_version="v1", kind="Service")
    services_info=[]
    for item in api.get().items:
        service_ns = item.metadata.namespace
        service_name= item.metadata.name
        service_nodeport = item.spec.ports[0].nodePort
        service_port = item.spec.ports[0].port
        service_protocol = item.spec.ports[0].protocol
        service_type =item.spec.type
        if service_type == "LoadBalancer":
            service_type_IP = item.status.loadBalancer.ingress[0].hostname
        else:
            service_type_IP = item.spec.clusterIP
        jsonString = json.dumps({"NAMESPACE":service_ns,"NAME":service_name,"TYPE":service_type,"CLUSTER-IP":service_nodeport,"TYPE-IP": service_type_IP,"PORT":service_port,"NODEPORT":service_nodeport,"PROTOCOL":service_protocol})
        services_info.append(jsonString)
    print(services_info)
  
if __name__ == "__main__":
    main()