#__________________________________________________________________
#
# Intersight Ethernet Network Group Policy
# GUI Location: Policies > Create Policy > Ethernet Network Group
#__________________________________________________________________

resource "intersight_fabric_eth_network_group_policy" "ethernet_network_group" {
  for_each    = { for v in lookup(local.policies, "ethernet_network_group", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Ethernet Network Group Policy.")
  name        = "${each.key}${local.defaults.intersight.policies.ethernet_network_group.name_suffix}"
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  vlan_settings {
    native_vlan   = lookup(each.value, "native_vlan", null)
    allowed_vlans = each.value.allowed_vlans
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
