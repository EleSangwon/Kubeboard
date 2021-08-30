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
- EC2 - 가상서버  EC2(EBS) - 영구 스토리지 EC2(ELB) - 로드 밸런서
- S3 - 파일 스토리지
- Route53 - 도메인 연결 및 라우팅 정책 할당
- EKS : 관리형 쿠버네티스

CD - ArgoCD

shell-script : 설치해야 하는 라이브러리 및 파일 자동화

Frontend - React, html, css 
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

## 현재 진행도 21.08.27 기준

* 인프라 구성 - 팀장 이상원 
```
1. 환경 세팅
< 완료 >
Cloud9 , IAM, EKS, CloudFormation , default-setting.sh

< 미완 >
advanced-setting.sh 


2. 클라이언트 라이브러리
< 완료 >
Helm chart를 통한 리소스 배포
template(cronjob,deployment,service) , serviceaccount, clusterrole&binding, ingress , pv&pvc, value.yaml

< 완료 >
Helm chart에 ECR Private image에 대한 

< 완료 >
main-frontend 파드가 영구 볼륨에 저장된 값에 접근해서 프론트로 시각화 테스트 

3. 로깅 아키텍처
< 완료 >
helm chart loki-stack 을 이용한 loki, promtail, grafana, prometheus 배포 

< 미완 >
프론트로부터, 웹 프론트엔드 이미지를 받아서 테스트 

3-1. 로깅 아키텍처 - 에러 로그 추출
< helm 배포 완료 >
loki-stack helm chart에서 eventrouter 설정을 통해, 데몬셋으로 존재하는 promtail이 각 노드에서 
kubectl get event 에 관한 정보를 저장할 수 있도록 설정 (default로는 event에 관련된 로그를 가져올 수 없다)

< 쉘 스크립트 완료 >
Shell Script 를 통해 특정 시간대, 특정 에러, 특정 네임스페이스에 해당되는 값을 S3로 보내도록 설정
이 쉘 스크립트는 cron으로 설정하여 2021년 xx월 x일의 n0 - n9 까지 해당되는 에러를 추출한다.
ex) 2021.08.27:13:00 - 2021.08.27:13:09
    2021.08.27:13:10 - 2021.08.27:13:19
    ...
    ...

< 완료 >
로그를 S3로 가져와 전처리를 Lambda 에서 하고 전처리된 값을 새로운 S3 버킷으로 보내는 과정(테스트)은 완료했고,
Lambda에서 로그 전처리 부분이 남았음.

4. 인프라 리소스 시각화
< 미완  & 미정 >
dashboard.json 생성
Alert-rule 


5. 부하 테스트
< 미완 >
수평적 파드 오토스케일링 (HPA) 를 적용해 시스템 부하상태에 따른 Pod Auto Scaling
노드 오토스케일링


2021.09.02 까지,
부하테스트 , advanced-setting.sh 

```

* 프론트 앤드 - 팀원 황서희
```
1. 클러스터 상태 시각화 웹페이지
< 미완 >

- prometheus, grafana 아이콘 추가 후 클릭 시, 새 탭이 켜지고 연결

- UI / UX 적용

- dropdown 화살표 만들기

- 리스트 형태의 json에 대한 처리

- 메인 페이지에 쿠버네티스 아이콘 추가

- docker 이미지 

```
![KakaoTalk_20210823_214738587](https://user-images.githubusercontent.com/50174803/131030358-0fdd8006-f095-4944-b922-3f305eafa204.png)
