#!/bin/bash
set -e

echo "🔍 Active Subscription:"
az account show --query "[name, id]" -o tsv
echo ""

echo "📦 Resource Groups:"
az group list --query "[].{Name:name, Location:location, State:properties.provisioningState}" -o table
echo ""

echo "📂 Storage Accounts:"
az storage account list --query "[].{Name:name, RG:resourceGroup, Location:location}" -o table || echo "(None or insufficient permissions)"
echo ""

echo "💾 Managed Disks:"
az disk list --query "[].{Name:name, RG:resourceGroup, Size:sizeGb, AttachedTo:managedBy}" -o table || echo "(None)"
echo ""

echo "🌐 Public IPs:"
az network public-ip list --query "[].{Name:name, RG:resourceGroup, IP:ipAddress, AssignedTo:ipConfiguration.id}" -o table
echo ""

echo "🔐 Key Vaults:"
az keyvault list --query "[].{Name:name, RG:resourceGroup, Location:location}" -o table || echo "(None)"
echo ""

echo "💸 Monthly Cost Estimate (Preview):"
if ! az consumption usage list --top 5 -o table 2>/dev/null; then
  echo "(Cost info not available – possibly due to 'usageStart' bug in Azure CLI)"
fi
echo ""

############################################
# 🧟 Section: Orphaned Resources (possibly unused)
############################################

echo "🧟 Orphaned Resources (Possibly Unused):"

# Orphaned Storage Accounts (no containers)
echo -e "\n🔹 Storage accounts with 0 containers:"
az storage account list --query "[].{Name:name, RG:resourceGroup}" -o tsv | while read NAME RG; do
  CONTAINERS=$(az storage container list --account-name "$NAME" --auth-mode login --query "length([])" 2>/dev/null || echo 0)
  if [[ "$CONTAINERS" == 0 ]]; then
    echo " - $NAME (in $RG)"
  fi
done

# Unattached Public IPs
echo -e "\n🔹 Public IPs not attached to anything:"
az network public-ip list --query "[?ipConfiguration==null].{Name:name, RG:resourceGroup}" -o table || echo "(None)"

# Unattached Managed Disks
echo -e "\n🔹 Managed Disks not in use:"
az disk list --query "[?managedBy==null].{Name:name, RG:resourceGroup}" -o table || echo "(None)"

# Possibly Orphaned Key Vaults
echo -e "\n🔹 Key Vaults with 0 secrets:"
az keyvault list --query "[].{Name:name, RG:resourceGroup}" -o tsv | while read KV RG; do
  COUNT=$(az keyvault secret list --vault-name "$KV" --query "length([])" 2>/dev/null || echo 0)
  if [[ "$COUNT" == 0 ]]; then
    echo " - $KV (empty)"
  fi
done

echo ""
echo "✅ Done."

