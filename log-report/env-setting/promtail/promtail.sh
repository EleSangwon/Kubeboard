#!/bin/bash
cnt=`kubectl exec -it dev-promtail-lwvkd -- cat /var/log/pods/kube-system_eventrouter-5874bd6747-ktxgz_0e74a342-706f-4358-9e13-47cf43ba7958/kube-eventrouter/0.log | grep problem-app | grep error | wc -l`
for i in $(seq 1 ${cnt}); do
  contents=`kubectl exec -it dev-promtail-lwvkd -- cat /var/log/pods/kube-system_eventrouter-5874bd6747-ktxgz_0e74a342-706f-4358-9e13-47cf43ba7958/kube-eventrouter/0.log | grep problem-app | grep error | head -$i | tail -1 >>logval.json`
  echo "${contents}"
done
aws s3 cp logval.json s3://hanium-dev-loki
rm logval.json
exit 0