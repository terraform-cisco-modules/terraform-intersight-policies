#__________________________________________________________________
#
# Intersight Thermal Policy
# GUI Location: Policies > Create Policy > Thermal
#__________________________________________________________________

resource "intersight_thermal_policy" "thermal" {
  for_each = { for v in lookup(local.policies, "thermal", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.thermal}${each.key}${local.name_suffix.thermal} Thermal Policy.")
  fan_control_mode = lookup(each.value, "fan_control_mode", local.defaults.thermal.fan_control_mode)
  name             = "${local.name_prefix.thermal}${each.key}${local.name_suffix.thermal}"
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in lookup(each.value, "tags", var.tags) : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
