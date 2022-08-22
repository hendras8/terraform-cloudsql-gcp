variable "instance_name" {
  default = ""
}
variable "region" {
  default = "asia-southeast1"
}
variable "ipv4_public_enabled" {
  type        = bool
  default     = false 
  }

variable "vpc_network" {
  default = ""
}
variable "zone" {
  default = "asia-southeast1-a"
}
variable "instance_type" {
  default = ""
}
variable "database_version" {
  default = ""
}
variable "project" {
  default = ""
}
variable "disk_size" {
  default = "20"
}
variable "disk_type" {
  default = ""
}
variable "environment" {
  type = map
  default = {
  }
}
variable "vpn_ip" {
  default = ""
}
variable "network_project" {
  default = ""
}
variable "username" {
  default = ""
}
variable "db_name" {
  default = ""
}
variable "collation" {
  default = "en_US.UTF8"
}

variable "charset" {
  default = "UTF8"
}
variable "dns_zone_name" {
  default = ""
}
variable "dns_ttl" {
  default = ""
}
variable "dns_type" {
  default = ""
}
variable "rrdatas" {
  type = list
  default = []
}


variable "deletion_protection" {
  type        = string
  default     = "" 
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size."
  type        = bool
  default     = true
}

variable "disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased."
  type        = number
  default     = 0
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "maintenance_window_day" {
  description = "The day of week (1-7) for the master instance maintenance."
  type        = number
  default     = 7
}

variable "maintenance_window_hour" {
  description = "The hour of day (0-23) maintenance window for the master instance maintenance."
  type        = number
  default     = 23
}

variable "maintenance_window_update_track" {
  description = "The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`."
  type        = string
  default     = "canary"
}

variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = ""
}

variable "ipv4_enabled" {
  type        = bool
  default     = "false"
}

variable "allocated_ip_range" {
  type        = string
  default     = ""
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled      = bool
    start_time   = string
  })
  default = {
    enabled      = false
    start_time   = null
  }
}

variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_string_length     = number
    record_application_tags = bool
    record_client_address   = bool
  })
  default = {
    query_insights_enabled          = true
    query_string_length             = 1024
    record_application_tags         = false
    record_client_address           = false
  }
}

variable "additional_users" {
  description = "A list of users to be created in your cluster"
  type = list(object({
    name     = string
    password = string
  }))
  default = []
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}

variable "db_admin_passowrd" {
  default = ""
}

variable "db_admin_username" {
  default = ""
}

variable "character_set_server" {
  default = "utf8mb4"
}

variable "zone_availability_type" {
  type        = string
  default     = ""
}