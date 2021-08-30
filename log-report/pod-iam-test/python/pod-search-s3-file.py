import boto3

s3 = boto3.client('s3',region_name='ap-northeast-2')
response = s3.list_buckets()
print(response)

res = s3.get_object(Bucket='hanium-dev-loki',Key='log.json')
print(res)

