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

resource "intersight_vnic_eth_qos_policy" "data" {
  depends_on = [intersight_vnic_eth_qos_policy.map]
  for_each = {
    for v in local.pp.ethernet_qos : v => v if lookup(local.ethernet_qos, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, burst, cos, create_time, description, domain_group_moid, mod_time,
      priority, owners, parent, permission_resources, rate_limit, shared_scope, tags, trust_host_cos, version_context
    ]
    prevent_destroy = true
  }
}
