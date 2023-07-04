#__________________________________________________________________
#
# Intersight IMC Access Policy
# GUI Location: Policies > Create Policy > IMC Access
#__________________________________________________________________

resource "intersight_access_policy" "imc_access" {
  depends_on = [
    data.intersight_search_search_item.ip
  ]
  for_each    = { for k, v in local.imc_access : k => v }
  description = lookup(each.value, "description", "${each.value.name} IMC Access Policy.")
  inband_vlan = each.value.inband_vlan_id
  name        = each.value.name
  address_type {
    enable_ip_v4 = each.value.ipv4_address_configuration
    enable_ip_v6 = each.value.ipv6_address_configuration
    object_type  = "access.AddressType"
  }
  configuration_type {
    configure_inband = length(regexall("UNUSED", each.value.inband_ip_pool.name)
    ) > 0 ? false : true
    configure_out_of_band = length(regexall("UNUSED", each.value.out_of_band_ip_pool.name)
    ) > 0 ? false : true
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "inband_ip_pool" {
    for_each = {
      for v in [each.value.inband_ip_pool.name] : v => v if each.value.inband_ip_pool.name != "UNUSED"
    }
    content {
      moid = length(regexall(false, var.moids_pools)) > 0 ? var.pools[each.value.inband_ip_pool.org].ip[
        each.value.inband_ip_pool.name
        ] : [for i in data.intersight_search_search_item.ip[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.inband_ip_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.inband_ip_pool.name][0]
      object_type = "ippool.Pool"
    }
  }
  dynamic "out_of_band_ip_pool" {
    for_each = { for v in [each.value.out_of_band_ip_pool.name
      ] : v => v if each.value.out_of_band_ip_pool.name != "UNUSED"
    }
    content {
      moid = length(regexall(false, var.moids_pools)) > 0 ? var.pools[each.value.out_of_band_ip_pool.org].ip[
        each.value.out_of_band_ip_pool.name
        ] : [for i in data.intersight_search_search_item.ip[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.out_of_band_ip_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.out_of_band_ip_pool.name][0]
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
