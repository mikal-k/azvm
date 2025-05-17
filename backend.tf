terraform {
  backend "azurerm" {
    resource_group_name  = "rg-azvm"
    storage_account_name = "tfstateazvmstore"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

