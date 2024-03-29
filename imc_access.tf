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
    enable_ip_v6 = each.value.ipv6_address_configuration
    object_type  = "access.AddressType"
  }
  configuration_type {
    configure_inband      = length(regexall("UNUSED", each.value.inband_ip_pool.name)) > 0 ? false : true
    configure_out_of_band = length(regexall("UNUSED", each.value.out_of_band_ip_pool.name)) > 0 ? false : true
  }
  organization { moid = var.orgs[each.value.organization] }
  dynamic "inband_ip_pool" {
    for_each = { for v in [each.value.inband_ip_pool] : "${v.org}/${v.name}" => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.pools["ip"].moids), "${inband_ip_pool.value.org}/${inband_ip_pool.value.name}"
        ) == true ? local.pools.ip.moids["${inband_ip_pool.value.org}/${inband_ip_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["ip"
          ].results : i.moid if jsondecode(i.additional_properties).Name == inband_ip_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[inband_ip_pool.value.org]][0]
      object_type = "ippool.Pool"
    }
  }
  dynamic "out_of_band_ip_pool" {
    for_each = { for v in [each.value.out_of_band_ip_pool] : "${v.org}/${v.name}" => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.pools["ip"].moids), "${out_of_band_ip_pool.value.org}/${out_of_band_ip_pool.value.name}"
        ) == true ? local.pools.ip.moids["${out_of_band_ip_pool.value.org}/${out_of_band_ip_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["ip"
          ].results : i.moid if jsondecode(i.additional_properties).Name == out_of_band_ip_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[out_of_band_ip_pool.value.org]][0]
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
