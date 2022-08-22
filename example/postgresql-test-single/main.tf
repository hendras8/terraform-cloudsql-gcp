terraform {
  required_version = "~> 0.14"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.4.0, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.4.0, < 5.0"
    }
  }
    provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-sql-db:postgresql/v12.0.0"
  }
  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-sql-db:postgresql/v12.0.0"
  }
  backend "gcs" {
    bucket = "bucket-tf"
    prefix = "state/cloudsql/testing-postgresql-single/"
  }
}


module "default" {
source                  = "../../modules/cloudsql-single/"
instance_name           = "cloudsql-testing"
instance_type           = "db-custom-1-2048"
region                  = "asia-southeast1"
zone                    = "asia-southeast1-a"
vpc_network             = "(VPC_PROJECT)"
database_version        = "POSTGRES_14"
project                 = "(PROJECT_NAME)"
disk_autoresize         = true
disk_autoresize_limit   = 0
disk_size               = 20
disk_type               = "PD_HDD"
environment             = { "environment" = "dev" }
network_project         = "(NETWORK_PROJECT)" 
deletion_protection     = "true"

zone_availability_type  = "ZONAL"     # ZONAL NOT HA ,REGIONAL IT'S HA
ipv4_enabled            = "false"     # false for disable ip public ,true for enable ip public
allocated_ip_range      = "google-managed-services-vpc-project" # create first if you want use specific range ip



maintenance_window_day          = 7  # SUNDAY
maintenance_window_hour         = 6  # the time it's UTC TIME which means 1 AM in WIB FORMAT
maintenance_window_update_track = "stable"


#DATABASE USER

 additional_users = [
    {
    name         = "app_user"
    password         = ""
    },
    {
    name         = "app_user_b"
    password         = ""
    },
 ]

#DATABASE NAME 
db_name                 = "db_test"
collation               = "en_US.UTF8"
charset                 = "UTF8"

#DNS PART
dns_zone_name           = "kurcaci.id"
dns_ttl                 = 3600
dns_type                = "A"

}