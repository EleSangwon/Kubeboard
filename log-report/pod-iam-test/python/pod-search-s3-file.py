import boto3

s3 = boto3.client('s3',region_name='ap-northeast-1')
#response = s3.list_buckets()
#print(response)

res = s3.get_object(Bucket='kubeboard-preprocessing-data',Key='preprocessing.txt')
#print(res['Body'].read())

result = res['Body'].read()
print(result)