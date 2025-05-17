# Journal for Azure Terraform Sandbox

## 📅 2025-05-17

### Hva jeg gjorde:

* Opprettet `setup.sh`, `cleanup.sh`, `status.sh` for et minimalt og repeterbart Terraform/Azure-miljø
* Lærte hvordan `az` CLI og `terraform` henger sammen
* Fikk kontroll på:

  * Ressursgruppe (`rg-azvm`)
  * Storage account (`tfstateazvmstore`)
  * Key Vault (`kv-azvm`)
* Forstod at `az group delete` sletter alt i én kommando
* Skjønte forskjellen på:

  * Ting som koster penger (VM, disk, storage account, IP)
  * Ting som ikke gjør det (resource group, vnet, nsg, subnet)

### Problemer jeg støtte på:

* `SubscriptionNotFound` ved `az storage account create`

  * Løst ved å gå til Azure Portal → Subscriptions → Resource Providers og klikke “Register” på `Microsoft.Storage`
* `ForbiddenByRbac` ved forsøk på `set-secret` i Key Vault

  * Forstod at RBAC-roller tar tid å propagere (Azure trenger ofte 5–15 min)
* `az ad signed-in-user show` ga tomt svar

  * Fordi brukeren er en Microsoft-konto (Gmail), ikke en lokal AAD-bruker

### Hva som hjalp:

* Å rydde alt tilbake til null ved å kjøre `./cleanup.sh`
* Å se klart at *ingenting kjører* med `./status.sh`
* Å få CLI og portal til å vise riktig navn på subscription med:

  ```bash
  az account clear && az login
  ```

### Neste steg:

* Kjøre `setup.sh` og `terraform apply` igjen når jeg er klar
* Utforske hvordan `terraform.tfstate` lagres i blob
* Eventuelt begynne å bygge `vm.tf` mer modulært

---

🧘 *Dersom jeg glemmer alt i morgen, vet jeg at `setup.sh` gir en ny start, `status.sh` gir oversikt, og `cleanup.sh` nullstiller alt trygt.*

