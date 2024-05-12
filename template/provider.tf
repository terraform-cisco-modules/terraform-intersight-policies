#_______________________________________________________________________
#
# Terraform Required Parameters - Intersight Provider
# https://registry.terraform.io/providers/CiscoDevNet/intersight/latest
#_______________________________________________________________________

data "intersight_vnic_vhba_template" "map" { for_each = { for v in [0] : v => v } }
data "intersight_vnic_vnic_template" "map" { for_each = { for v in [0] : v => v } }
output "vhba" {
  value = data.intersight_vnic_vhba_template.map[0]
}
output "vnic" {
  value = data.intersight_vnic_vnic_template.map[0]
}
terraform {
  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.48"
    }
    time = {
      source  = "time"
      version = "0.9.1"
    }
    utils = {
      source  = "netascode/utils"
      version = ">= 0.1.3"
    }
  }
  required_version = ">=1.3.0"
}

provider "intersight" {
  apikey    = "5981bd053e95200001fd5632/5fd011597564612d333e5998/65d4f9c57564613001a85a04"
  endpoint  = "https://intersight.com"
  secretkey = file("/home/tyscott/Downloads/SecretKey.txt")
}
