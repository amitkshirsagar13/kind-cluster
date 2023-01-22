#!/bin/sh

kind delete cluster -n dev 
kind create cluster --config dev-cluster.yaml


# kubectl apply -f ./ingress/contour.yaml
# sleep 60s
# kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/control-plane","operator":"Equal","effect":"NoSchedule"},{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
# sleep 60s



# helm install nginx nginx-stable/nginx-ingress \
# --namespace nginx --create-namespace \
# --set controller.metrics.enabled=true \
# --set controller.service.type=NodePort \
# --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
# --set-string controller.podAnnotations."prometheus\.io/port"="10254" \
# --set controller.enableLatencyMetrics=true \
# --set prometheus.create=true \
# --set prometheus.port=10254 \
# --set prometheus.scheme=http

# helm upgrade --install ingress-nginx ingress-nginx \
#   --repo https://kubernetes.github.io/ingress-nginx \
#   --namespace nginx --create-namespace \

kubectl create namespace nginx
kubectl apply -f ./ingress/deploy-ingress-nginx.yaml
kubectl apply -f ./loadbalancer/metallb-native.yaml
sleep 150s

kubectl create namespace echo
kubectl apply -f ./ingress/echo-service.yaml

docker network inspect -f '{{.IPAM.Config}}' kind
kubectl apply -f ./loadbalancer/metallb-config-ipaddresspool.yaml
sleep 30s

kubectl create namespace lb
kubectl apply -f ./loadbalancer/lb-demo-deploy.yaml

./loadbalancer/test-lb.sh

helm install prom-operator-01 prometheus-community/kube-prometheus-stack
sleep 20s
kubectl apply -f ./prometheus/monitoring.ingress.yaml

kubectl describe ingress monitoring-ingress