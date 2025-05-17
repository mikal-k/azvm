output "vm_name" {
  description = "Navnet på den opprettede virtuelle maskinen"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "Privat IP-adresse for VM-en"
  value       = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "vm_resource_group" {
  description = "Ressursgruppen der VM-en ligger"
  value       = azurerm_linux_virtual_machine.vm.resource_group_name
}

output "admin_username" {
  description = "Administratorbruker for VM-en"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}

output "location" {
  description = "Lokasjonen der ressursene er provisionert"
  value       = azurerm_linux_virtual_machine.vm.location
}

output "vm_public_ip" {
  value       = azurerm_public_ip.ip.ip_address
  description = "Public IP address of the VM"
}

