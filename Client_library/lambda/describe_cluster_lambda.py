import json
import boto3


def describe_cluster(cluster_name):
    eks = boto3.client('eks',region_name='ap-northeast-2')
    print("EKS :",eks)
    try:
        response = eks.describe_cluster(name=cluster_name)
    except Exception as e:
        # e.response['Error']['Code'] == 'ResourceNotFoundException'
        return None
    return response['cluster']


def main():
    test_cluster_name = 'Kubernetes-Enterprise-Log-Analysis-System'
    result = describe_cluster(test_cluster_name)
    if result is None:
        print('ERROR: Could not retrieve information about cluster {}'.format(test_cluster_name))
    else:
        value = result['name']
        print('Cluster Name: {}'.format(result['name']))
        print('Status: {}'.format(result['status']))
        return value


def lambda_handler(event, context):
    # TODO implement
    
    value = main()
    return {
        'statusCode': 200,
        'body': json.dumps({"name:":value})
    }
