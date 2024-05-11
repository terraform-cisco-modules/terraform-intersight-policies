#__________________________________________________________________
#
# Intersight Power Policy
# GUI Location: Policies > Create Policy > Power
#__________________________________________________________________
resource "intersight_power_policy" "map" {
  for_each                = local.power
  allocated_budget        = each.value.power_allocation
  description             = coalesce(each.value.description, "${each.value.name} Power Policy.")
  dynamic_rebalancing     = each.value.dynamic_power_rebalancing
  extended_power_capacity = each.value.extended_power_capacity
  name                    = each.value.name
  power_priority          = each.value.power_priority
  power_profiling         = each.value.power_profiling
  power_restore_state     = each.value.power_restore
  power_save_mode         = each.value.power_save_mode
  redundancy_mode         = each.value.power_redundancy
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
