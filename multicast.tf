#__________________________________________________________________
#
# Intersight Multicast Policy
# GUI Location: Policies > Create Policy > Multicast
#__________________________________________________________________

resource "intersight_fabric_multicast_policy" "multicast" {
  for_each    = { for v in lookup(local.policies, "multicast", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Multicast Policy.")
  name        = "${each.key}${local.defaults.intersight.policies.multicast.name_suffix}"
  querier_ip_address = lookup(
    each.value, "querier_ip_address", local.defaults.intersight.policies.multicast.querier_ip_address
  )
  querier_ip_address_peer = lookup(
    each.value, "querier_ip_address_peer", local.defaults.intersight.policies.multicast.querier_ip_address_peer
  )
  querier_state  = lookup(each.value, "querier_state", local.defaults.intersight.policies.multicast.querier_state)
  snooping_state = lookup(each.value, "snooping_state", local.defaults.intersight.policies.multicast.snooping_state)
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
