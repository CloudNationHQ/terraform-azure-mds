data "azurerm_monitor_diagnostic_categories" "this" {
  for_each = var.config.settings

  resource_id = each.value.target_resource_id
}

# diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.config.settings

  name = coalesce(
    each.value.name,
    try(var.naming.monitor_diagnostic_setting, null) != null ?
    "${var.naming.monitor_diagnostic_setting}-${each.key}" :
    "diag-${each.key}"
  )

  target_resource_id = each.value.target_resource_id
  log_analytics_workspace_id = try(
    coalesce(each.value.log_analytics_workspace_id, var.log_analytics_workspace_id),
    null
  )

  storage_account_id = try(
    coalesce(
      each.value.storage_account_id, var.config.storage_account_id
    ), null
  )

  eventhub_authorization_rule_id = try(
    coalesce(
      each.value.eventhub_authorization_rule_id, var.config.eventhub_authorization_rule_id
    ), null
  )

  eventhub_name = try(
    coalesce(
      each.value.eventhub_name, var.config.eventhub_name
    ), null
  )

  partner_solution_id = try(
    coalesce(
      each.value.partner_solution_id, var.config.partner_solution_id
    ), null
  )

  log_analytics_destination_type = try(
    coalesce(
      each.value.log_analytics_destination_type, var.config.log_analytics_destination_type
    ), null
  )

  dynamic "enabled_log" {
    for_each = try(each.value.logs.enable_all, true) ? {
      for cat in setsubtract(
        toset(data.azurerm_monitor_diagnostic_categories.this[each.key].log_category_types),
        toset(try(each.value.logs.exclude_categories, []))
      ) : cat => cat
      } : {
      for cat in try(each.value.logs.categories, []) : cat => cat
    }

    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = {
      for cat in try(each.value.logs.category_groups, []) : cat => cat
    }

    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = try(each.value.metrics.enable_all, true) ? {
      for cat in setsubtract(
        toset(data.azurerm_monitor_diagnostic_categories.this[each.key].metrics),
        toset(try(each.value.metrics.exclude_categories, []))
      ) : cat => cat
      } : {
      for cat in try(each.value.metrics.categories, []) : cat => cat
    }

    content {
      category = enabled_metric.value
    }
  }
}
