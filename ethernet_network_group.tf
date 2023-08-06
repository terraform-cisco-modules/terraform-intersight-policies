#__________________________________________________________________
#
# Intersight Ethernet Network Group Policy
# GUI Location: Policies > Create Policy > Ethernet Network Group
#__________________________________________________________________

resource "intersight_fabric_eth_network_group_policy" "map" {
  for_each = { for v in lookup(local.policies, "ethernet_network_group", []) : v.name => merge(local.eng, v, {
    name = "${local.name_prefix.ethernet_network_group}${v.name}${local.name_suffix.ethernet_network_group}"
    tags = lookup(v, "tags", var.tags)
  }) }
  description = coalesce(each.value.description, "${each.value.name} Ethernet Network Group Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  vlan_settings {
    native_vlan   = lookup(each.value, "native_vlan", null)
    allowed_vlans = each.value.allowed_vlans
  }
  dynamic "tags" {
    for_each = { for v in lookup(each.value, "tags", var.tags) : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
