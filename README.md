# tf-azurerm-rg-module

Production-ready Terraform module for provisioning **Azure Resource Groups**.

Delegates name generation to the shared [`tf-module-azurerm-naming-conventions`](https://github.com/<YOUR_ORG>/tf-module-azurerm-naming-conventions) module. All callers get a consistent, org-standard name automatically.

---

## Generated Name Format

```
{resource_abbr}-{location_code}-{project}-{function}-{environment}-{sequence}
```

| Input | Value | Resolved |
|---|---|---|
| `terraform_resource_type` | `azurerm_resource_group` | `rg` |
| `location` | `East US 2` | `eus2` |
| `project` | `dvop` | `dvop` |
| `function` | `testrg` | `testrg` |
| `environment` | `dev` | `dev` |
| `sequence` | `01` | `01` |

**Generated:** `rg-eus2-dvop-testrg-dev-01`

| Output | Value |
|---|---|
| `name_prefix` | `rg-eus2-dvop` |
| `name_suffix` | `testrg-dev-01` |
| `name` | `rg-eus2-dvop-testrg-dev-01` |

---

## Usage

### Development

```hcl
module "resource_group" {
  source = "github.com/<YOUR_ORG>/tf-azurerm-rg-module?ref=v1.0.0"

  project     = "dvop"
  function    = "testrg"
  location    = "East US 2"
  environment = "dev"
  sequence    = "01"
}
```

### Production (with Management Lock)

```hcl
module "resource_group" {
  source = "github.com/<YOUR_ORG>/tf-azurerm-rg-module?ref=v1.0.0"

  project     = "dvop"
  function    = "networking"
  location    = "East US 2"
  environment = "prod"
  sequence    = "01"

  enable_lock = true
  lock_level  = "CanNotDelete"

  tags = {
    owner       = "platform-team"
    cost_center = "CC-1234"
  }
}
```

### Brownfield / Existing Resource (inherit name)

```hcl
module "resource_group" {
  source = "github.com/<YOUR_ORG>/tf-azurerm-rg-module?ref=v1.0.0"

  project     = "dvop"
  function    = "legacy"
  location    = "East US 2"
  environment = "prod"

  inherit_target_resource_azure_name = true
  target_resource_azure_name         = "my-existing-rg-name"
}
```

### Multiple Resource Groups

```hcl
locals {
  resource_groups = {
    app     = { function = "app",     location = "East US 2" }
    data    = { function = "data",    location = "East US 2" }
    network = { function = "network", location = "West US 2" }
  }
}

module "resource_groups" {
  for_each = local.resource_groups
  source   = "github.com/<YOUR_ORG>/tf-azurerm-rg-module?ref=v1.0.0"

  project     = "dvop"
  function    = each.value.function
  location    = each.value.location
  environment = "prod"
  sequence    = "01"
  enable_lock = true
}

# module.resource_groups["app"].id
# module.resource_groups["data"].name
# module.resource_groups["network"].location
```

---

## Inputs

### Required

| Name | Description | Type |
|---|---|---|
| `project` | Project identifier. Alphanumeric only. | `string` |
| `function` | Purpose of the Resource Group. Letters, numbers, hyphens. | `string` |
| `location` | Azure region. Must be a supported region (see table below). | `string` |
| `environment` | Deployment environment. Example: `dev`, `uat`, `prod`. | `string` |

### Optional — Naming

| Name | Description | Type | Default |
|---|---|---|---|
| `sequence` | Sequence number for multiple instances. | `string` | `"01"` |
| `inherit_target_resource_azure_name` | Use an existing Azure name instead of generating one. | `bool` | `false` |
| `target_resource_azure_name` | Existing name to use when `inherit_target_resource_azure_name = true`. | `string` | `""` |

### Optional — Resource

| Name | Description | Type | Default |
|---|---|---|---|
| `managed_by` | ID of the Azure service managing this RG lifecycle. | `string` | `null` |
| `tags` | Additional tags. Governance tags are always auto-applied. | `map(string)` | `{}` |

### Optional — Lock

| Name | Description | Type | Default |
|---|---|---|---|
| `enable_lock` | Apply a Management Lock. Recommended for production. | `bool` | `false` |
| `lock_level` | `CanNotDelete` or `ReadOnly`. | `string` | `"CanNotDelete"` |
| `lock_name` | Custom lock name. Auto-generated if not set. | `string` | `null` |

---

## Outputs

| Name | Description | Example |
|---|---|---|
| `name_prefix` | `<abbr>-<location_code>-<project>` | `rg-eus2-dvop` |
| `name_suffix` | `<function>-<environment>-<sequence>` | `testrg-dev-01` |
| `name` | Full generated Resource Group name | `rg-eus2-dvop-testrg-dev-01` |
| `id` | Azure Resource Group ID | `/subscriptions/.../resourceGroups/...` |
| `location` | Azure region | `eastus2` |
| `resource` | Full resource object for downstream modules | — |
| `lock_id` | Management Lock ID. `null` if not enabled | — |

---

## Supported Locations

| Region | Code | Region | Code |
|---|---|---|---|
| East US | `eus` | West Europe | `weu` |
| East US 2 | `eus2` | UK South | `uks` |
| West US | `wus` | France Central | `frc` |
| West US 2 | `wus2` | Germany West Central | `gwc` |
| West US 3 | `wus3` | Norway East | `noe` |
| Central US | `cus` | Sweden Central | `sec` |
| North Central US | `ncus` | UAE North | `uaen` |
| South Central US | `scus` | Australia East | `aue` |
| North Europe | `neu` | Japan East | `jpe` |
| Southeast Asia | `sea` | Korea Central | `krc` |
| East Asia | `ea` | Central India | `cin` |
| Brazil South | `brs` | Canada Central | `cac` |

---

## Requirements

| Dependency | Version |
|---|---|
| Terraform | `>= 1.2.0, < 2.0.0` |
| AzureRM Provider | `>= 3.0.0, < 5.0.0` |
| tf-module-azurerm-naming-conventions | `v1.0.0+` |

---

## Versioning

```bash
git tag v1.0.0
git push origin v1.0.0
```

> Always pin to a Git tag in production pipelines. Never use `?ref=main`.

---

## License

Apache 2.0
