#!/bin/bash
lbName=lb-dev
rg=rg-dev
vnet=vnet
subnet=default
vmPrefix=vm

az network lb create \
  -n $lbName \
  -g $rg 

az network lb probe create \
  --lb-name $lbName \
  -n prb-$lbName-chuck \
  --port 8080 \
  --protocol Tcp \
  -g $rg 


az network lb address-pool create\
  --lb-name $lbName\
  -n bkend-$lbName-chuck \
  -g $rg
  
az network public-ip create --resource-group $rg \
  --name pubip-$lbName-chuck --allocation-method dynamic --idle-timeout 4


az network lb frontend-ip create \
  --lb-name $lbName \
  -n frtend-$lbName-chuck \
  -g $rg \
  --public-ip-address pubip-$lbName-chuck
  

az network lb rule create \
  --backend-port 8080 \
  --frontend-port 80 \
  --lb-name $lbName \
  --name rule-80-chuck \
  --protocol tcp \
  --resource-group $rg  \
  --backend-pool-name bkend-$lbName-chuck \
  --load-distribution Default \
  --probe-name prb-$lbName-chuck \
  --frontend-ip-name frtend-$lbName-chuck

for i in {1..2};
do
    ipConfig=$(az network nic show -n nic-$vmPrefix$i -g $rg --query "ipConfigurations[0].id" -o tsv)

    az network nic ip-config update \
    --lb-name $lbName \
    --ids $ipConfig \
    --lb-address-pools bkend-$lbName-chuck
done

