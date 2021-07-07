#Demo

클라이언트 라이브러리를 이용해 EKS 내부 정보를 가져오는 방법에는 현재로는 3가지 정도 방안이
떠오르는데 

첫 번째, Lambda + API gateway 

두 번쨰, Flask로 API Server 띄우고 접근 (속도가 느리다)

세 번쨰, 주기적으로 Cloud9에서 python 을 실행시키는 cron job 이용해 스케줄링하고
추출한 값을 AWS-S3에 저장시킨 후, Lambda + S3 + API gateway로 접근

첫 번쨰 방법은 python SDK인 boto3를 사용하면 EKS cluster & nodegroup describe 정도밖에 없기 때문에
K8S API를 이용해야 하는데 Lambda에서 사용하는 것에 어려움을 겪는 중 

이 데모에서는 두 번쨰 방법으로 진행

#1. Cloud9에서 Python Flask 사용

#2. Cloud9에 접근하기 위해 포트 설정(여기서는 8080)

#3. EC2에 퍼블릭 DNS나 Cloud9의 preview를 통해 확인하려면
보안그룹 설정 필요 Inbound Rule - Custom TCP 8080 

#4. Flask 서버에 접근하여 값 확인 

