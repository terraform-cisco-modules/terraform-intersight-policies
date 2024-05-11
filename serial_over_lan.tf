#__________________________________________________________________
#
# Intersight Serial over LAN Policy
# GUI Location: Policies > Create Policy > Serial over LAN
#__________________________________________________________________
resource "intersight_sol_policy" "map" {
  for_each    = local.serial_over_lan
  baud_rate   = each.value.baud_rate
  com_port    = each.value.com_port
  description = coalesce(each.value.description, "${each.value.name} Serial over LAN Policy.")
  enabled     = each.value.enabled
  name        = each.value.name
  ssh_port    = each.value.ssh_port
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
