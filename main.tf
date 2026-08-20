locals {
  rg_name = "rg-${local.location_code[var.location]}-${lower(var.environment)}-${lower(var.name)}"
}

resource "azurerm_resource_group" "rg" {
  name       = local.rg_name
  location   = var.location
  managed_by = var.managed_by

  tags = merge(
    {
      environment = var.environment
      managed_by  = "terraform"
    },
    var.tags
  )

  lifecycle {
    prevent_destroy = true
  }
}

# ============================================================
# Lock Section
# ============================================================

resource "azurerm_management_lock" "rg_lock" {
  count = var.enable_lock ? 1 : 0

  name       = var.lock_name != null ? var.lock_name : "${local.rg_name}-lock"
  scope      = azurerm_resource_group.rg.id
  lock_level = var.lock_level
  notes      = "Managed by Terraform. Do not remove without an approved change request."
}
