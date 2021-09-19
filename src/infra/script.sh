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

# run trivy against the deployed image
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ zzacr.azurecr.io/aquasec/trivy --exit-code 0 --severity MEDIUM,HIGH --ignore-unfixed $containerRegistry/$imageRepository:$tag
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ zzacr.azurecr.io/aquasec/trivy --exit-code 1 --severity CRITICAL --ignore-unfixed $containerRegistry/$imageRepository:$tag

# deploy AKS cluster
/bin/bash deploy.sh dev
/bin/bash deploy.sh test

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
    -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://rose-app-int:2999; done"
# using external
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never --namespace $ns \
    -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://20.53.196.76:2999/; done"

# using external, curl
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never --namespace $ns \
    -- /bin/sh -c "while sleep 0.01; do curl -L -v http://20.53.196.76:2999/  -A \"Mozilla/5.0 (compatible;  MSIE 7.01; Windows NT 5.0)\"; done"

# testing namespace
tns='geekready2021-testing'
kubectl create namespace $tns

# moon for UI / func testing
git clone https://github.com/aerokube/moon-deploy.git
cd moon-deploy

kubectl apply -f moon.yaml

kubectl get svc -n moon

# rose app func test job
svr='zzacr.azurecr.io'
ns='geekready2021'
img='rose-app-func-test'
tag='latest'
docker tag $img:$tag $svr/$ns/$img:$tag
docker push $svr/$ns/$img:$tag

tns='geekready2021'
kubectl apply -f rose-app-func-test-job.yml -n $tns

# load testing
svr='zzacr.azurecr.io'
ns='geekready2021'
img='rose-app-load-test'
tag='latest'
docker tag $img:$tag $svr/$ns/$img:$tag
docker push $svr/$ns/$img:$tag

tns='geekready2021'
kubectl apply -f rose-app-load-test-job.yml -n $tns


# HPA demo


