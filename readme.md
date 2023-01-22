## Setup Ubuntu Kubernetes cluster

### Install go

### Install kind

```
kind create cluster --config dev-cluster.yaml
```

### Setup Ingress
- Follow Ingress Setup instructions [ReadMe](./ingress/readme.md).

### Setup MetalLB
- Follow Ingress Setup instructions [ReadMe](./ingress/readme.md).

### Deploy Demo Echo Application
```
kubectl apply -f echo-service.yaml
```

### Install Helm and Prometheus Operator
- Setup Helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh
```

- Setup Prometheus Operator
```
# Setup Prometheus Operator
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prom-operator-01 prometheus-community/kube-prometheus-stack
kubectl get services
kubectl apply -f ./prometheus/grafana.lb.yaml
```