#!/bin/bash

# Set variables
RESOURCE_GROUP="tfstate-rg"
STORAGE_ACCOUNT="tfstateproject"
CONTAINER_NAME="tfstate"
LOCATION="eastus"

echo "🔍 Checking if resource group '$RESOURCE_GROUP' exists..."
if ! az group show --name "$RESOURCE_GROUP" &>/dev/null; then
	echo "🆕 Creating resource group..."
	az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
else
	echo "✅ Resource group already exists."
fi

echo "🔍 Checking if storage account '$STORAGE_ACCOUNT' exists..."
if ! az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$RESOURCE_GROUP" &>/dev/null; then
	echo "🆕 Creating storage account..."
	az storage account create \
		--name "$STORAGE_ACCOUNT" \
		--resource-group "$RESOURCE_GROUP" \
		--location "$LOCATION" \
		--sku Standard_LRS \
		--encryption-services blob
else
	echo "✅ Storage account already exists."
fi

echo "🔐 Getting storage account key..."
ACCOUNT_KEY=$(az storage account keys list \
	--resource-group "$RESOURCE_GROUP" \
	--account-name "$STORAGE_ACCOUNT" \
	--query '[0].value' -o tsv)

echo "🔍 Checking if container '$CONTAINER_NAME' exists..."
if ! az storage container show \
	--name "$CONTAINER_NAME" \
	--account-name "$STORAGE_ACCOUNT" \
	--account-key "$ACCOUNT_KEY" &>/dev/null; then
	echo "🆕 Creating container..."
	az storage container create \
		--name "$CONTAINER_NAME" \
		--account-name "$STORAGE_ACCOUNT" \
		--account-key "$ACCOUNT_KEY"
else
	echo "✅ Container already exists."
fi

echo "🎉 Azure backend setup is complete."
