# Helm Demo - Pod 

## Namespace가 Client-library 곳에서 Pod 의 리소스 정보 Helm 을 통해 가져오기

### 1. Cloud9 을 통해 확인 

```
[Client-library의 Pod 확인]
kubectl -n client-library get pods

[Client-library의 Pod 개수 추가]
kubectl -n client-library run helm-test --image=nginx

(deployment가 없으므로 scale 하지 않고 imperative하게 생성)

[추가된 Pod 확인]
kubectl -n client-library get pods

[helm list 확인]
helm list

[default namespace에서 모든 리소스 확인]
kubectl get all -n default

[helm Create]
helm create mychart
해당 명령어를 실행시킨 이후, 
mychart - values.yaml 수정
mychart/template - deployment.yaml 수정
mychart/template - pv.yaml , pvc.yaml, cluster-role.yaml, configmap.yaml Add

[helm install]
mychart를 생성한 이후, yaml 파일을 수정한 이후 배포한다.

helm install mychart .  ( -f values.yaml 이나 --set args 를 더할 수 있음 ) 

[helm으로 배포된 결과를 kubedtl 로 확인]
kubectl get all -n default

default namespace에 deployment가 생기도록 설정하였음

[values.yaml 에서 command한 결과 확인]

values.yaml에 command 를 실행시켜 pvc내에
client-resource 디렉토리에 Pod_list.json 형태로 값이 저장되도록 함
저장되는 값은, Client-library 내에 있는 Pod의 리소스

결과를 확인하기 위해, default 네임스페이스에서 같은 영구볼륨을 가진
pod를 생성하여 exec 명령어로 컨테이너에 접근해 확인

Pod의 리소스를 가져와서 저장시키는 애플리케이션은 python 명령어를 실행 후
Completed 되어 exec 접근이 안된다.

[exec 명령어로 컨테이너에 존재하는 값 확인]

``` 
