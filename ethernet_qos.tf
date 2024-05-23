#__________________________________________________________________
#
# Intersight Ethernet QoS Policy
# GUI Location: Policies > Create Policy > Ethernet QoS
#__________________________________________________________________
resource "intersight_vnic_eth_qos_policy" "map" {
  for_each       = local.ethernet_qos
  description    = coalesce(each.value.description, "${each.value.name} Ethernet QoS Policy.")
  burst          = each.value.burst
  cos            = each.value.cos
  mtu            = each.value.mtu
  name           = each.value.name
  priority       = each.value.priority
  rate_limit     = each.value.rate_limit
  trust_host_cos = each.value.enable_trust_host_cos
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
