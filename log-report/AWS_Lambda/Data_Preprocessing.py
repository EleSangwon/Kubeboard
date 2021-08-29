import json
import re
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
    F_name = str.find('name',F_kind,F_kind+100)
    print(F_name)

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
    F_ns = str.find('namespace') + 14
    F_selflink = str.find('selfLink') - 5
    ns = str[F_ns:F_selflink]
    # KIND
    F_kind = str.find('kind') + 9
    F_sns = str.find('namespace', F_kind, F_kind + 100) - 5
    kind = str[F_kind:F_sns]
    # NAME
    F_name = str.find('name', F_sns+8, F_sns + 100)+9
    F_uid = str.find('uid',F_name,F_name+100)-5
    name = str[F_name:F_uid]
    # MESSAGE
    F_msg = str.find('message') + 12
    F_source = str.find('source', F_msg, F_msg + 500)
    message = str[F_msg:F_source]
    # HOST
    F_host = str.find('host') + 9
    F_timestamp = str.find('firstTimestamp', F_host, F_host + 200) - 6
    host = str[F_host:F_timestamp]
    # TIME
    F_time = str.rfind('time') + 7
    time = str[F_time:len - 13]
    if F_ns < 100:
        return -1

    jsonString = json.dumps({"NAMESPACE":ns,"KIND":kind,"NAME":name,"MESSAGE":message,"HOST":host,"TIME":time})
    return jsonString

f = open('log.txt','r')
line_num=1
line=f.readline()
error_info = []
error_info.append(Find_value(line,len(line)))

while line:
    line=f.readline()
    line_num+=1
    line_fliter = line[54:]
    line_len = len(line_fliter)
    if Find_value(line,len(line)) != -1:
        error_info.append(Find_value(line,len(line)))
#print(error_info)
for i in range(len(error_info)):
    print(error_info[i])
