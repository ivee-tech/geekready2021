resourceGroupName='zz-shared'
acrName='zzacr'
loginServer="$acrName.azurecr.io"

# login into ACR
az acr login -n $acrName

docker images

imageName='hello-rose-world'
tag='0.0.1'
destTag='0.0.1'
$ns='geekready2021'
docker tag $imageName:$tag $loginServer/$ns/$imageName:$destTag
docker push $loginServer/$ns/$imageName:$destTag
