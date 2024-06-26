#__________________________________________________________________
#
# Intersight VLAN Policy
# GUI Location: Policies > Create Policy > VLAN
#__________________________________________________________________
resource "intersight_fabric_eth_network_policy" "map" {
  for_each    = local.vlan
  description = coalesce(each.value.description, "${each.value.name} VLAN Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#__________________________________________________________________
#
# Intersight VLAN Policy > Add VLANs
# GUI Location: Policies > Create Policy > VLAN Policy > Add VLANs
#__________________________________________________________________

resource "intersight_fabric_vlan" "map" {
  depends_on = [
    intersight_fabric_eth_network_policy.map,
    intersight_fabric_multicast_policy.map
  ]
  for_each              = { for k, v in local.vlans : k => v if v.vlan_id > 0 && v.vlan_id < 4094 }
  auto_allow_on_uplinks = each.value.auto_allow_on_uplinks
  is_native             = each.value.native_vlan
  name = length(
    compact([each.value.name])
    ) > 0 && each.value.name_prefix == false ? each.value.name : length(regexall("^[0-9]{4}$", each.value.vlan_id)
    ) > 0 ? join("", [each.value.name, each.value.vlan_id]) : length(regexall("^[0-9]{3}$", each.value.vlan_id)
    ) > 0 ? join("0", [each.value.name, each.value.vlan_id]) : length(regexall("^[0-9]{2}$", each.value.vlan_id)
    ) > 0 ? join("00", [each.value.name, each.value.vlan_id]) : join("000", [each.value.name, each.value.vlan_id]
  )
  primary_vlan_id = each.value.primary_vlan_id
  sharing_type = length(regexall(tostring(each.value.vlan_id), tostring(each.value.primary_vlan_id))
  ) > 0 ? "Primary" : each.value.primary_vlan_id > 0 ? each.value.sharing_type : "None"
  vlan_id = each.value.vlan_id
  eth_network_policy { moid = intersight_fabric_eth_network_policy.map[each.value.vlan_policy].moid }
  multicast_policy {
    moid = contains(keys(local.multicast), each.value.multicast_policy) == true ? intersight_fabric_multicast_policy.map[each.value.multicast_policy
    ].moid : local.policies_data["multicast"][each.value.multicast_policy].moid
  }
}