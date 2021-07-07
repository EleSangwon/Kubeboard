# Demo

EKS 클러스터 내 정보를 가져오기 위해 python SDK boto3를 이용한다.
EKS에서 가져온 정보들 (클러스터, 노드,파드 등)을 프론트엔드로 보내 매핑시켜야 하기 때문에
쉽게 코드를 수정하고, 접근할 수 있도록 AWS Lambda + API gateway를 이용한다.


1. Lambda 함수에 API 게이트웨이 
 
![lambda1](https://user-images.githubusercontent.com/50174803/124806911-2bee6980-df98-11eb-8c05-cce0167eb18d.png)

2. Lambda Code 

![lambda2](https://user-images.githubusercontent.com/50174803/124810944-e2ece400-df9c-11eb-8cb1-e0ede8671267.png)

3. API gateway Info

![api_gateway](https://user-images.githubusercontent.com/50174803/124811010-f7c97780-df9c-11eb-9ea9-0d3360ada730.PNG)

4. Postman Get 

![postman1](https://user-images.githubusercontent.com/50174803/124811048-00ba4900-df9d-11eb-8524-d9d72aa57744.png)
