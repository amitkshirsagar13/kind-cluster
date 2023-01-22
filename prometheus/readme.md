### grafana user password

```
kubectl get secret --namespace default prom-operator-01-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
kubectl get secret --namespace default prom-operator-01-grafana -o jsonpath="{.data.admin-user}" | base64 --decode ; echo
user: admin
password: prom-operator
```