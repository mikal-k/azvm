#!/bin/bash
set -e

RESOURCE_GROUP="rg-azvm"
LOCATION="westeurope"
STORAGE_ACCOUNT="tfstateazvmstore"
CONTAINER_NAME="tfstate"
KEYVAULT_NAME="kv-azvm"

# 🔐 Sjekk om aktivt abonnement fungerer
echo "🔐 Verifying Azure login and subscription..."
if ! az group list --output none 2>/dev/null; then
  echo ""
  echo "❌ You are not authenticated or subscription is invalid."
  echo "👉 Run the following first:"
  echo "   az login"
  echo "   az account set --subscription <your-subscription-id>"
  echo ""
  exit 1
fi

SUBSCRIPTION_ID=$(az account show --query "id" -o tsv)
echo "✅ Azure login active. Using subscription: $SUBSCRIPTION_ID"

# 📦 Sørg for nødvendige resource providers
for RP in Microsoft.Storage Microsoft.KeyVault Microsoft.Compute; do
  STATUS=$(az provider show --namespace "$RP" --query "registrationState" -o tsv 2>/dev/null || echo "NotRegistered")
  if [[ "$STATUS" != "Registered" ]]; then
    echo "🛠 Registering resource provider: $RP..."
    az provider register --namespace "$RP" >/dev/null
    echo "⏳ Waiting for $RP registration..."
    until [[ "$(az provider show --namespace "$RP" --query "registrationState" -o tsv)" == "Registered" ]]; do
      sleep 1
    done
    echo "✅ $RP registered."
  else
    echo "✅ Resource provider already registered: $RP"
  fi
done

# 📦 Opprett ressursgruppe
echo "📦 Creating resource group..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# 📂 Opprett storage account
echo "📂 Creating storage account..."
az storage account create --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" --sku Standard_LRS \
  --location "$LOCATION" || echo "✅ Storage account already exists"

# 📁 Opprett blob container
echo "📁 Creating blob container..."
az storage container create --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" --auth-mode login || echo "✅ Blob container already exists"

# 🔐 Opprett eller bruk eksisterende Key Vault
if ! az keyvault show --name "$KEYVAULT_NAME" --resource-group "$RESOURCE_GROUP" >/dev/null 2>&1; then
  echo "🔐 Creating Key Vault..."
  az keyvault create --name "$KEYVAULT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --enable-rbac-authorization true
else
  echo "✅ Key Vault already exists: $KEYVAULT_NAME"
fi

echo "🔏 Skipping password setup – using SSH keys only."

# 🚀 Terraform init
if [ ! -d ".terraform" ]; then
  echo "🚀 Running terraform init..."
  terraform init
else
  echo "🧭 Terraform already initialized."
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "👉 Run:"
echo "   terraform apply"
echo ""
echo "🧹 When done:"
echo "   terraform destroy"
echo ""
echo "📉 To check monthly costs:"
echo "   az consumption usage list --top 5 --query \"[].{Resource:instanceName, Cost:pretaxCost}\" -o table"

