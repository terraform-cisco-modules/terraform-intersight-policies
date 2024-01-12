#__________________________________________________________________
#
# Intersight Boot Order Policy
# GUI Location: Policies > Create Policy > Boot Order
#__________________________________________________________________

resource "intersight_boot_precision_policy" "map" {
  depends_on = [
    intersight_vnic_lan_connectivity_policy.map,
    intersight_vnic_eth_if.map
  ]
  for_each                 = local.boot_order
  configured_boot_mode     = each.value.boot_mode
  description              = coalesce(each.value.description, "${each.value.name} Boot Order Policy.")
  enforce_uefi_secure_boot = each.value.enable_secure_boot
  name                     = each.value.name
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "boot_devices" {
    for_each = { for v in each.value.boot_devices : v.name => v }
    content {
      additional_properties = boot_devices.value.additional_properties
      enabled               = boot_devices.value.enabled
      object_type           = boot_devices.value.object_type
      name                  = boot_devices.value.name
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
