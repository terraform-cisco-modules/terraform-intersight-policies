#__________________________________________________________________
#
# FC Zone Policies
# GUI Location: Configure > Policies > Create Policy > FC Zone
#__________________________________________________________________

resource "intersight_fabric_fc_zone_policy" "map" {
  for_each = { for v in lookup(local.policies, "fc_zone", []) : v.name => merge(local.defaults.fc_zone, v, {
    name = "${local.name_prefix.fc_zone}${v.name}${local.name_suffix.fc_zone}"
    tags = lookup(v, "tags", var.policies.global_settings.tags)
  }) }
  description           = coalesce(each.value.description, "${each.value.name} FC Zone Policy.")
  fc_target_zoning_type = each.value.fc_target_zoning_type
  name                  = each.value.name
  organization {
    moid        = local.orgs[local.organization]
    object_type = "organization.Organization"
  }
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
