#__________________________________________________________________
#
# Intersight VLAN Policy
# GUI Location: Policies > Create Policy > VLAN
#__________________________________________________________________

resource "intersight_fabric_eth_network_policy" "vlan" {
  for_each    = local.vlan
  description = lookup(each.value, "description", "${each.value.name} VLAN Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = { for v in each.value.profiles : v => v }
    content {
      moid        = var.domains[var.organization].switch_profiles[profiles.value].moid
      object_type = "fabric.SwitchProfile"
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
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

resource "intersight_fabric_vlan" "vlans" {
  depends_on = [
    data.intersight_fabric_multicast_policy.multicast,
    intersight_fabric_eth_network_policy.vlan
  ]
  for_each              = local.vlans
  auto_allow_on_uplinks = each.value.auto_allow_on_uplinks
  is_native             = each.value.native_vlan
  name = length(
    compact([each.value.name])
    ) > 0 && each.value.name_prefix == false ? each.value.name : length(
    regexall("^[0-9]{4}$", each.value.vlan_id)
    ) > 0 ? join("-vl", [each.value.name, each.value.vlan_id]) : length(
    regexall("^[0-9]{3}$", each.value.vlan_id)
    ) > 0 ? join("-vl0", [each.value.name, each.value.vlan_id]) : length(
    regexall("^[0-9]{2}$", each.value.vlan_id)
    ) > 0 ? join("-vl00", [each.value.name, each.value.vlan_id]) : join(
    "-vl000", [each.value.name, each.value.vlan_id]
  )
  vlan_id = each.value.vlan_id
  eth_network_policy {
    moid = intersight_fabric_eth_network_policy.vlan[each.value.vlan_policy].moid
  }
  multicast_policy {
    moid = [for i in data.intersight_fabric_multicast_policy.multicast[0
      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.multicast_policy.org
    ] && i.name == each.value.multicast_policy.name][0]
  }
}
