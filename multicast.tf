#__________________________________________________________________
#
# Intersight Multicast Policy
# GUI Location: Policies > Create Policy > Multicast
#__________________________________________________________________

resource "intersight_fabric_multicast_policy" "map" {
  for_each                = local.multicast
  description             = coalesce(each.value.description, "${each.value.name} Multicast Policy.")
  name                    = each.value.name
  querier_ip_address      = each.value.querier_ip_address
  querier_ip_address_peer = each.value.querier_ip_address_peer
  querier_state           = each.value.querier_state
  snooping_state          = each.value.snooping_state
  src_ip_proxy            = each.value.source_ip_proxy_state
  organization {
    moid        = var.orgs[each.value.organization]
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

resource "intersight_fabric_multicast_policy" "data" {
  depends_on = [intersight_fabric_multicast_policy.map]
  for_each = {
    for v in local.pp.multicast : v => v if lookup(local.multicast, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = var.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, create_time, description, domain_group_moid, mod_time, owners,
      parent, permission_resources, shared_scope, tags, version_context
    ]
    prevent_destroy = true
  }
}
