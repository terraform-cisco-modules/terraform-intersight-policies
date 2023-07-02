#__________________________________________________________________
#
# Intersight Ethernet Network Group Policy
# GUI Location: Policies > Create Policy > Ethernet Network Group
#__________________________________________________________________

resource "intersight_fabric_eth_network_group_policy" "ethernet_network_group" {
  for_each = { for v in lookup(local.policies, "ethernet_network_group", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.ethernet_network_group}${each.key}${local.name_suffix.ethernet_network_group} Ethernet Network Group Policy.")
  name = "${local.name_prefix.ethernet_network_group}${each.key}${local.name_suffix.ethernet_network_group}"
  organization {
    moid        = local.orgs[var.organization]
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
