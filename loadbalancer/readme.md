### Deploy MetalLB CRDs
```
kubectl apply -f ./loadbalancer/metallb-native.yaml

# Verify if CRD creation completed
kubectl wait --namespace metallb-system \
        --for=condition=ready pod \
        --selector=app=metallb \
        --timeout=90s
```

### Setup LB IP Range

```
docker network inspect -f '{{.IPAM.Config}}' kind
```

### Create IPAddressPool
- Update IP Range from previous command to `loadbalancer/metallb-config-ipaddresspool.yaml`
```
kubectl apply -f ./loadbalancer/metallb-config-ipaddresspool.yaml
```

### Deploy sample LB service
```
kubectl apply -f ./loadbalancer/lb-demo-deploy.yaml

echo `kubectl get svc/foo-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'`

LB_IP=$(kubectl get svc/foo-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

# should output foo and bar on separate lines 
for _ in {1..10}; do
  curl ${LB_IP}:5678
done
```
