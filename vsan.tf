#__________________________________________________________________
#
# Intersight VSAN Policy
# GUI Location: Policies > Create Policy > VSAN
#__________________________________________________________________
resource "intersight_fabric_fc_network_policy" "map" {
  for_each        = local.vsan
  description     = coalesce(each.value.description, "${each.value.name} VSAN Policy.")
  enable_trunking = each.value.uplink_trunking
  name            = each.value.name
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
# Intersight > {VSAN Policy} > Edit  > Add VSAN
# GUI Location: Policies > Create Policy > VSAN > Add VSAN
#__________________________________________________________________
resource "intersight_fabric_vsan" "map" {
  depends_on = [
    intersight_fabric_fc_network_policy.map
  ]
  for_each       = local.vsans
  default_zoning = each.value.default_zoning
  fcoe_vlan      = each.value.fcoe_vlan_id
  #fc_zone_sharing_mode = each.value.fc_zone_sharing_mode
  name = length(compact([each.value.name])) > 0 ? each.value.name : length(
    regexall("^[0-9]{4}$", each.value.vsan_id)) > 0 ? "VSAN${each.value.vsan_id}" : length(
    regexall("^[0-9]{3}$", each.value.vsan_id)) > 0 ? "VSAN0${each.value.vsan_id}" : length(
  regexall("^[0-9]{2}$", each.value.vsan_id)) > 0 ? "VSAN00${each.value.vsan_id}" : "VSAN000${each.value.vsan_id}"
  vsan_id    = each.value.vsan_id
  vsan_scope = each.value.vsan_scope
  fc_network_policy {
    moid = intersight_fabric_fc_network_policy.map[each.value.vsan_policy].moid
  }
}
