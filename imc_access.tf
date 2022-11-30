#__________________________________________________________________
#
# Intersight IMC Access Policy
# GUI Location: Policies > Create Policy > IMC Access
#__________________________________________________________________

resource "intersight_access_policy" "imc_access" {
  for_each    = { for v in lookup(local.policies, "imc_access", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} IMC Access Policy.")
  inband_vlan = lookup(
    each.value, "inband_vlan_id", local.defaults.intersight.policies.imc_access.inband_vlan_id
  )
  name = "${each.key}${local.defaults.intersight.policies.imc_access.name_suffix}"
  address_type {
    enable_ip_v4 = lookup(
      each.value, "ipv4_address_configuration", local.defaults.intersight.policies.imc_access.ipv4_address_configuration
    )
    enable_ip_v6 = lookup(
      each.value, "ipv6_address_configuration", local.defaults.intersight.policies.imc_access.ipv6_address_configuration
    )
    object_type = "access.AddressType"
  }
  configuration_type {
    configure_inband      = length(compact([lookup(each.value, "inband_ip_pool", "")])) > 0 ? true : false
    configure_out_of_band = length(compact([lookup(each.value, "out_of_band_ip_pool", "")])) > 0 ? true : false
  }
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  dynamic "inband_ip_pool" {
    for_each = { for v in compact([each.value.inband_ip_pool]) : v => v }
    content {
      moid        = var.pools.ip[inband_ip_pool.value]
      object_type = "ippool.Pool"
    }
  }
  dynamic "out_of_band_ip_pool" {
    for_each = { for v in compact([each.value.out_of_band_ip_pool]) : v => v }
    content {
      moid        = var.pools.ip[out_of_band_ip_pool.value]
      object_type = "ippool.Pool"
    }
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
