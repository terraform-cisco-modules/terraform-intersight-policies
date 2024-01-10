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

resource "intersight_fabric_link_aggregation_policy" "data" {
  depends_on = [intersight_fabric_link_aggregation_policy.map]
  for_each = {
    for v in local.pp.link_aggregation : v => v if lookup(local.link_aggregation, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, lacp_rate,
      mod_time, owners, parent, permission_resources, shared_scope, suspend_individual, tags, version_context
    ]
    prevent_destroy = true
  }
}
