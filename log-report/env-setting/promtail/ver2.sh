#!/bin/bash
cat << END
Description : This Script is for the 2021 hanium ICT project.
Usage       : Find Promtail daemonset-pod <eventrouter> for error log export .
OS          : amazon linux2
Author      : "sangwon lee" <lee2155507@gmail.com>
END
# 1. First Filter by date time.
t=T
c=:
time=$(date +%Y-%m-%d)$t$(date +%H)${c}$(date +%M)
Time=`echo ${time:0:-1}`
#echo "${Time}"
# 2. Get the number of promtail daemonsets
daemonset=`kubectl get pods | grep promtail | wc -l`
# 3. Repeat the number of times
for i in $(seq 1 ${daemonset}); do
  # List the names of promtail pods
  prom=`kubectl get pods | grep promtail | awk '{print $1}' | head -$i | tail -1`
  #echo "${prom}"
  pod=`kubectl exec -it ${prom} -- ls /var/log/pods | grep eventrouter`
  val=`echo $?`
  # 4. If the promtail Pod has an eventrouter, and then save that Pod
  if [ "${val}" -eq 0 ]; then
  # 5. Save promtail pod (eventrouter), and Save eventrouter name
    ans=${prom}
    anv=${pod}
  fi
done
#echo ${ans}
#echo ${anv}

# Failed below this.I do not know the reason.
#cnt1=`kubectl exec -it ${ans} -- cat /var/log/pods/${pod}/kube-eventrouter/0.log | grep problem-app | grep error| wc -l`
#echo "${cnt1}"
# Success below this.

# 6. Number of Pods per Specified Time
cnt=`kubectl exec -it ${ans} -- cat /var/log/pods/kube-system_eventrouter-5874bd6747-ktxgz_0e74a342-706f-4358-9e13-47cf43ba7958/kube-eventrouter/0.log | grep problem-app | grep error | grep ${Time} | wc -l`
#echo "${cnt}"

# 7. Save log for the filtered period in json format
for i in $(seq 1 ${cnt}); do
  contents=`kubectl exec -it ${ans} -- cat /var/log/pods/kube-system_eventrouter-5874bd6747-ktxgz_0e74a342-706f-4358-9e13-47cf43ba7958/kube-eventrouter/0.log | grep problem-app | grep error | grep ${Time} | head -$i | tail -1 >>log.json`
  echo "${contents}"
done
# 8. Log to s3 bucket
aws s3 cp log.json s3://hanium-dev-loki 2> /home/ec2-user/environment/error-log/error.txt
val=`echo $?`
if [ "${val}" -eq 0 ]; then
  echo "Upload Success log file to S3 bucket."
else
  echo "Failed log upload to S3 bucket."
  exit 1
fi
# 9. Log file remove
rm log.json
exit 0