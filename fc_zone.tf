#__________________________________________________________________
#
# FC Zone Policies
# GUI Location: Configure > Policies > Create Policy > FC Zone
#__________________________________________________________________

resource "intersight_fabric_fc_zone_policy" "map" {
  for_each              = local.fc_zone
  description           = coalesce(each.value.description, "${each.value.name} FC Zone Policy.")
  fc_target_zoning_type = each.value.fc_target_zoning_type
  name                  = each.value.name
  organization { moid = var.orgs[each.value.organization] }
  dynamic "fc_target_members" {
    for_each = { for v in lookup(each.value, "targets", []) : v.name => v }
    content {
      name      = fc_target_members.key
      switch_id = fc_target_members.value.switch_id
      vsan_id   = fc_target_members.value.vsan_id
      wwpn      = fc_target_members.value.wwpn
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_fc_zone_policy" "data" {
  depends_on = [intersight_fabric_fc_zone_policy.map]
  for_each   = { for v in local.pp.fc_zone : v => v if lookup(local.fc_zone, v, "#NOEXIST") == "#NOEXIST" }
  name       = element(split("/", each.value), 1)
  organization { moid = var.orgs[element(split("/", each.value), 0)] }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, fc_target_zoning_type,
      fc_target_members, mod_time, owners, parent, permission_resources, shared_scope, tags, version_context
    ]
    prevent_destroy = true
  }
}
