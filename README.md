# Pod killer using go client
Thanks to Gianluca for the [shared informer implemantation](https://gianarb.it/blog/kubernetes-shared-informer).

## Create kind cluster
kind create cluster --config cluster-config.yaml --name crixo 

## Get dependecies
```
go mod init github.com/crixo/kind-go-client

# client-go version should match w/ the upstream k8s cluster version
go get k8s.io/client-go@kubernetes-1.16.3
```

## Deploy testing workloads
#kubectl create namespace vote
kubectl apply -f kube-deployment.yml

https://github.com/kubernetes/client-go/tree/master/examples/in-cluster-client-configuration
kubectl create clusterrolebinding default-view --clusterrole=view --serviceaccount=default:default
kubectl create clusterrolebinding client-admin --clusterrole=admin --serviceaccount=default:default

## Create docker image
GOOS=linux go build -o ./_builds/app .
docker build -t client-go-01:unique-tag -f nobuild.Dockerfile ./_builds/

## Load image in kind
kind load docker-image client-go-01:unique-tag --name crixo

## Add RBAC permission to the pod w/ go-client
https://github.com/kubernetes/client-go/tree/master/examples/in-cluster-client-configuration
kubectl create clusterrolebinding client-admin --clusterrole=admin --serviceaccount=default:default

## Deploy in k8s the client-go app
k run pod-killer-by-label --image=kind-go-client:unique-tag --restart=Never

## Deploy an nginx container that will be later deleted using dedicated label
k run nginx-to-del --image=nginx --restart=Never

## Label the new nginx pod w/ label that riggers the deletion
k label pod nginx delete-pod=true

## Delete kind cluster
kind delete cluster  --name crixo

## Run locally
```
KUBECONFIG='c:/Users/cristiano.degiorgis/.kube/config' go run main.go
```

