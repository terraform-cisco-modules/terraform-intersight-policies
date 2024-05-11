#__________________________________________________________________
#
# Intersight SSH Policy
# GUI Location: Policies > Create Policy > SSH
#__________________________________________________________________
resource "intersight_ssh_policy" "map" {
  for_each    = local.ssh
  description = coalesce(each.value.description, "${each.value.name} SSH Policy.")
  enabled     = each.value.enable_ssh
  name        = each.value.name
  port        = each.value.ssh_port
  timeout     = each.value.ssh_timeout
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
