#!/bin/sh

kind delete cluster -n dev 
kind create cluster --config dev-cluster.yaml

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace

kubectl create namespace demo
kubectl apply -f ./loadbalancer/lb-demo-deploy.yaml
kubectl apply -f ./ingress/echo-service.yaml

kubectl apply -f ./loadbalancer/metallb-native.yaml
docker network inspect -f '{{.IPAM.Config}}' kind
kubectl apply -f ./loadbalancer/metallb-config-ipaddresspool.yaml
sleep 30s

./loadbalancer/test-lb.sh

kubectl apply -f ./prometheus/monitoring.ingress.yaml
kubectl apply -f ./prometheus/monitoring.lb.yaml

kubectl describe ingress monitoring

# helm install ingress nginx-stable/nginx-ingress \
# --namespace ingress --create-namespace \
# --set controller.kind=deployment \
# --set controller.service.type=NodePort \
# --set controller.metrics.serviceMonitor.additionalLabels.release="kube-prometheus-stack" \
# --set controller.metrics.serviceMonitor.enabled=true
    
helm install ingress ingress-nginx \
  --namespace ingress --create-namespace \
  --repo https://kubernetes.github.io/ingress-nginx \
  --set controller.metrics.enabled=true \
  --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
  --set-string controller.podAnnotations."prometheus\.io/port"="10254"

helm uninstall ingress --namespace ingress 

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

# kubectl create namespace nginx
kubectl apply -f ./ingress/deploy-ingress-nginx.yaml

# sleep 150s

# sleep 20s

