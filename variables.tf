variable "name" {
  description = "Name identifier provided by the developer. Used to generate: rg-<location>-<env>-<name>."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+$", var.name)) && length(var.name) > 0
    error_message = "name must contain only letters, numbers, or hyphens and must not be empty."
  }
}

variable "location" {
  description = "Azure region. Must be a supported location. Example: 'East US 2'."
  type        = string

  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US", "West Central US",
      "North Europe", "West Europe", "UK South", "UK West",
      "France Central", "Germany West Central", "Switzerland North",
      "Norway East", "Sweden Central", "UAE North",
      "Australia East", "Australia Southeast",
      "Japan East", "Japan West", "Korea Central",
      "Southeast Asia", "East Asia",
      "Central India", "South India", "West India", "Jio India West",
      "Brazil South", "Canada Central", "Canada East"
    ], var.location)
    error_message = "location must be a supported Azure region. See locations.tf for the full list."
  }
}

variable "environment" {
  description = "Deployment environment. Example: 'dev', 'uat', 'staging', 'prod'."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]+$", var.environment)) && length(var.environment) > 0
    error_message = "environment must contain only letters and numbers and must not be empty."
  }
}

variable "managed_by" {
  description = "ID of the Azure service managing this Resource Group lifecycle. Default: null."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to merge. Governance tags (environment, managed_by) are always applied."
  type        = map(string)
  default     = {}
}

# ============================================================
# Lock Section
# ============================================================

variable "enable_lock" {
  description = "Apply an Azure Management Lock. Recommended for production. Default: false."
  type        = bool
  default     = false
}

variable "lock_level" {
  description = "Lock level: 'CanNotDelete' or 'ReadOnly'. Default: 'CanNotDelete'."
  type        = string
  default     = "CanNotDelete"

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "lock_level must be either 'CanNotDelete' or 'ReadOnly'."
  }
}

variable "lock_name" {
  description = "Custom lock name. Defaults to '<rg-name>-lock' if not set."
  type        = string
  default     = null
}