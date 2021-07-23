# Helm Chart 를 이용해 Client-library Resource를 한번에 가져오기


## 1. 현재 상태 확인
```
[helm 확인]
helm list

[default namespace 정보 확인]
kubectl get all

[PV,PVC 정보 확인]
kubectl get pv,pvc
```

## 2. helm chart 생성
```
[Chart 생성]
helm create client-resource

[안쓰는 파일 삭제]
templates 디렉토리를 삭제한 뒤에 다시 만든다. 
사용할  deployment가 여러 개 이기 때문에 deployment라는 디렉토리도 생성
mkdir -p templates/deployment 

[추가할 파일]
Client-library resource를 조회하기 위해, clusterrole&clusterrolebinding yaml add
영구 저장소를 사용하므로 , PV&PVC yaml add
```

## 3. values.yaml & deployment
```
values.yaml 아래 사진처럼 구성한다.
```
```
deployment 아래사진 처럼 구성한다.
```

## 4. helm install --dry-run 
```
helm install 명령어로 결과를 kubectl 명령어로 조회하기 이전에
먼저 helm install --debug --dry-run <name> . 으로 결과를 확인해본다
```

## 5. helm install
```
[배포]
helm install client-resource .

[helm chart 확인]
helm list

[kubectl로 리소스 조회]
kubectl get all
```

## 6. 결과 확인
```
helm install 로 생성된, 파드는 클라이언트 라이브러리를 이용하여
pod, node, namespace, service에 해당되는 정보를 가져와서
영구 저장소에 저장시킨다. 

따라서 결과 값을 확인하기 위해 같은 PV,PVC를 사용하는 
nginx 이미지로 파드를 생성하여 exec 로 결과가 생겼는 지 확인해본다.
```
