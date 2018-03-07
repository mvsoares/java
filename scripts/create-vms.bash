#!/bin/bash
rg=rg-dev
vnet=$vnet
subnet=default
vmPrefix=vm
nsgName=nsg-dev
vmSize=Standard_d2_v2
imageRef=UbuntuLTS
address="10.21.0.0/20"
subnet-address="10.21.0.0/24"
username="masoar"
password="AzureRocks2018!"

az group create \
  --name $rg-dev \
  -l eastus

# criar a vnet
az network vnet create \
  -n $vnet \
  -g $rg-dev \
  --address-prefixes "$address" \
  -l eastus \
  --subnet-name "$subnet" \
  --subnet-prefix "$subnet-address"

# criar o nsg do template
az network nsg create --resource-group $rg-dev \
  --name $nsgName
  
# associar duas regras ao nsg
az network nsg rule create --resource-group $rg-dev  \
  --nsg-name $nsgName --name allow-ssh \
  --protocol tcp --direction inbound --priority 1000 --source-address-prefix '*' \
  --source-port-range '*' --destination-address-prefix '*' --destination-port-range 22 \
  --access allow

az network nsg rule create --resource-group $rg-dev  \
  --nsg-name $nsgName --name allow-http \
  --protocol tcp --direction inbound --priority 1001 --source-address-prefix '*' \
  --source-port-range '*' --destination-address-prefix '*' --destination-port-range 80 \
  --access allow

az network nsg rule create --resource-group $rg-dev  \
  --nsg-name $nsgName --name allow-http \
  --protocol tcp --direction inbound --priority 1001 --source-address-prefix '*' \
  --source-port-range '*' --destination-address-prefix '*' --destination-port-range 8080 \
  --access allow


for i in {1..2};
do
    baseName=$vmPrefix$i
    
    az network public-ip create --resource-group $rg \
        --name pip-$baseName --allocation-method dynamic --idle-timeout 4

    az network nic create \
        -n nic-$baseName \
        -g $rg \
        --subnet $subnet \
        --network-security-group $nsgName \
        --public-ip-address pip-$baseName \
        --vnet-name  $vnet

    az vm create \
    --resource-group $rg \
    --os-disk-name osdisk-$baseName \
    --name $baseName \
    --nics nic-$baseName \
    --storage-sku standard_lrs \
    --size $vmSize \
    --image $imageRef \
    --admin-username $username \
    --admin-password "$password" \
    --authentication-type password
done
