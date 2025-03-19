#!/bin/bash

# Global variables
RESOURCE_GROUP="az104-rg8"
LOCATION="eastus"
VM_SIZE="Standard_D2s_v3"
ADMIN_USERNAME="localadmin"
ADMIN_PASSWORD="P@ssw0rd1234!" # Replace with a secure password in a real environment

# Create resource group
echo "Creating resource group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Task 1: Deploy zone-resilient Azure virtual machines
echo "Deploying virtual machines in different availability zones..."

# Create VM 1 in zone 1
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name "az104-vm1" \
  --image "Win2019Datacenter" \
  --admin-username $ADMIN_USERNAME \
  --admin-password $ADMIN_PASSWORD \
  --size $VM_SIZE \
  --zone 1 \
  --no-wait

# Create VM 2 in zone 2
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name "az104-vm2" \
  --image "Win2019Datacenter" \
  --admin-username $ADMIN_USERNAME \
  --admin-password $ADMIN_PASSWORD \
  --size $VM_SIZE \
  --zone 2

# Wait for VMs to be created
echo "Waiting for VMs deployment to complete..."
az vm wait --created --name "az104-vm1" --resource-group $RESOURCE_GROUP
az vm wait --created --name "az104-vm2" --resource-group $RESOURCE_GROUP

# Task 2: Manage compute and storage scaling for virtual machines
echo "Resizing az104-vm1..."

# Resize VM1 to a smaller SKU
az vm resize \
  --resource-group $RESOURCE_GROUP \
  --name "az104-vm1" \
  --size "Standard_DS1_v2"

# Create and attach a data disk
echo "Creating and attaching a data disk..."
az disk create \
  --resource-group $RESOURCE_GROUP \
  --name "vm1-disk1" \
  --size-gb 32 \
  --sku "Standard_LRS" \
  --output json > disk_creation.json

# Attach the disk to the VM
az vm disk attach \
  --resource-group $RESOURCE_GROUP \
  --vm-name "az104-vm1" \
  --name "vm1-disk1" \
  --output json > disk_attach.json

# Detach the disk
echo "Detaching the disk..."
az vm disk detach \
  --resource-group $RESOURCE_GROUP \
  --vm-name "az104-vm1" \
  --name "vm1-disk1"

# Update disk storage type
echo "Updating disk storage type..."
az disk update \
  --resource-group $RESOURCE_GROUP \
  --name "vm1-disk1" \
  --sku "StandardSSD_LRS" \
  --output json > disk_update.json

# Reattach the updated disk
az vm disk attach \
  --resource-group $RESOURCE_GROUP \
  --vm-name "az104-vm1" \
  --name "vm1-disk1" \
  --output json > disk_reattach.json

# Task 3: Create and configure Azure Virtual Machine Scale Sets
echo "Creating Virtual Machine Scale Set..."

# Create a virtual network for the VMSS
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name "vmss-vnet" \
  --address-prefix "10.82.0.0/20" \
  --subnet-name "subnet0" \
  --subnet-prefix "10.82.0.0/24" \
  --output json > vnet_creation.json

# Create a network security group (NSG)
az network nsg create \
  --resource-group $RESOURCE_GROUP \
  --name "vmss1-nsg" \
  --output json > nsg_creation.json

# Add a rule to allow HTTP
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name "vmss1-nsg" \
  --name "allow-http" \
  --protocol tcp \
  --priority 1010 \
  --destination-port-range 80 \
  --access allow \
  --output json > nsg_rule_creation.json

# Create the load balancer
az network lb create \
  --resource-group $RESOURCE_GROUP \
  --name "vmss-lb" \
  --sku Standard \
  --backend-pool-name "vmssPool" \
  --frontend-ip-name "myFrontEnd" \
  --public-ip-address-allocation static \
  --public-ip-zone 1 2 3 \
  --output json > lb_creation.json

# Add an HTTP load balancer rule
az network lb rule create \
  --resource-group $RESOURCE_GROUP \
  --lb-name "vmss-lb" \
  --name "myHTTPRule" \
  --protocol tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name "myFrontEnd" \
  --backend-pool-name "vmssPool" \
  --output json > lb_rule_creation.json

# Create a health probe
az network lb probe create \
  --resource-group $RESOURCE_GROUP \
  --lb-name "vmss-lb" \
  --name "myHTTPProbe" \
  --protocol tcp \
  --port 80 \
  --output json > lb_probe_creation.json

# Create the Virtual Machine Scale Set
az vmss create \
  --resource-group $RESOURCE_GROUP \
  --name "vmss1" \
  --image "Win2019Datacenter" \
  --admin-username $ADMIN_USERNAME \
  --admin-password $ADMIN_PASSWORD \
  --instance-count 2 \
  --vm-sku $VM_SIZE \
  --vnet-name "vmss-vnet" \
  --subnet "subnet0" \
  --network-security-group "vmss1-nsg" \
  --load-balancer "vmss-lb" \
  --zones 1 2 3 \
  --lb-sku Standard \
  --upgrade-policy-mode Automatic \
  --output json > vmss_creation.json

# Task 4: Scale Azure Virtual Machine Scale Sets
echo "Configuring scaling rules for VMSS..."

# Create an autoscale profile with min, max and default instance counts
az monitor autoscale create \
  --resource-group $RESOURCE_GROUP \
  --resource "vmss1" \
  --resource-type "Microsoft.Compute/virtualMachineScaleSets" \
  --name "vmss1-autoscale" \
  --min-count 2 \
  --max-count 10 \
  --count 2 \
  --output json > autoscale_creation.json

# Add a scale-out rule if CPU > 70% for 10 minutes
az monitor autoscale rule create \
  --resource-group $RESOURCE_GROUP \
  --autoscale-name "vmss1-autoscale" \
  --condition "Percentage CPU > 70 avg 10m" \
  --scale out 50 percent \
  --cooldown 5 \
  --output json > autoscale_scaleout_rule.json

# Add a scale-in rule if CPU < 30% for 10 minutes
az monitor autoscale rule create \
  --resource-group $RESOURCE_GROUP \
  --autoscale-name "vmss1-autoscale" \
  --condition "Percentage CPU < 30 avg 10m" \
  --scale in 50 percent \
  --cooldown 5 \
  --output json > autoscale_scalein_rule.json

# Task 5 (optional): Create a VM with PowerShell
# This part is optional and requires PowerShell, not included in this Bash script

# Task 6 (optional): Create a VM with CLI
echo "Creating Ubuntu VM with CLI..."
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name "myCLIVM" \
  --image "Ubuntu2204" \
  --admin-username $ADMIN_USERNAME \
  --generate-ssh-keys \
  --output json > clivm_creation.json

# Check VM details
az vm show \
  --name "myCLIVM" \
  --resource-group $RESOURCE_GROUP \
  --show-details \
  --output json > clivm_details.json

# Stop and deallocate the VM
az vm deallocate \
  --resource-group $RESOURCE_GROUP \
  --name "myCLIVM" \
  --output json > clivm_deallocate.json

echo "Script completed. All lab tasks have been executed."
echo "Detailed results are available in the generated JSON files."

# Resource cleanup (uncomment to delete all resources)
# echo "Cleaning up resources..."
# az group delete --name $RESOURCE_GROUP --yes --no-wait
