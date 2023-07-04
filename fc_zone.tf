#__________________________________________________________________
#
# FC Zone Policies
# GUI Location: Configure > Policies > Create Policy > FC Zone
#__________________________________________________________________

resource "intersight_fabric_fc_zone_policy" "fc_zone" {
  for_each = { for v in lookup(local.policies, "fc_zone", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.fc_zone}${each.key}${local.name_suffix.fc_zone} FC Zone Policy.")
  fc_target_zoning_type = lookup(
    each.value, "fc_target_zoning_type", local.defaults.fc_zone.fc_target_zoning_type
  )
  name = "${local.name_prefix.fc_zone}${each.key}${local.name_suffix.fc_zone}"
  organization {
    moid        = local.orgs[var.organization]
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
    for_each = { for v in lookup(each.value, "tags", var.tags) : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
