import boto3
import re

s3 = boto3.client('s3',region_name='ap-northeast-1')
res = s3.get_object(Bucket='kubeboard-preprocessing-data',Key='preprocessing.txt')
result = res['Body'].read()

val = []
for line in result.splitlines():
    each_line = line.decode('utf-8')
    log_text = re.sub('[=+#/\?^$.@*\※~&%ㆍ!』\\‘|\(\)\[\]\<\>`\'…》]', '', each_line)
    log_text_a = log_text.replace('\\','')
    val.append(log_text_a)
    find_message = log_text_a.find("MESSAGE")+9
    find_host = log_text_a.find("HOST")-4
    temp=""
    for i in range(len(log_text_a)):
        if i>=find_message and i<=find_host:
            if i == find_message+1:
                temp+="\""
            elif i == find_host:
                temp+="\""
            elif log_text_a[i]=="\"":
                pass
            else:
                temp+=log_text_a[i]
        else:
            temp+=log_text_a[i]
    print(temp)
    
