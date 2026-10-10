variable "fsx_ontap_file_systems" {
  description = <<EOT
Map of fsx_ontap_file_systems, attributes below
Required:
    - deployment_type
    - preferred_subnet_id
    - storage_capacity
    - subnet_ids
Optional:
    - automatic_backup_retention_days
    - daily_automatic_backup_start_time
    - endpoint_ip_address_range
    - fsx_admin_password
    - ha_pairs
    - kms_key_id
    - region
    - route_table_ids
    - security_group_ids
    - storage_type
    - tags
    - tags_all
    - throughput_capacity
    - throughput_capacity_per_ha_pair
    - weekly_maintenance_start_time
    - disk_iops_configuration (block):
        - iops (optional)
        - mode (optional)
EOT

  type = map(object({
    deployment_type                   = string
    preferred_subnet_id               = string
    storage_capacity                  = number
    subnet_ids                        = list(string)
    throughput_capacity               = optional(number)
    tags_all                          = optional(map(string))
    tags                              = optional(map(string))
    storage_type                      = optional(string)
    security_group_ids                = optional(set(string))
    route_table_ids                   = optional(set(string))
    kms_key_id                        = optional(string)
    throughput_capacity_per_ha_pair   = optional(number)
    ha_pairs                          = optional(number)
    fsx_admin_password                = optional(string)
    endpoint_ip_address_range         = optional(string)
    daily_automatic_backup_start_time = optional(string)
    automatic_backup_retention_days   = optional(number)
    region                            = optional(string)
    weekly_maintenance_start_time     = optional(string)
    disk_iops_configuration = optional(object({
      iops = optional(number)
      mode = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.fsx_ontap_file_systems : (
        v.automatic_backup_retention_days == null || (v.automatic_backup_retention_days >= 0 && v.automatic_backup_retention_days <= 90)
      )
    ])
    error_message = "must be between 0 and 90"
  }
  validation {
    condition = alltrue([
      for k, v in var.fsx_ontap_file_systems : (
        v.daily_automatic_backup_start_time == null || ((length(v.daily_automatic_backup_start_time) >= 5 && length(v.daily_automatic_backup_start_time) <= 5) && (can(regex("^([01]\\d|2[0-3]):?([0-5]\\d)$", v.daily_automatic_backup_start_time))))
      )
    ])
    error_message = "all of: must be between 5 and 5 characters; must be in the format HH:MM"
  }
  validation {
    condition = alltrue([
      for k, v in var.fsx_ontap_file_systems : (
        v.fsx_admin_password == null || (length(v.fsx_admin_password) >= 8 && length(v.fsx_admin_password) <= 50)
      )
    ])
    error_message = "must be between 8 and 50 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.fsx_ontap_file_systems : (
        v.ha_pairs == null || (v.ha_pairs >= 1 && v.ha_pairs <= 12)
      )
    ])
    error_message = "must be between 1 and 12"
  }
  validation {
    condition = alltrue([
      for k, v in var.fsx_ontap_file_systems : (
        v.throughput_capacity == null || (contains([128, 256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096, 6144], v.throughput_capacity))
      )
    ])
    error_message = "must be one of: 128, 256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096, 6144"
  }
  validation {
    condition = alltrue([
      for k, v in var.fsx_ontap_file_systems : (
        v.throughput_capacity_per_ha_pair == null || (contains([128, 256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096, 6144], v.throughput_capacity_per_ha_pair))
      )
    ])
    error_message = "must be one of: 128, 256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096, 6144"
  }
  validation {
    condition = alltrue([
      for k, v in var.fsx_ontap_file_systems : (
        v.weekly_maintenance_start_time == null || ((length(v.weekly_maintenance_start_time) >= 7 && length(v.weekly_maintenance_start_time) <= 7) && (can(regex("^[1-7]:([01]\\d|2[0-3]):?([0-5]\\d)$", v.weekly_maintenance_start_time))))
      )
    ])
    error_message = "all of: must be between 7 and 7 characters; must be in the format d:HH:MM"
  }
  # Note: 7 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

