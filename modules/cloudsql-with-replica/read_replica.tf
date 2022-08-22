locals {
  replicas = {
    for x in var.read_replicas : "${var.instance_name}-replica${var.read_replica_name_suffix}${x.instance_name}" => x
  }
}


resource "google_sql_database_instance" "replicas" {
  for_each               = local.replicas
  name                   = "${var.instance_name}-${var.read_replica_name_suffix}${each.value.instance_name}"
  region                 = var.region
  database_version       = var.database_version
  project                = var.project
  master_instance_name   = google_sql_database_instance.instance.name
  deletion_protection    = var.read_replica_deletion_protection

  replica_configuration {
    failover_target = false
  }

  settings {
    tier = var.instance_type
    disk_size = var.disk_size
    disk_type = var.disk_type
    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    user_labels = var.environment
    availability_type = var.zone_availability_type

    dynamic "ip_configuration" {
     for_each = [lookup(each.value, "ip_configuration", {})]
     content {
      ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", null)
      private_network = "projects/${var.network_project}/global/networks/${data.google_compute_network.network.name}"
      allocated_ip_range = lookup(ip_configuration.value, "allocated_ip_range", null)
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
    ignore_changes = [
        settings[0].maintenance_window,
    ]
  }

}
