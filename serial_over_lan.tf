#__________________________________________________________________
#
# Intersight Serial over LAN Policy
# GUI Location: Policies > Create Policy > Serial over LAN
#__________________________________________________________________

resource "intersight_sol_policy" "map" {
  for_each = { for v in lookup(local.policies, "serial_over_lan", []) : v.name => merge(local.defaults.serial_over_lan, v, {
    name = "${local.name_prefix.serial_over_lan}${v.name}${local.name_suffix.serial_over_lan}"
    tags = lookup(v, "tags", var.policies.global_settings.tags)
  }) }
  baud_rate   = each.value.baud_rate
  com_port    = each.value.com_port
  description = coalesce(each.value.description, "${each.value.name} Serial over LAN Policy.")
  enabled     = each.value.enabled
  name        = each.value.name
  ssh_port    = each.value.ssh_port
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
