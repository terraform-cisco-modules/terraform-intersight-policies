#__________________________________________________________________
#
# Intersight Thermal Policy
# GUI Location: Policies > Create Policy > Thermal
#__________________________________________________________________

resource "intersight_thermal_policy" "map" {
  for_each = { for v in lookup(local.policies, "thermal", []) : v.name => merge(local.defaults.thermal, v, {
    name = "${local.name_prefix.thermal}${v.name}${local.name_suffix.thermal}"
    tags = lookup(v, "tags", var.policies.global_settings.tags)
  }) }
  description      = coalesce(each.value.description, "${each.value.name} Thermal Policy.")
  fan_control_mode = each.value.fan_control_mode
  name             = each.value.name
  organization {
    moid        = local.orgs[local.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
