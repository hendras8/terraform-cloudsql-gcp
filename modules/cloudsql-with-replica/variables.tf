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
  default = []
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
#variable "db_name" {
#  default = "en_US.UTF8"
#}
#variable "collation" {
#  default = "UTF8"
#}

variable "charset" {
  default = ""
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

variable "ip_configuration" {
  description = "The ip configuration for the master instances."
  type = object({
    ipv4_enabled        = bool
    private_network     = string
    allocated_ip_range  = string
  })
  default = {
    ipv4_enabled        = false
    private_network     = null
    require_ssl         = null
    allocated_ip_range  = null
  }
}

// Read Replicas
variable "read_replicas" {
  description = "List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption_key_name = null"
  type = list(object({
    instance_name         = string
    tier                  = string
    zone_availability_type     = string
    disk_type             = string
    disk_autoresize       = bool
    disk_autoresize_limit = number
    disk_size             = string
    environment           = map(string)
    zone                  = string
    #database_flags = list(object({
    #  name  = string
    #  value = string
    #}))
    ip_configuration = object({
      ipv4_enabled        = bool
      private_network     = string
      allocated_ip_range  = string
    })
  }))
  default = []
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

variable "read_replica_deletion_protection" {
  type        = bool
  default     = false
}

variable "read_replica_name_suffix" {
  description = "The optional suffix to add to the read instance name"
  type        = string
  default     = ""
}