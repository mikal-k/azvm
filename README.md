# Azure VM Terraform Sandbox

Provisionering av en enkel Linux-VM i Azure med Terraform – og opprydning.

## 🛠 Filer

- `setup.sh` – Oppretter ressursgruppe, storage account, Key Vault, og initierer Terraform.
- `cleanup.sh` – Sletter alt og rydder lokalt.
- `status.sh` – Viser aktivt abonnement, RG-er, storage accounts og kostnader.
- `*.tf` – Terraform-konfigurasjon (delt opp i provider, backend, VM, keyvault, osv.)

## 🚀 Bruk

```bash
./setup.sh
terraform apply

### 🔐 Gi deg selv Key Vault-tilgang (hvis nødvendig)

Hvis `setup.sh` feiler med `ForbiddenByRbac`, må du gi deg selv tilgang til Key Vault manuelt (RBAC trenger ofte 5–15 minutter å propagere):

```bash
az role assignment create \
  --assignee "din-epost@hotmail.com" \
  --role "Key Vault Administrator" \
  --scope "/subscriptions/<subscription-id>/resourceGroups/rg-azvm/providers/Microsoft.KeyVault/vaults/kv-azvm"
```

