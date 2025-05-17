#!/bin/bash
set -e

RESOURCE_GROUP="rg-azvm"

echo "🧼 Deleting resource group: $RESOURCE_GROUP..."
az group delete --name "$RESOURCE_GROUP" --yes --no-wait

echo "🧹 Removing local Terraform files..."
rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

echo "📦 Local cleanup complete!"
echo ""
echo "✅ Remote resources scheduled for deletion."
echo "⏳ You can check status with:"
echo "   az group show --name $RESOURCE_GROUP --query properties.provisioningState"

