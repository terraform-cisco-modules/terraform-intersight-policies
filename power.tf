#__________________________________________________________________
#
# Intersight Power Policy
# GUI Location: Policies > Create Policy > Power
#__________________________________________________________________

resource "intersight_power_policy" "power" {
  for_each         = { for v in lookup(local.policies, "power", []) : v.name => v }
  allocated_budget = lookup(each.value, "power_allocation", local.defaults.intersight.policies.power.power_allocation)
  description      = lookup(each.value, "description", "${each.value.name} Power Policy.")
  dynamic_rebalancing = lookup(
    each.value, "dynamic_power_rebalancing", local.defaults.intersight.policies.power.dynamic_power_rebalancing
  )
  extended_power_capacity = lookup(
    each.value, "extended_power_capacity", local.defaults.intersight.policies.power.extended_power_capacity
  )
  name                = "${each.key}${local.defaults.intersight.policies.power.name_suffix}"
  power_priority      = lookup(each.value, "power_priority", local.defaults.intersight.policies.power.power_priority)
  power_profiling     = lookup(each.value, "power_profiling", local.defaults.intersight.policies.power.power_profiling)
  power_restore_state = lookup(each.value, "power_restore", local.defaults.intersight.policies.power.power_restore)
  power_save_mode     = lookup(each.value, "power_save_mode", local.defaults.intersight.policies.power.power_save_mode)
  redundancy_mode     = lookup(each.value, "power_redundancy", local.defaults.intersight.policies.power.power_redundancy)
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
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
