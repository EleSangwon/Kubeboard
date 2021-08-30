
from kubernetes import client, config, watch
import json

def main():
    config.load_incluster_config()
    v1 = client.CoreV1Api()
    count = 10 # NS 개수에 따라서 값 수정해야함
    w = watch.Watch()
    namespace_info=[]
    for event in w.stream(v1.list_namespace, timeout_seconds=5):
        ns_name= event['object'].metadata.name
        ns_status = event['object'].status.phase
        ns_kind = event['object'].kind
        ns_dict = {"KIND":ns_kind,"NAME":ns_name,"STATUS":ns_status}
        namespace_info.append(ns_dict)
        count -= 1
        if not count:
            w.stop()
    
    new_list =[]
    for item in namespace_info:
        item["POD_NUMBER"]=0
        new_list.append(item)
    
    count = 20 # Pod 개수에 따라서 값 수정해야함.
    for event in w.stream(v1.list_pod_for_all_namespaces, timeout_seconds=5):
        pod_ns = event['object'].metadata.namespace
        for item in new_list:
            if pod_ns ==item["NAME"]:
                item["POD_NUMBER"]+=1
        count -= 1
        if not count:
            w.stop()
        
    ns_json = json.dumps(new_list)
    print(ns_json)
   
if __name__ == '__main__':
    main()