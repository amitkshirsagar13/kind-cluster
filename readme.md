## Setup Ubuntu Kubernetes cluster

### Install go



### Install kind

```
kind create cluster --config dev-cluster.yaml
```

### Setup Ingress
- Follow Ingress Setup instructions [ReadMe](./ingress/readme.md).

### Deploy Demo Echo Application
```
kubectl apply -f echo-service.yaml
```