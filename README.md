# terraform-cloudsql-gcp

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.10 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_default"></a> [default](#module\_default) | modules/cloudsql-single/ | n/a |
| <a name="module_default"></a> [default](#module\_default) | modules/cloudsql-replica/ | n/a |


## Provision Instructions

```
terraform init 
terraform plan 
terraform apply -auto-approve
```


## NOTE: This module is dynamic mode for user and replica 

for example: 

USER

```
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
```

REPLICA

```
// Read replica configurations
  read_replica_name_suffix = "replica"
  read_replicas = [
{
      instance_name               = "0"
      zone                        = "asia-southeast1-b"
      zone_availability_type      = "ZONAL"
      tier                        = "db-custom-1-2048"
      ip_configuration            = local.read_replica_ip_configuration
      disk_autoresize             = true
      disk_autoresize_limit       = 0
      disk_size                   = 20
      disk_type                   = "PD_HDD"
      environment                 = { "environment" = "dev" }
    },
    {
      instance_name               = "1"
      zone                        = "asia-southeast1-c"
      zone_availability_type      = "ZONAL"
      tier                        = "db-custom-1-2048"
      ip_configuration            = local.read_replica_ip_configuration
      disk_autoresize             = true
      disk_autoresize_limit       = 0
      disk_size                   = 20
      disk_type                   = "PD_HDD"
      environment                 = { "environment" = "dev" }
    },
  ]
```
