#__________________________________________________________________
#
# Intersight Power Policy
# GUI Location: Policies > Create Policy > Power
#__________________________________________________________________

resource "intersight_power_policy" "power" {
  for_each         = { for v in lookup(local.policies, "power", []) : v.name => v }
  allocated_budget = lookup(each.value, "power_allocation", local.defaults.power.power_allocation)
  description = lookup(
  each.value, "description", "${local.name_prefix.power}${each.key}${local.name_suffix.power} Power Policy.")
  dynamic_rebalancing = lookup(
    each.value, "dynamic_power_rebalancing", local.defaults.power.dynamic_power_rebalancing
  )
  extended_power_capacity = lookup(
    each.value, "extended_power_capacity", local.defaults.power.extended_power_capacity
  )
  name                = "${local.name_prefix.power}${each.key}${local.name_suffix.power}"
  power_priority      = lookup(each.value, "power_priority", local.defaults.power.power_priority)
  power_profiling     = lookup(each.value, "power_profiling", local.defaults.power.power_profiling)
  power_restore_state = lookup(each.value, "power_restore", local.defaults.power.power_restore)
  power_save_mode     = lookup(each.value, "power_save_mode", local.defaults.power.power_save_mode)
  redundancy_mode     = lookup(each.value, "power_redundancy", local.defaults.power.power_redundancy)
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in lookup(each.value, "tags", var.tags) : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
