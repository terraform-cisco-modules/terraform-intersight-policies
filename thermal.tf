#__________________________________________________________________
#
# Intersight Thermal Policy
# GUI Location: Policies > Create Policy > Thermal
#__________________________________________________________________

resource "intersight_thermal_policy" "thermal" {
  for_each         = { for v in lookup(local.policies, "thermal", []) : v.name => v }
  description      = lookup(each.value, "description", "${each.value.name} Thermal Policy.")
  fan_control_mode = lookup(each.value, "fan_control_mode", local.defaults.intersight.policies.thermal.fan_control_mode)
  name             = "${each.key}${local.defaults.intersight.policies.thermal.name_suffix}"
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
