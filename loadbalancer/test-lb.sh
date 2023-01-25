#!/bin/bash
LB_IP=$(kubectl get svc/foo-service -n demo -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "-------------------------------------------"
echo "LoadBalancer URL http://${LB_IP}:5678"
echo "-------------------------------------------"
# should output foo and bar on separate lines 
for i in {1..10}
do
  curl ${LB_IP}:5678 -q
done

for i in {1..100}
do
  curl http://echo-write.localtest.me/ -q
  curl http://echo-read.localtest.me/ -q
done