#__________________________________________________________________
#
# Intersight Ethernet Network Group Policy
# GUI Location: Policies > Create Policy > Ethernet Network Group
#__________________________________________________________________
resource "intersight_fabric_eth_network_group_policy" "map" {
  for_each    = local.ethernet_network_group
  description = coalesce(each.value.description, "${each.value.name} Ethernet Network Group Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.org] }
  vlan_settings {
    allowed_vlans = each.value.allowed_vlans
    native_vlan   = each.value.native_vlan
    qinq_enabled  = each.value.qinq_vlan != 0 ? true : false
    qinq_vlan     = each.value.qinq_vlan == 0 ? 2 : each.value.qinq_vlan
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
