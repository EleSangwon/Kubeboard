Demo2 

2021-07-11 작성자 이상원 

클라이언트 라이브러리 앱에서 받아온 정보를 프론트 앱에서 이용하는 방법

여기서 클라이언트 라이브러리가 가져오는 정보는 파드의 이름, 네임스페이스, IP

#1. 파이썬 클라이언트 라이브러리 코드를, 도커로 이미지화

#2. (Public) 도커 허브에 업로드 하거나 AWS ECR 사용 ( 도커 허브에 하루 제한량 때문에 ECR이 나을 듯)

#3. 해당 이미지를 기반으로 파드를 생성

#3-1. 이 때 생성된 파드에는 pod 를 조회할 수 있는 권한이 없다

#3-2. 따라서, clusterRole, clusterRoleBinding 을 통해 sangwon 이라는 네임스페이스에서
pod를 조회할 수 있도록 yaml 생성 후 적용시켜야 한다.
![1](https://user-images.githubusercontent.com/50174803/125182255-6e899d80-e247-11eb-9d1d-35aac9aad626.PNG)

#4. 파드 생성 전, yaml 파일에 영구 스토리지를 추가해야한다.
aws는 기본적으로 EBS를 제공하기 떄문에 PV.yaml 생성할 필요는 없고 PVC.yaml 생성한 뒤
pod_list.yaml 에 volumes 설정을 하면 Bound 된다.
![2](https://user-images.githubusercontent.com/50174803/125182267-9547d400-e247-11eb-8ee3-93e5ca8320c7.PNG)

#4-1. 파드는 임시 스토리지이기 때문에, 파드가 재시작되거나 삭제된다면 파드 내 데이터가 사라지므로
영구 스토리지를 사용해야 한다. 

#4-2. 영구 스토리지를 사용하는 이유는, 클라이언트 라이브러리앱은 python pod_list.py 명령어를 통해
리소스를 가져오는데 이 값을 영구 스토리지에 저장하고, 저장한 값을 프론트에서 접근해야되기 때문이다

#4-3. pod_list.yaml 에서 command 에는 ["sh","-c"] , args ["python pod_list.py > /app-data/pod_resource.txt"] 방식으로 해야한다
["/bin/sh","-c"] 로 하면 python 코드가 실행이 안된다
![3](https://user-images.githubusercontent.com/50174803/125182282-b6a8c000-e247-11eb-9d3f-66a9bca83737.PNG)

#5. 테스트를 위해 프론트 앱은 nginx 를 이용한다

#5-1. 이때, 같은 볼륨에 접근해야 하므로 volumeMounts의 값은 클라이언트 라이브러리 앱과 동일하게 한다.
![4](https://user-images.githubusercontent.com/50174803/125182302-e48e0480-e247-11eb-98d7-27639c06f284.png)

#5-2. 프론트 앱에 접근하기 위해 exec -it 명령어를 이용한다
![5](https://user-images.githubusercontent.com/50174803/125182351-523a3080-e248-11eb-990a-56b161613bcd.PNG)

#5-3. index.html 을 찾아서, 클라이언트 라이브러리 앱을 실행시켜 얻은 pod_resource.txt 를
index.html에 넣는다 
(클라이언트 라이브러리 앱을 실행시켜 생긴 텍스트파일을 app-data에 저장시켰는데,
편의를 위해 /usr/share/nginx/html 로 옮겼다.)
![6](https://user-images.githubusercontent.com/50174803/125182396-ac3af600-e248-11eb-8b79-fd48b29151b5.PNG)

#5-4. 결과를 확인하기 위해 프론트 앱을 서비스로 만든다(expose pod) , type=LoadBalancer
![11](https://user-images.githubusercontent.com/50174803/125182758-b3173800-e24b-11eb-99c8-acae576d64d4.PNG)

#6. 결과를 확인

첫 번쨰, python 명령어를 쳤을 떄 결과 확인 (좀 수정을 했어서, 결과 값이 아래와 약간다름 원래는 동일) 
![8](https://user-images.githubusercontent.com/50174803/125182461-210e3000-e249-11eb-9254-ea6014c41ab3.png)

두 번째, 클라이언트 라이브러리 앱 실행 결과 확인
![9](https://user-images.githubusercontent.com/50174803/125182489-5450bf00-e249-11eb-8127-74f0d2ddbb62.PNG)

세 번쨰, 프론트에서 값 확인
![10](https://user-images.githubusercontent.com/50174803/125182509-8104d680-e249-11eb-94bd-12f31b810424.PNG)

