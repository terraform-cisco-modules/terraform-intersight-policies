#__________________________________________________________________
#
# Intersight Ethernet QoS Policy
# GUI Location: Policies > Create Policy > Ethernet QoS
#__________________________________________________________________

resource "intersight_vnic_eth_qos_policy" "ethernet_qos" {
  for_each    = { for v in lookup(local.policies, "ethernet_qos", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Ethernet QoS Policy.")
  burst       = lookup(each.value, "burst", local.defaults.intersight.policies.ethernet_qos.burst)
  cos         = lookup(each.value, "cos", local.defaults.intersight.policies.ethernet_qos.cos)
  mtu         = lookup(each.value, "mtu", local.defaults.intersight.policies.ethernet_qos.mtu)
  name        = "${each.key}${local.defaults.intersight.policies.ethernet_qos.name_suffix}"
  priority    = lookup(each.value, "priority", local.defaults.intersight.policies.ethernet_qos.priority)
  rate_limit  = lookup(each.value, "rate_limit", local.defaults.intersight.policies.ethernet_qos.rate_limit)
  trust_host_cos = lookup(
    each.value, "enable_trust_host_cos", local.defaults.intersight.policies.ethernet_qos.enable_trust_host_cos
  )
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
