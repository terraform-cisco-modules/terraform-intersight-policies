#__________________________________________________________________
#
# Intersight Multicast Policy
# GUI Location: Policies > Create Policy > Multicast
#__________________________________________________________________

resource "intersight_fabric_multicast_policy" "multicast" {
  for_each = { for v in lookup(local.policies, "multicast", []) : v.name => v }
  description = lookup(
  each.value, "description", "${local.name_prefix.multicast}${each.key}${local.name_suffix.multicast} Multicast Policy.")
  name = "${local.name_prefix.multicast}${each.key}${local.name_suffix.multicast}"
  querier_ip_address = lookup(
    each.value, "querier_ip_address", local.defaults.multicast.querier_ip_address
  )
  querier_ip_address_peer = lookup(
    each.value, "querier_ip_address_peer", local.defaults.multicast.querier_ip_address_peer
  )
  querier_state  = lookup(each.value, "querier_state", local.defaults.multicast.querier_state)
  snooping_state = lookup(each.value, "snooping_state", local.defaults.multicast.snooping_state)
  src_ip_proxy   = lookup(each.value, "source_ip_proxy_state", local.defaults.multicast.source_ip_proxy_state)
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
