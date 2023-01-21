#!/bin/sh
LB_IP=$(kubectl get svc/foo-service -n lb -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "LoadBalancer URL http://${LB_IP}:5678"
# should output foo and bar on separate lines 
for _ in {1..10}; do
  curl ${LB_IP}:5678
done