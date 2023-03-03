#__________________________________________________________________
#
# Intersight IMC Access Policy
# GUI Location: Policies > Create Policy > IMC Access
#__________________________________________________________________

resource "intersight_access_policy" "imc_access" {
  depends_on = [
    data.intersight_ippool_pool.ip
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
    configure_inband      = length(regexall("UNUSED", each.value.inband_ip_pool.name)) > 0 ? false : true
    configure_out_of_band = length(regexall("UNUSED", each.value.out_of_band_ip_pool.name)) > 0 ? false : true
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "inband_ip_pool" {
    for_each = { for v in [each.value.inband_ip_pool.name] : v => v if each.value.inband_ip_pool.name != "UNUSED" }
    content {
      moid = [for i in data.intersight_ippool_pool.ip[0].results : i.moid if i.organization[0
      ].moid == local.orgs[each.value.inband_ip_pool.organization] && i.name == each.value.inband_ip_pool.name][0]
      object_type = "ippool.Pool"
    }
  }
  dynamic "out_of_band_ip_pool" {
    for_each = {
      for v in [each.value.out_of_band_ip_pool.name] : v => v if each.value.out_of_band_ip_pool.name != "UNUSED"
    }
    content {
      moid = [for i in data.intersight_ippool_pool.ip[0].results : i.moid if i.organization[0
        ].moid == local.orgs[each.value.out_of_band_ip_pool.organization
      ] && i.name == each.value.out_of_band_ip_pool.name][0]
      object_type = "ippool.Pool"
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
