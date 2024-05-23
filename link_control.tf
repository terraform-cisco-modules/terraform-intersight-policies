#__________________________________________________________________
#
# Intersight Link Control Policy
# GUI Location: Policies > Create Policy > Link Control
#__________________________________________________________________
resource "intersight_fabric_link_control_policy" "map" {
  for_each    = local.link_control
  description = coalesce(each.value.description, "${each.value.name} Link Control Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.org] }
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
