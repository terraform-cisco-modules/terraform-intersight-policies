#__________________________________________________________________
#
# Intersight Network Connectivity Policy
# GUI Location: Policies > Create Policy > Network Connectivity
#__________________________________________________________________

resource "intersight_networkconfig_policy" "network_connectivity" {
  for_each                 = local.network_connectivity
  alternate_ipv4dns_server = length(each.value.dns_servers_v4) > 1 ? each.value.dns_servers_v4[1] : null
  alternate_ipv6dns_server = length(each.value.dns_servers_v6) > 1 ? each.value.dns_servers_v6[1] : null
  description              = lookup(each.value, "description", "${each.value.name} Network Connectivity Policy.")
  dynamic_dns_domain       = each.value.update_domain
  enable_dynamic_dns       = each.value.enable_dynamic_dns
  enable_ipv4dns_from_dhcp = each.value.obtain_ipv4_dns_from_dhcp
  enable_ipv6              = each.value.enable_ipv6
  enable_ipv6dns_from_dhcp = each.value.obtain_ipv6_dns_from_dhcp
  preferred_ipv4dns_server = length(each.value.dns_servers_v4) > 0 ? each.value.dns_servers_v4[0] : null
  preferred_ipv6dns_server = length(each.value.dns_servers_v6) > 0 ? each.value.dns_servers_v6[0] : null
  name                     = each.value.name
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "profiles" {
    for_each = { for v in each.value.profiles : v.name => v }
    content {
      moid        = var.domains[var.organization].switch_profiles[profiles.value.name].moid
      object_type = profiles.value.object_type
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
