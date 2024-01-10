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
  organization {
    moid        = local.orgs[local.organization]
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

resource "intersight_fabric_flow_control_policy" "data" {
  depends_on = [intersight_fabric_flow_control_policy.map]
  for_each = {
    for v in local.pp.flow_control : v => v if lookup(local.flow_control, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, mod_time, owners,
      parent, priority_flow_control_mode, permission_resources, receive_direction, send_direction, shared_scope, tags, version_context
    ]
    prevent_destroy = true
  }
}
