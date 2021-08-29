import json
import boto3
import os
import uuid

def Find_ns(str):
    F_ns = str.find('namespace')+14
    F_selflink = str.find('selfLink')-5
    ns = str[F_ns:F_selflink]
    return ns

def Find_kind(str):
    F_kind = str.find('kind') + 9
    F_sns = str.find('namespace', F_kind, F_kind + 100) - 5
    kind = str[F_kind:F_sns]
    return kind
def Find_name(str):
    F_kind = str.find('kind') + 9
    F_sns = str.find('namespace', F_kind, F_kind + 100) - 5
    F_name = str.find('name', F_sns+8, F_sns + 100)+9
    F_uid = str.find('uid',F_name,F_name+100)-5
    name = str[F_name:F_uid]
    return name

def Find_message(str):
    F_msg = str.find('message') + 12
    F_source = str.find('source', F_msg, F_msg + 500)
    message = str[F_msg:F_source]
    return message
def Find_host(str):
    F_host = str.find('host') + 9
    F_timestamp = str.find('firstTimestamp', F_host, F_host + 200) - 6
    host = str[F_host:F_timestamp]
    return host

def Find_time(str,len):
    F_time = str.rfind('time') + 7
    time = str[F_time:len - 13]
    return time
    
def Find_value(str,len):
    # NAMESPACE
    Find_ns(str)
    # KIND
    Find_kind(str)
    # NAME
    Find_name(str)
    # MESSAGE
    Find_message(str)
    # HOST
    Find_host(str)
    # TIME
    Find_time(str,len)
    # Exception 
    F_ns = str.find('namespace') + 14
    if F_ns < 100:
        return -1
    jsonString = json.dumps({"NAMESPACE":Find_ns(str),"KIND":Find_kind(str),"NAME":Find_name(str),"MESSAGE":Find_message(str),"HOST":Find_host(str),"TIME":Find_time(str,len)})
    return jsonString
    
def lambda_handler(event, context):
    # TODO implement
    print("TEST Start !!!!!")
    s3=boto3.client('s3',region_name='ap-northeast-2')
    #obj= s3.get_object(Bucket='hanium-dev-loki',Key='log.json')
    #print(obj["Body"].read())
    try:
        for record in event['Records']:
            bucket =record['s3']['bucket']['name']
            key = record['s3']['object']['key']
            print("Bucket name :",bucket)
            print("Bucket Key :",key)
            obj = s3.get_object(Bucket=bucket,Key=key)
            log = obj["Body"].read() # 이렇게 하면 class type 이 byte
            #log = obj["Body"].read().decode('utf-8') # 이렇게 하면 class type str
            post_id = str(uuid.uuid4())
            output=os.path.join('/tmp/',post_id)
            error_info = []
            
            with open(output,'wb') as f:
                data = log
                f.write(data)
            file = open(output,'r')
            line = file.readline()
            error_info.append(Find_value(line,len(line)))
            while line:
                line = file.readline()
                if Find_value(line,len(line)) != -1:
                    error_info.append(Find_value(line,len(line)))
            
            for i in range(len(error_info)):
                print(error_info[i])
            
            
            













            
            # 전처리를 해야한다.
            # 전처리한 값을 새로운 버킷에 보낸다.
            #adsdassdaasd aa->namespace, name,error,reason 
            '''
            filename = "flog.txt"
            lambda_path="/tmp/" + filename
            
            filter_data_bucket = '/hanium-dev-loki/Filtered_data/'
            s3_path=filter_data_bucket+'flog.txt'
            with open(filename) as f:
                string = log.read()
            s3.Bucket(filter_data_bucket).put_object(Key=s3_path,Body=string)
            '''
            
            
    except Exception as e:
        print(e)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
