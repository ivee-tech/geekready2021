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
