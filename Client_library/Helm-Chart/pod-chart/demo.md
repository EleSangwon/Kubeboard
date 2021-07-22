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
![helm-test1](https://user-images.githubusercontent.com/50174803/126628731-836134f2-8854-4db4-af60-db44e3c14ba2.PNG)
![helm-test2](https://user-images.githubusercontent.com/50174803/126628746-6d1b4499-1f7e-4f12-a05b-e1fd5f6bf11f.PNG)

# 2. YAML File

## values.yaml
![helm-test3](https://user-images.githubusercontent.com/50174803/126629149-36a0725a-1b47-43f2-bf0d-b86d7da5d20e.PNG)

## PV,PVC.yaml
![helm-test4](https://user-images.githubusercontent.com/50174803/126629220-05af7fc3-ccbb-48e5-80ee-b42e5415f649.png)

```
PV&PVC는, Status bound가 되면 helm upgrade 명렁어를 실행시켜도
결과가 업데이트 되지 않을 수 있으므로
uninstall 하고 사용해야 한다.
```
## configmap.yaml & Clusterrole.yaml
![helm-test5](https://user-images.githubusercontent.com/50174803/126629380-b47b5595-590c-45a9-888c-c99935829f19.png)
```
configmap은 deployment에 변화가 생겼을 떄 컨테이너의 이미지 네임이 동일하다면
파드가 재시작되지 않으므로 configmap에 암호화를 해서 해당 값이 변할 떄마다 파드가 재시작되도록 하기위해
추가했다. deployment에 annotations을 아직 적용하진 않았음.
아래 사진처럼 추가할 예정
```
![helm-test7](https://user-images.githubusercontent.com/50174803/126629946-0854eb54-7c03-4b4c-81f4-0fcbdab1849a.PNG)

## deployment.yaml
![helm-test6](https://user-images.githubusercontent.com/50174803/126629992-97823097-84f0-46bd-b4d7-4a1759475087.PNG)
