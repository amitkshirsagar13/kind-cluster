#!/bin/sh

kind delete cluster -n dev 
kind create cluster --config dev-cluster.yaml


kubectl apply -f ./ingress/contour.yaml
sleep 20s
kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/control-plane","operator":"Equal","effect":"NoSchedule"},{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'


kubectl apply -f ./ingress/deploy-ingress-nginx.yaml
kubectl apply -f ./loadbalancer/metallb-native.yaml
sleep 150s

kubectl apply -f echo-service.yaml

docker network inspect -f '{{.IPAM.Config}}' kind
kubectl apply -f ./loadbalancer/metallb-config-ipaddresspool.yaml

kubectl apply -f ./loadbalancer/lb-demo-deploy.yaml

./test-lb.sh

helm install prom-operator-01 prometheus-community/kube-prometheus-stack
sleep 20s
kubectl apply -f ./prometheus/grafana.lb.yaml

kubectl describe service grafana-service