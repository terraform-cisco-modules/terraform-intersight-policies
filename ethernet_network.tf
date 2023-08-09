#__________________________________________________________________
#
# Intersight Ethernet Network Policy
# GUI Location: Policies > Create Policy > Ethernet Network
#__________________________________________________________________

resource "intersight_vnic_eth_network_policy" "map" {
  for_each = { for v in lookup(local.policies, "ethernet_network", []) : v.name => merge(local.defaults.ethernet_network, v, {
    name = "${local.name_prefix.ethernet_network}${v.name}${local.name_suffix.ethernet_network}"
    tags = lookup(v, "tags", var.policies.global_settings.tags)
    }
  ) }
  description = coalesce(each.value.description, "${each.value.name} Ethernet Network Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[local.organization]
    object_type = "organization.Organization"
  }
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
