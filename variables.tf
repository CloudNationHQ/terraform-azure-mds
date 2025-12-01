variable "config" {
  description = "Diagnostic settings configuration"
  type = object({
    storage_account_id             = optional(string)
    eventhub_authorization_rule_id = optional(string)
    eventhub_name                  = optional(string)
    partner_solution_id            = optional(string)
    log_analytics_destination_type = optional(string)

    settings = optional(map(object({
      target_resource_id             = string
      log_analytics_workspace_id     = optional(string)
      storage_account_id             = optional(string)
      eventhub_authorization_rule_id = optional(string)
      eventhub_name                  = optional(string)
      partner_solution_id            = optional(string)
      log_analytics_destination_type = optional(string)

      logs = optional(object({
        enable_all         = optional(bool, true)
        categories         = optional(set(string), [])
        category_groups    = optional(set(string), [])
        exclude_categories = optional(set(string), [])
      }), {})

      metrics = optional(object({
        enable_all         = optional(bool, true)
        categories         = optional(set(string), [])
        exclude_categories = optional(set(string), [])
      }), {})

      name = optional(string)
    })), {})
  })
}

variable "naming" {
  description = "Used for naming purposes"
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Fallback Log Analytics workspace ID for all diagnostic settings (can be overridden per setting)"
  type        = string
  default     = null
}
