#__________________________________________________________________
#
# Intersight Flow Control Policy
# GUI Location: Policies > Create Policy > Flow Control
#__________________________________________________________________

resource "intersight_fabric_flow_control_policy" "map" {
  for_each                   = local.flow_control
  description                = coalesce(each.value.description, "${each.value.name} Flow Control Policy.")
  name                       = each.value.name
  priority_flow_control_mode = each.value.priority
  receive_direction          = each.value.receive
  send_direction             = each.value.send
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
