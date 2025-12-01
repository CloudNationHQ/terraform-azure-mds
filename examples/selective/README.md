# Selective Example

This example demonstrates how to enable only specific log categories and metrics instead of all available ones.

## Features

- Selective log category enablement
- Different configurations for different resources
- Multiple destinations (Log Analytics and Storage)

## Usage

```hcl
module "diagnostics" {
  source = "../../"

  log_analytics_workspace_id = module.law.workspace.id

  config = {
    settings = {
      sql_db_audit = {
        target_resource_id = module.sql.databases["production"].id
        storage_account_id = module.storage.account.id

        logs = {
          enable_all = false
          categories = ["SQLSecurityAuditEvents"]
        }

        metrics = {
          enable_all = false
          categories = ["Basic"]
        }
      }
    }
  }
}
```

## What Gets Enabled

- **Logs**: Only specified categories (e.g., SQLSecurityAuditEvents)
- **Metrics**: Only specified categories (e.g., Basic)
- **Destinations**: Storage Account for audit logs, Log Analytics for operational logs
