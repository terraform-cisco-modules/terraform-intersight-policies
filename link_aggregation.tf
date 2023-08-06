#__________________________________________________________________
#
# Intersight Link Aggregation Policy
# GUI Location: Policies > Create Policy > Link Aggregation
#__________________________________________________________________

resource "intersight_fabric_link_aggregation_policy" "map" {
  for_each = { for v in lookup(local.policies, "link_aggregation", []) : v.name => merge(local.defaults.link_aggregation, v, {
    name = "${local.name_prefix.link_aggregation}${v.name}${local.name_suffix.link_aggregation}"
    tags = lookup(v, "tags", var.tags)
  }) }
  description        = coalesce(each.value.description, "${each.value.name} Link Aggregation Policy.")
  lacp_rate          = each.value.lacp_rate
  name               = each.value.name
  suspend_individual = each.value.suspend_individual
  organization {
    moid        = local.orgs[var.organization]
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
