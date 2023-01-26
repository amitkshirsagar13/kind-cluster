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

ab -k -c 350 -n 100000 http://echo-read.localtest.me/ &
ab -k -c 350 -n 50000 http://echo-write.localtest.me/ &
ab -k -c 350 -n 25000 http://echo-write.localtest.me/echo1 &
ab -k -c 350 -n 25000 http://echo-write.localtest.me/echo2 &