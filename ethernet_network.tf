#__________________________________________________________________
#
# Intersight Ethernet Network Policy
# GUI Location: Policies > Create Policy > Ethernet Network
#__________________________________________________________________

resource "intersight_vnic_eth_network_policy" "map" {
  for_each    = local.ethernet_network
  description = coalesce(each.value.description, "${each.value.name} Ethernet Network Policy.")
  name        = each.value.name
  organization {
    moid        = var.orgs[each.value.organization]
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

resource "intersight_vnic_eth_network_policy" "data" {
  depends_on = [intersight_vnic_eth_network_policy.map]
  for_each = {
    for v in local.pp.ethernet_network : v => v if lookup(local.ethernet_network, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = var.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, mod_time, owners,
      parent, permission_resources, shared_scope, tags, version_context, vlan_settings
    ]
    prevent_destroy = true
  }
}
