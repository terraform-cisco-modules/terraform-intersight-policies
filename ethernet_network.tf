#__________________________________________________________________
#
# Intersight Ethernet Network Policy
# GUI Location: Policies > Create Policy > Ethernet Network
#__________________________________________________________________
resource "intersight_vnic_eth_network_policy" "map" {
  for_each    = local.ethernet_network
  description = coalesce(each.value.description, "${each.value.name} Ethernet Network Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.org] }
  vlan_settings {
    allowed_vlans = "" # CSCvx98712.  This is no longer valid for the policy
    default_vlan  = each.value.default_vlan
    mode          = each.value.vlan_mode
    object_type   = "vnic.VlanSettings"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
