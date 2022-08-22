locals {
  users     = { for u in var.additional_users : u.name => u }
  ip_configuration_enabled = length(keys(var.ip_configuration)) > 0 ? true : false

  ip_configurations = {
    enabled  = var.ip_configuration
    disabled = {}
  }
}

resource "google_sql_database_instance" "instance" {
  name   = var.instance_name
  region = var.region
  database_version = var.database_version
  project = var.project
  deletion_protection = var.deletion_protection


  settings {
    tier = var.instance_type
    disk_size = var.disk_size
    disk_type = var.disk_type
    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    user_labels = var.environment
    availability_type = var.zone_availability_type

    backup_configuration {
    enabled      = "true"
    start_time   = "01:00"
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    dynamic "ip_configuration" {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
     content {
      ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", null)
      private_network = "projects/${var.network_project}/global/networks/${data.google_compute_network.network.name}"
      allocated_ip_range  = lookup(ip_configuration.value, "allocated_ip_range", null)
    }
    #database_flags {
    #  name = "character_set_server"
    #  value = var.character_set_server
    #}
    }

    dynamic "insights_config" {
      for_each = var.insights_config != null ? [var.insights_config] : []

      content {
        query_insights_enabled  = true
        query_string_length     = lookup(insights_config.value, "query_string_length", 1024)
        record_application_tags = lookup(insights_config.value, "record_application_tags", false)
        record_client_address   = lookup(insights_config.value, "record_client_address", false)
      }
    }
  }
  lifecycle {
    ignore_changes = []
  }
}

#resource "random_password" "user_password" {
#  keepers = {
#    name = google_sql_database_instance.instance.name
#  }

#  length     = 32
#  special    = false
#}

resource "random_password" "user_additional_password" {
  for_each = local.users
  keepers = {
    name = google_sql_database_instance.instance.name
  }

  length     = 32
  special    = false
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.instance, google_sql_database_instance.replicas]

}

#resource "google_sql_user" "user" {
#  name = var.db_admin_username
#  instance = var.instance_name
#  project = var.project
#  password = var.db_admin_passowrd == "" ? random_password.user_password.result : var.db_admin_username
#}

resource "google_sql_user" "additional_users" {
  for_each = local.users
  #name = var.db_app_username
  name     = each.value.name
  instance = var.instance_name
  project = var.project
  password = coalesce(each.value["password"], random_password.user_additional_password[each.value.name].result)
  depends_on = [null_resource.module_depends_on, google_sql_database_instance.instance, google_sql_database_instance.replicas]
  lifecycle {
    ignore_changes = [
      password
    ]
  }
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

#resource "google_sql_database" "db" {
#  project = var.project
#  instance = var.instance_name
#  name = var.db_name
#  charset = var.charset
#  collation = var.collation
#}


resource "google_dns_record_set" "a" {
  project        = var.network_project
  name           = "${var.instance_name}.${data.google_dns_managed_zone.dns.dns_name}"
  ttl            = var.dns_ttl
  type           = var.dns_type
  rrdatas        = google_sql_database_instance.instance.ip_address.*.ip_address
  managed_zone = var.dns_zone_name
}

data "google_compute_network" "network" {
  name = var.vpc_network
  project = var.network_project
}

data "google_dns_managed_zone" "dns" {
  name = var.dns_zone_name
  project = var.network_project
}

provider "google-beta" {
  region = var.region
  zone   = var.zone
}