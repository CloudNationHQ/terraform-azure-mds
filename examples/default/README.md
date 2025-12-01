# Default Example

This example shows the simplest usage of the diagnostics module with default settings.

## Features

- Enables diagnostics for SQL Server and database
- All available logs and metrics are automatically enabled
- Sends diagnostics to Log Analytics workspace
- Uses dot notation for accessing subresources

## Usage

```hcl
module "diagnostics" {
  source = "../../"

  naming = module.naming
  log_analytics_workspace_id = module.law.workspace.id

  config = {
    settings = {
      sql_server = {
        target_resource_id = module.sql.server.id
      }

      sql_database = {
        target_resource_id = module.sql.databases.appdb.id
      }
    }
  }
}
```

## What Gets Enabled

- **Logs**: All available log categories (automatically discovered from Azure)
- **Metrics**: All available metric categories (automatically discovered from Azure)
- **Destination**: Log Analytics workspace
