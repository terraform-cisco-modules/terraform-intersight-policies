#__________________________________________________________________
#
# Intersight Ethernet Network Group Policy
# GUI Location: Policies > Create Policy > Ethernet Network Group
#__________________________________________________________________

resource "intersight_fabric_eth_network_group_policy" "map" {
  for_each    = local.ethernet_network_group
  description = coalesce(each.value.description, "${each.value.name} Ethernet Network Group Policy.")
  name        = each.value.name
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  vlan_settings {
    native_vlan   = each.value.native_vlan
    allowed_vlans = each.value.allowed_vlans
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_eth_network_group_policy" "data" {
  depends_on = [intersight_fabric_eth_network_group_policy.map]
  for_each = {
    for v in local.pp.ethernet_network_group : v => v if lookup(local.ethernet_network_group, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
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
