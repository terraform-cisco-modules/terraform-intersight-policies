#__________________________________________________________________
#
# Intersight Device Connector Policy
# GUI Location: Policies > Create Policy > Device Connector
#__________________________________________________________________

resource "intersight_deviceconnector_policy" "map" {
  for_each = { for v in lookup(local.policies, "device_connector", []) : v.name => merge(local.defaults.device_connector, v, {
    name = "${local.name_prefix.device_connector}${v.name}${local.name_suffix.device_connector}"
    tags = lookup(v, "tags", var.tags
  ) }) }
  description     = coalesce(each.value.description, "${each.value.name} Device Connector Policy.")
  lockout_enabled = each.value.configuration_lockout
  name            = each.value.name
  organization {
    moid        = local.orgs[var.organization]
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
