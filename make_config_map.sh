kubectl create configmap aqua-lc-opsgenie-config -n aqua --from-file=./lc/
kubectl create secret -n aqua generic lc-secrets --from-literal=opsgenie-apikey=cc31eefa-aa10-4cb7-b205-a6c0743d0c02
