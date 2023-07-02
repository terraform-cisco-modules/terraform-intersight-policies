#__________________________________________________________________
#
# Intersight Device Connector Policy
# GUI Location: Policies > Create Policy > Device Connector
#__________________________________________________________________

resource "intersight_deviceconnector_policy" "device_connector" {
  for_each = { for v in lookup(local.policies, "device_connector", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.device_connector}${each.key}${local.name_suffix.device_connector} Device Connector Policy.")
  lockout_enabled = lookup(
    each.value, "configuration_lockout", local.defaults.device_connector.configuration_lockout
  )
  name = "${local.name_prefix.certificate_management}${each.key}${local.name_suffix.certificate_management}"
  organization {
    moid        = local.orgs[var.organization]
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
