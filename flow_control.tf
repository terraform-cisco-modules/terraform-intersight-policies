#__________________________________________________________________
#
# Intersight Flow Control Policy
# GUI Location: Policies > Create Policy > Flow Control
#__________________________________________________________________

resource "intersight_fabric_flow_control_policy" "map" {
  for_each = { for v in lookup(local.policies, "flow_control", []) : v.name => merge(local.defaults.flow_control, v, {
    name = "${local.name_prefix.flow_control}${v.name}${local.name_suffix.flow_control}"
    tags = lookup(v, "tags", var.tags)
  }) }
  description                = coalesce(each.value.description, "${each.value.name} Flow Control Policy.")
  name                       = each.value.name
  priority_flow_control_mode = each.value.priority
  receive_direction          = each.value.receive
  send_direction             = each.value.send
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
