#__________________________________________________________________
#
# Intersight Memory Policy
# GUI Location: Policies > Create Policy > Memory
#__________________________________________________________________
resource "intersight_memory_policy" "map" {
  for_each                 = local.memory
  description              = coalesce(each.value.description, "${each.value.name} Memory Policy.")
  name                     = each.value.name
  enable_dimm_blocklisting = each.value.dimm_blocklisting
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
