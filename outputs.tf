output "name" {
  description = "Generated Resource Group name. Format: rg-<location>-<env>-<name>."
  value       = azurerm_resource_group.rg.name
}

output "id" {
  description = "Azure Resource ID of the Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "location" {
  description = "Azure region of the Resource Group."
  value       = azurerm_resource_group.rg.location
}

output "resource" {
  description = "Full azurerm_resource_group resource object."
  value       = azurerm_resource_group.rg
}

output "lock_id" {
  description = "Resource ID of the Management Lock. null if enable_lock = false."
  value       = var.enable_lock ? azurerm_management_lock.rg_lock[0].id : null
}