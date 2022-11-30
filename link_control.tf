#__________________________________________________________________
#
# Intersight Link Control Policy
# GUI Location: Policies > Create Policy > Link Control
#__________________________________________________________________

resource "intersight_fabric_link_control_policy" "link_control" {
  for_each    = { for v in lookup(local.policies, "link_control", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Link Control Policy.")
  name        = "${each.key}${local.defaults.intersight.policies.link_control.name_suffix}"
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  udld_settings {
    admin_state = lookup(each.value, "admin_state", local.defaults.intersight.policies.link_control.admin_state)
    mode        = lookup(each.value, "mode", local.defaults.intersight.policies.link_control.mode)
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
