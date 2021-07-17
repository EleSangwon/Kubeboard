# Kubernetes-Enterprise-Log-Analysis-System

## 프로젝트 내용
```
쿠버네티스 기반 수 많은 애플리케이션에 대한 로그시스템을 구축하여 
사용자가 애플리케이션에 대한 장애처리 대응을 수월하게 하도록 함.
```

## 기술스택
```
Kubernetes - 컨테이너 오케스트레이션 : AWS EKS , Python Client Library

Docker - 컨테이너 이미지 , Public Repository Dockerhub 사용 ( AWS ECR 도 고려중 ) 

Loki & Grafana & Fluentd - 로깅 아키텍처 

Prometheus & Grafana - 인프라 리소스 시각화

AWS - 퍼블릭 클라우드 플랫폼
- EC2 - 가상서버  EC2(EBS) - 영구 스토리지 EC2(ELB) - 로드 밸런서
- S3 - 파일 스토리지
- Route53 - 도메인 연결 및 라우팅 정책 할당
- EKS : 관리형 쿠버네티스
```

## 구성도
### 01. Python Client Library 를 이용하여, Cluster 정보 조회 및 저장
![클라이언트라이브러리 구성도](https://user-images.githubusercontent.com/50174803/126032225-c86e75cd-3c31-4be7-9416-a422cebe37ce.PNG)

```
1. python client library pod는 클러스터 내 정보를 조회하는 역할을 할당받는다
2. 할당받은 역할을 통해 클러스터 내 필요한 정보를 가져와서 AWS EBS(영구스토리지) 에 저장한다
3. 저장된 값을 Frontend Pod가 접근해서 값을 가져온다. 
```
