#__________________________________________________________________
#
# Intersight Device Connector Policy
# GUI Location: Policies > Create Policy > Device Connector
#__________________________________________________________________

resource "intersight_deviceconnector_policy" "device_connector" {
  for_each    = { for v in lookup(local.policies, "device_connector", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Device Connector Policy.")
  lockout_enabled = lookup(
    each.value, "configuration_lockout", local.defaults.intersight.policies.device_connector.configuration_lockout
  )
  name = "${each.key}${local.defaults.intersight.policies.device_connector.name_suffix}"
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
