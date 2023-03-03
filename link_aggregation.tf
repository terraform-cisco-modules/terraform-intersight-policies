#__________________________________________________________________
#
# Intersight Link Aggregation Policy
# GUI Location: Policies > Create Policy > Link Aggregation
#__________________________________________________________________

resource "intersight_fabric_link_aggregation_policy" "link_aggregation" {
  for_each    = { for v in lookup(local.policies, "link_aggregation", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Link Aggregation Policy.")
  lacp_rate   = lookup(each.value, "lacp_rate", local.defaults.link_aggregation.lacp_rate)
  name        = "${each.key}${local.defaults.link_aggregation.name_suffix}"
  suspend_individual = lookup(
    each.value, "suspend_individual", local.defaults.link_aggregation.suspend_individual
  )
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
