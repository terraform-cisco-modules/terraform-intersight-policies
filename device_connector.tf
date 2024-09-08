#__________________________________________________________________
#
# Intersight Device Connector Policy
# GUI Location: Policies > Create Policy > Device Connector
#__________________________________________________________________
resource "intersight_deviceconnector_policy" "map" {
  for_each        = local.device_connector
  description     = coalesce(each.value.description, "${each.value.name} Device Connector Policy.")
  lockout_enabled = each.value.configuration_from_intersight_only
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
