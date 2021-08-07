첫 번째 시도

작업이 실패하게 하려면 0이 아닌 코드로 종료해야 한다.
python 코드로 
exit(1)

---------------
두 번째 시도

리소스 제한을 걸어 Pending이 되도록 한다.
kubectl describe 로는 Pending 상태의 원인이 뜬다.

---------------
세 번째 시도

ImagePullBackoff 가 나오도록 이미지 이름을 일부러 다른걸로 설정

---------------

네 번째 시도

nginx 파드를 생성하고, nginx 내에 index.html 
<a href="URL"> 에 URL 부분을 일부러 틀리게 설정
nginx 서비스를 생성해서 접근 -> 사이트에 연결할 수 없음

--------------

위 케이스 모두 로키에서 에러 로그를 볼 수없다.
kubectl describe 로 볼 수 있는 에러는 Loki에는 뜨지 않는다.

