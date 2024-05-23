#__________________________________________________________________
#
# Intersight IMC Access Policy
# GUI Location: Policies > Create Policy > IMC Access
#__________________________________________________________________

resource "intersight_access_policy" "map" {
  for_each    = local.imc_access
  description = coalesce(each.value.description, "${each.value.name} IMC Access Policy.")
  inband_vlan = each.value.inband_vlan_id
  name        = each.value.name
  address_type {
    enable_ip_v4 = each.value.ipv4_address_configuration
    enable_ip_v6 = length(regexall("UNUSED", each.value.inband_ip_pool)) == 0 ? each.value.ipv6_address_configuration : false
    object_type  = "access.AddressType"
  }
  configuration_type {
    configure_inband      = length(regexall("UNUSED", each.value.inband_ip_pool)) == 0 ? true : false
    configure_out_of_band = length(regexall("UNUSED", each.value.out_of_band_ip_pool)) == 0 ? true : false
  }
  organization { moid = var.orgs[each.value.org] }
  dynamic "inband_ip_pool" {
    for_each = { for v in [each.value.inband_ip_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.pools.ip.moids), inband_ip_pool.value
      ) == true ? local.pools.ip.moids[inband_ip_pool.value] : local.pools_data["ip"][inband_ip_pool.value].moid
      object_type = "ippool.Pool"
    }
  }
  dynamic "out_of_band_ip_pool" {
    for_each = { for v in [each.value.out_of_band_ip_pool] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.pools.ip.moids), out_of_band_ip_pool.value
      ) == true ? local.pools.ip.moids[out_of_band_ip_pool.value] : local.pools_data["ip"][out_of_band_ip_pool.value].moid
      object_type = "ippool.Pool"
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
