#__________________________________________________________________
#
# Intersight Link Control Policy
# GUI Location: Policies > Create Policy > Link Control
#__________________________________________________________________

resource "intersight_fabric_link_control_policy" "map" {
  for_each    = local.link_control
  description = coalesce(each.value.description, "${each.value.name} Link Control Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.organization] }
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

resource "intersight_fabric_link_control_policy" "data" {
  depends_on = [intersight_fabric_link_aggregation_policy.map]
  for_each   = { for v in local.pp.link_control : v => v if lookup(local.link_control, v, "#NOEXIST") == "#NOEXIST" }
  name       = element(split("/", each.value), 1)
  organization { moid = var.orgs[element(split("/", each.value), 0)] }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid,
      mod_time, owners, parent, permission_resources, shared_scope, tags, udld_settings, version_context
    ]
    prevent_destroy = true
  }
}
