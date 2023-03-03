#__________________________________________________________________
#
# Intersight Serial over LAN Policy
# GUI Location: Policies > Create Policy > Serial over LAN
#__________________________________________________________________

resource "intersight_sol_policy" "serial_over_lan" {
  for_each    = { for v in lookup(local.policies, "serial_over_lan", []) : v.name => v }
  baud_rate   = lookup(each.value, "baud_rate", local.defaults.serial_over_lan.baud_rate)
  com_port    = lookup(each.value, "com_port", local.defaults.serial_over_lan.com_port)
  description = lookup(each.value, "description", "${each.value.name} Serial over LAN Policy.")
  enabled     = lookup(each.value, "enabled", local.defaults.serial_over_lan.enabled)
  name        = "${each.key}${local.defaults.serial_over_lan.name_suffix}"
  ssh_port    = lookup(each.value, "ssh_port", local.defaults.serial_over_lan.ssh_port)
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
