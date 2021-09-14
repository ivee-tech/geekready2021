resourceGroupName='zz-shared'
acrName='zzacr'
loginServer="$acrName.azurecr.io"

# login into ACR
az acr login -n $acrName

docker images

# push local image manually
imageName='hello-rose-world'
tag='0.0.1'
destTag='0.0.1'
$ns='geekready2021'
docker tag $imageName:$tag $loginServer/$ns/$imageName:$destTag
docker push $loginServer/$ns/$imageName:$destTag

# attach ACR instance to AKS
resourceGroupName='zz-dev'
aksName='zz-dev-aks'
acrName='zzacr'
az aks update -n $aksName -g $resourceGroupName --attach-acr $acrName

# get AKS credentials
resourceGroupName='zz-dev'
aksName='zz-dev-aks'
az aks get-credentials -n $aksName -g $resourceGroupName

# deploy rose app and svc to AKS to
ns='geekready2021'
kubectl apply -f rose-app.yml -n $ns

# deploy HPA

# increase load
# internal call - timeout
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never --namespace $ns \
    -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://rose-app-int; done"
# using external
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never --namespace $ns \
    -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://20.92.184.206:2999/; done"

# using external, curl
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never --namespace $ns \
    -- /bin/sh -c "while sleep 0.01; do curl -L -v http://20.92.184.206:2999/  -A \"Mozilla/5.0 (compatible;  MSIE 7.01; Windows NT 5.0)\"; done"
