from kubernetes import config, dynamic
from kubernetes.client import api_client
import json

def main():
    client = dynamic.DynamicClient(
        api_client.ApiClient(configuration=config.load_incluster_config())
    )
    api = client.resources.get(api_version="v1", kind="Node")

    Nodes_info=[]

    for item in api.get().items:
        node = api.get(name=item.metadata.name)
        jsonString= json.dumps({"NAME":node.metadata.name,"STATUS":node.status.conditions[3]["type"],"VERSION":node.status.nodeInfo.kubeProxyVersion,"OSImage":node.status.nodeInfo.osImage})
        Nodes_info.append(jsonString)
    print(Nodes_info)

if __name__ == "__main__":
    main()