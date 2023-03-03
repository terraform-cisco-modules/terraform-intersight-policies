#__________________________________________________________________
#
# Intersight Flow Control Policy
# GUI Location: Policies > Create Policy > Flow Control
#__________________________________________________________________

resource "intersight_fabric_flow_control_policy" "flow_control" {
  for_each                   = { for v in lookup(local.policies, "flow_control", []) : v.name => v }
  description                = lookup(each.value, "description", "${each.value.name} Flow Control Policy.")
  name                       = "${each.key}${local.defaults.flow_control.name_suffix}"
  priority_flow_control_mode = lookup(each.value, "priority", local.defaults.flow_control.priority)
  receive_direction          = lookup(each.value, "receive", local.defaults.flow_control.receive)
  send_direction             = lookup(each.value, "send", local.defaults.flow_control.send)
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
