#__________________________________________________________________
#
# Intersight Thermal Policy
# GUI Location: Policies > Create Policy > Thermal
#__________________________________________________________________

resource "intersight_thermal_policy" "map" {
  for_each         = local.thermal
  description      = coalesce(each.value.description, "${each.value.name} Thermal Policy.")
  fan_control_mode = each.value.fan_control_mode
  name             = each.value.name
  organization {
    moid        = var.orgs[each.value.organization]
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
