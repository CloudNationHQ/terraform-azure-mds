# Exclude Example

This example shows how to enable all available logs except specific noisy or unnecessary categories.

## Features

- Enable all logs by default
- Exclude specific unwanted categories
- Useful for filtering out verbose or noisy logs

## Usage

```hcl
module "diagnostics" {
  source = "../../"

  log_analytics_workspace_id = module.law.workspace.id

  config = {
    settings = {
      aks_cluster = {
        target_resource_id = module.aks.cluster.id

        logs = {
          enable_all         = true
          exclude_categories = ["kube-audit-admin", "kube-audit"]
        }
      }
    }
  }
}
```

## What Gets Enabled

- **Logs**: All available categories EXCEPT the excluded ones
- **Metrics**: All available metrics
- **Use Case**: Good for reducing log volume while maintaining comprehensive coverage

## Common Exclusions

### AKS
- `kube-audit-admin` - Very verbose admin audit logs
- `kube-audit` - Verbose audit logs

### SQL Database
- `QueryStoreWaitStatistics` - High volume query statistics
- `QueryStoreRuntimeStatistics` - Detailed runtime statistics
