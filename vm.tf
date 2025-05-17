resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-azvm"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = "rg-azvm"
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = "rg-azvm"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-azvm"
  location            = var.location
  resource_group_name = "rg-azvm"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "vm-azvm"
  location              = var.location
  resource_group_name   = "rg-azvm"
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "almalinux"
    offer     = "almalinux-x86_64"
    sku       = "9-gen2"
    version   = "latest"
  }
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_ed25519.pub")
  }
}

