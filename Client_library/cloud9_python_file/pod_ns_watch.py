from kubernetes import client, config, watch
from flask import Flask
import json


app = Flask(__name__)
@app.route('/')

def main():
    # Configs can be set in Configuration class directly or using helper
    # utility. If no argument provided, the config will be loaded from
    # default location.
    config.load_kube_config()

    v1 = client.CoreV1Api()
    count = 10
    w = watch.Watch()
    ns = []
    for event in w.stream(v1.list_namespace, timeout_seconds=10):
        #print("Event: %s %s" % (event['type'], event['object'].metadata.name))
        a = event['object'].metadata.name
        ns.append(a)
        
        count -= 1
        if not count:
            w.stop()
    #print("Finished namespace stream.")
    jsonString = json.dumps(ns)
    
    pods=[]
    for event in w.stream(v1.list_pod_for_all_namespaces, timeout_seconds=10):
        b= event['object'].metadata.name
        pods.append(b)
        """
        print("Event: %s %s %s" % (
            event['type'],
            event['object'].kind,
            event['object'].metadata.name)
        )
        """
        count -= 1
        if not count:
            w.stop()
    jsonStringpod = json.dumps(pods)
    #print("Finished pod stream.")
    
    return jsonStringpod,jsonString
        

if __name__ == '__main__':
    #a = main()
    #print(a)
    #jsonString = json.dumps(a)
    #print(jsonString)
    #print(type(jsonString))
    app.run(host='0.0.0.0',port=8080)