#!/bin/sh

kind delete cluster -n dev 
kind create cluster --config dev-cluster.yaml

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
sleep 20s

kubectl create namespace nginx
kubectl apply -f ./ingress/nginx/nginx-ingress.yaml
kubectl apply -f ./ingress/nginx/nginx-servicemonitor.yaml
sleep 60s


kubectl apply -f ./loadbalancer/metallb-native.yaml
docker network inspect -f '{{.IPAM.Config}}' kind
sleep 60s
kubectl apply -f ./loadbalancer/metallb-config-ipaddresspool.yaml

kubectl create namespace demo
kubectl apply -f ./ingress/echo-service.yaml
kubectl apply -f ./loadbalancer/lb-demo-deploy.yaml
./loadbalancer/test-lb.sh

kubectl apply -f ./prometheus/monitoring.ingress.yaml
kubectl apply -f ./prometheus/monitoring.lb.yaml

kubectl get ingress -n demo echo-ingress
kubectl get ingress -n demo foo-bar-ingress
kubectl describe ingress -n monitoring monitoring
