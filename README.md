# Kubeboard

## 프로젝트 시작 21.07.06 ~ 

## 프로젝트 내용
```
쿠버네티스 기반 수 많은 애플리케이션에 대한 로그시스템을 구축하여 
사용자가 애플리케이션에 대한 장애처리 대응을 수월하게 하도록 함.
또한, 클러스터 리소스 정보를 확인하고 인프라 리소스 모니터링까지 가능하도록 함.
```

## 기술스택
```
Kubernetes - 컨테이너 오케스트레이션 : AWS EKS ,Python Client Library

Helm - 쿠버네티스 패키지 매니저

Docker - 컨테이너 이미지 , Public Repository AWS ECR ( 제한 때문에 dockerhub 사용 X ) 

Loki & Grafana & Promtail - 로깅 아키텍처 

Prometheus & Grafana - 인프라 리소스 시각화

AWS - 퍼블릭 클라우드 플랫폼
- EC2 - 가상서버  EC2(EFS) - 파일시스템, EC2(ELB) - 로드 밸런서
- S3 - 파일 스토리지
- Route53 - 도메인 연결 및 라우팅 정책 할당 
- AWS Certificate Manager : 도메인에 연결될 SSL 인증서 발급 
- EKS : 관리형 쿠버네티스
- Lambda : 서비리스 플랫폼
- ECR : 이미지 레지스트리 
- IAM : AWS 리소스 액세스 제어 

CD - ArgoCD

shell-script : 설치해야 하는 라이브러리 및 파일 자동화

Frontend - nodejs, ejs, html, css 
```

## 구성도
### 00. 환경 세팅
![image](https://user-images.githubusercontent.com/50174803/131027510-a4ef3502-0a4f-4bc3-8130-1ceadb8af5d4.png)

### 01. Python Client Library 를 이용하여, Cluster 정보 조회 및 저장
![image](https://user-images.githubusercontent.com/50174803/131027555-c3272426-c3cc-447d-b767-6ce452d470b0.png)

```
1. python client library pod는 클러스터 내 정보를 조회하는 역할을 할당받는다
2. 할당받은 역할을 통해 클러스터 내 필요한 정보를 가져와서 AWS EBS(영구스토리지) 에 저장한다
3. 저장된 값을 Frontend Pod가 접근해서 값을 가져온다. 
```

### 02. 로깅 아키텍처 구축
![image](https://user-images.githubusercontent.com/50174803/131027638-bf8b61cf-7873-420f-8c51-e46214350a47.png)

```
1. AWS EKS 클러스터 안에서, 생성된 리소스에 대한 로그를 promtail에 저장한다
2. 저장된 값을 Loki로 보낸다. 
3. 그라파나를 통해 Loki의 정보를 시각화 및 분석 (LogQL)한다
```
### 02-1. 로깅 아키텍처에서 에러 로그 추출 방법
![image](https://user-images.githubusercontent.com/50174803/131027691-f19cb1c4-5f97-4a65-b15c-0f070bb4a83f.png)

### 03. 인프라 리소스 시각화
![인프라리소스](https://user-images.githubusercontent.com/50174803/126032478-0cb45a3a-2fa0-4485-935e-899693f5be53.png)

```
1. EKS Cluster 에 Metric Server 설치
2. 메트릭 서버는 클러스터 내 Metric(CPU. Memory 등)을 Prometheus로 전송
3. 그라파나를 이용하여 프로메테우스를 기반으로 인프라 리소스 시각화
```

### 04. 배포 방식 - Helm
![image](https://user-images.githubusercontent.com/50174803/131027790-268c5cad-98f1-4f75-a5d1-a7e861271d2b.png)

### 04-1. 배포 방식 - ArgoCD
![image](https://user-images.githubusercontent.com/50174803/131027827-5e148763-ab8f-43b7-b060-83554a28a062.png)

### 05. 도메인에 인그레스를 통해 서비스 연결
![도메인연결](https://user-images.githubusercontent.com/50174803/126032573-0a266b9b-9a10-491c-8830-825201fbe1a3.png)

```
전제조건 - AWS ELB 로드밸런서 , Ingress controller

1. Pod를 Service를 통해 외부에 노출시킨다.
2. 생성된 여러 개의 서비스를 인그레스를 통해 멀티패스로 접근가능 하도록 한다
3. 인그레스로 접근하는 서비스는 로드밸런서의 URL을 host 로 한다. 
4. 로드밸런서와 도메인을 연결하여 도메인주소+Path를 통해 서비스에 접근한다
www.도메인주소/Logging
www.도메인주소/Infra
www.도메인주소/cluster-info 
```

## Service Map
![서비스맵](https://user-images.githubusercontent.com/50174803/129410469-4cc9bbb2-eb4c-4190-86fd-39a972879d59.jpg)

## 현재 진행도 21.09.11 기준

* 인프라 구성 - 팀장 이상원 
```

[  완 료  ]

1. AWS 환경 세팅 및 쉘 스크립트를 통한 자동화

< AWS >
Cloud9 , IAM, EKS, CloudFormation

< Shell-Script >
default-setting.sh,promtail.sh, alb-ingress.sh add


2. 클라이언트 라이브러리

< Helm chart 리소스 > 
template(cronjob,deployment,service,HPA,RBAC) , ingress , pv&pvc, value.yaml

< ArgoCD를 이용한 배포 >

argocd를 통해 github repository 에 있는 helm-chart를 쿠버네티스에 배

< Main-Frontend Pod Test >

main-frontend 파드가 영구 볼륨에 저장된 값에 접근해서 프론트로 시각화 테스트 

3. 이미지 레지스트리 설정

AWS ECR 을 이미지 레지스트리로 사용하고, access 권한이 있을 때만 접근하도록 하기위해 Private registry 사용 

4. 로깅 아키텍처

- helm chart loki-stack 을 이용한 loki, promtail, grafana, prometheus 배포 

4-1. 로깅 아키텍처 - 에러 로그 추출

loki-stack helm chart에서 eventrouter 설정을 통해, 데몬셋으로 존재하는 promtail이 각 노드에서 
kubectl get event 에 관한 정보를 저장할 수 있도록 설정 (default로는 event에 관련된 로그를 가져올 수 없다)

< 쉘 스크립트 >
Shell Script 를 통해 특정 시간대, 특정 에러, 특정 네임스페이스에 해당되는 값을 AWS S3로 보내도록 설정
이 쉘 스크립트는 cron으로 설정하여 2021년 xx월 x일의 n0 - n9 까지 해당되는 에러를 추출한다.
ex) 2021.08.27:13:00 - 2021.08.27:13:09
    2021.08.27:13:10 - 2021.08.27:13:19
    ...
    ...

< AWS Lambda 를 통한 전처리  >

에러로그가 텍스트 파일 형태로, S3로 업로드 되면 텍스트 파일을 가져와 전처리를 Lambda 에서 하고
전처리된 값을 새로운 S3 버킷으로 보내도록 설정함

< 전처리된 값이 저장된 AWS S3에 접근 >

에러로그를 추출했고, 그 로그를 전처리했고 전처리된 값을 AWS S3에 저장시켰다.
이 값을 워커노드에 할당된 파드에 Spec에 IAM 역할을 추가한다. (IAM 역할은 S3에 access 해서 값 읽어오기)

파드는 원래 노드의 IAM 역할을 받아오지만, 노드의 IAM에는 AWS S3에 access 할 수 있는 권한이 없으므로
필요한 파드에 스펙에만 serviceaccount 에 annotation eks.amazonaws.com/role-arn 설정을 통해 접근하도록 한다.

5. alb ingress : SSL

EKS에서, 여러 개의 서비스를 인그레스로 묶어서 사용하기 위해서 ALB Ingress Controller를 사용하였음.
Route53으로 구매한 도메인을 AWS Certificate Manager 을 이용해 도메인에 대한 인증서를 발급받고,
ingress 리소스 annotaion에 SSL 에 대한 설정 후, http -> https 연결 되도록 함. 

6. EBS Converto to EFS 

워커노드 1개일 때는, 문제 없이 크론잡 리소스를 통해 가져온 정보를 영구볼륨 EBS에 잘 저장했다.
그러나 워커노드가 2개이상 일때, 특별한 스케줄링이 없다면 리소스 사용량에 따라 각 워커노드에 크론잡 리소스가 하나씩
할당이 된다. 워커노드가 3개인 경우, 프론트파드가 워커노드A에 할당되고 워커노드B와 워커노드C의 EBS 안에 필요한
값이 저장되면 프론트 파드는 워커노드A의 EBS에서 값을 찾으므로 원하는 값을 얻을 수 없다.
그래서 여러 개의 인스턴스가 하나의 파일 시스템을 사용하는 AWS EFS(NFS - 네트워크파일시스템과 동일한 서비스) 를 통해 워커노드를 여러 개 사용해도
같은 곳에서 값을 가져올 수 있게끔 하였다. 

7. 메인 프론트엔드 파드

CSS,Font 수정 등을 제외하고 기능적인 부분 모두 구현

8. HPA 수평적 파드 오토스케일링 적용

트래픽에 따라 파드의 레플리카(복제본) 개수가 Scale 되도록 설정하였음. 
트래픽이 증가하면 Scale Out 되어 레플리카 개수가 늘어나 트래픽을 분산시키고,
트래픽이 줄어들면 Scale down 되어 일정 시간 이후 레플리카 개수가 줄어든다.

================================================================================================================

[  미완  ]

9. 인프라 리소스 시각화

- dashboard.json 생성
- Alert-rule 

10. 로그 리포트 파드 테스트

- 프론트로부터, 웹 프론트엔드 이미지를 받아서 테스트 

```
## Main-Frontend 
![메인프론트](https://user-images.githubusercontent.com/50174803/132130876-91ea9f9e-4c9c-4a4c-b107-d23d570efb1d.jpg)

## Infra Resource monitoring
![대시보드](https://user-images.githubusercontent.com/50174803/132130890-126bf251-f5f6-496d-b681-7c75c973d3af.jpg)
