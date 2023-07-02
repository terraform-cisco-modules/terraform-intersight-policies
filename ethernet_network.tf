#__________________________________________________________________
#
# Intersight Ethernet Network Policy
# GUI Location: Policies > Create Policy > Ethernet Network
#__________________________________________________________________

resource "intersight_vnic_eth_network_policy" "ethernet_network" {
  for_each = { for v in lookup(local.policies, "ethernet_network", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.ethernet_network}${each.key}${local.name_suffix.ethernet_network} Ethernet Network Policy.")
  name = "${local.name_prefix.ethernet_network}${each.key}${local.name_suffix.ethernet_network}"
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  vlan_settings {
    allowed_vlans = "" # CSCvx98712.  This is no longer valid for the policy
    default_vlan  = lookup(each.value, "default_vlan", local.defaults.ethernet_network.default_vlan)
    mode          = lookup(each.value, "vlan_mode", local.defaults.ethernet_network.vlan_mode)
    object_type   = "vnic.VlanSettings"
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
