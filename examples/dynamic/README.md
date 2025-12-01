# Dynamic Example (VNet & NSGs)

This example shows how to enable diagnostics for a virtual network and its network security groups using only map-driven configuration.

## What it builds
- Resource group, Log Analytics workspace, VNet with multiple subnets + NSGs
- Diagnostic settings for:
  - The VNet itself
  - Each NSG created by the VNet module (one per subnet here)

## Usage
```hcl
module "diagnostics" {
  source = "../../"

  log_analytics_workspace_id = module.law.workspace.id

  config = {
    settings = merge({
      vnet = {
        target_resource_id = module.network.vnet.id
        logs    = { enable_all = true }
        metrics = { enable_all = true, exclude_categories = ["AllMetrics"] }
      }
    }, {
      for nsg_key, nsg in module.network.network_security_group :
      "nsg_${nsg_key}" => {
        target_resource_id = nsg.id
        logs    = { enable_all = true }
        metrics = { enable_all = true }
      }
    })
  }
}
```

## Notes
- NSGs are attached at the subnet level in this example; the module outputs all NSGs so diagnostics are added per NSG automatically, even with multiple subnets.
- Categories and metrics are discovered dynamically via `azurerm_monitor_diagnostic_categories`; `enable_all` turns on everything unless excluded.
