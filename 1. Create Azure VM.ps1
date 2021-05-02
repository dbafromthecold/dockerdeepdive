

az login


# set variables
$Region         = "EastUS"
$ResourceGroup  = "DockerDeepDive"
$Username       = "dbafromthecold"
$Password       = "XXXXXXXXXXXXXXXXXX"
$dnsPrefix      = "dbafromthecold"
$VMSize         = "Standard_B2s"
$Hostname       = "docker"
$IP             = "172.16.94.5"
$Image          = "Canonical:UbuntuServer:18.04-LTS:latest"
$DNSName        = "$dnsPrefix-$hostname"


# Create resource group
az group create -l $Region -n $ResourceGroup


# create vnet
az network vnet create --name DockerVnet --resource-group $ResourceGroup --address-prefixes 172.16.94.0/24


# create subnet
az network vnet subnet create --name DockerSubnet --address-prefixes 172.16.94.0/24 `
--resource-group $ResourceGroup --vnet-name DockerVnet


# create network security group
az network nsg create --name DockerNsg --resource-group $ResourceGroup


# create ssh rule
az network nsg rule create --name SSH --nsg-name DockerNsg --priority 1000 `
--resource-group $ResourceGroup --destination-port-ranges 22 --access "Allow" `
--protocol TCP --direction Inbound


# create puglic IP
az network public-ip create --name PIP-$hostname --resource-group $ResourceGroup --dns-name $DNSName


# create network interface
az network nic create --name NIC-$hostname --resource-group $ResourceGroup --subnet DockerSubnet `
--vnet-name DockerVnet --private-ip-address $IP --public-ip-address PIP-$hostname


# create vm
az vm create --name $hostname --resource-group $ResourceGroup --nics NIC-$hostname --os-disk-size-gb 150 `
--os-disk-name Disk-$hostname --image $image --authentication-type password `
--admin-username $Username --admin-password $Password --size $VMSize


# start VM (not needed immediately after creation)
az vm start --name docker --resource-group DockerDeepDive


# ssh to machine
ssh dbafromthecold@dbafromthecold-docker.eastus.cloudapp.azure.com


# stop and deallocate VM
az vm stop --name docker --resource-group DockerDeepDive --skip-shutdown
az vm deallocate --name docker --resource-group DockerDeepDive