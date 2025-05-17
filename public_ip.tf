resource "azurerm_public_ip" "ip" {
  name                = "ip-azvm"
  location            = var.location
  resource_group_name = "rg-azvm"
  allocation_method   = "Static"
  sku                 = "Basic"
}

