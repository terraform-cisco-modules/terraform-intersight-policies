#__________________________________________________________________
#
# Intersight Link Aggregation Policy
# GUI Location: Policies > Create Policy > Link Aggregation
#__________________________________________________________________
resource "intersight_fabric_link_aggregation_policy" "map" {
  for_each           = local.link_aggregation
  description        = coalesce(each.value.description, "${each.value.name} Link Aggregation Policy.")
  lacp_rate          = each.value.lacp_rate
  name               = each.value.name
  suspend_individual = each.value.suspend_individual
  organization { moid = var.orgs[each.value.organization] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
