#__________________________________________________________________
#
# Intersight Link Control Policy
# GUI Location: Policies > Create Policy > Link Control
#__________________________________________________________________

resource "intersight_fabric_link_control_policy" "map" {
  for_each = { for v in lookup(local.policies, "link_control", []) : v.name => merge(local.defaults.link_control, v, {
    name = "${local.name_prefix.link_control}${v.name}${local.name_suffix.link_control}"
    tags = lookup(v, "tags", var.policies.global_settings.tags)
  }) }
  description = coalesce(each.value.description, "${each.value.name} Link Control Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[local.organization]
    object_type = "organization.Organization"
  }
  udld_settings {
    admin_state = each.value.admin_state
    mode        = each.value.mode
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
