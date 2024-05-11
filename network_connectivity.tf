#__________________________________________________________________
#
# Intersight Network Connectivity Policy
# GUI Location: Policies > Create Policy > Network Connectivity
#__________________________________________________________________
resource "intersight_networkconfig_policy" "map" {
  for_each                 = local.network_connectivity
  alternate_ipv4dns_server = length(each.value.dns_servers_v4) > 1 ? each.value.dns_servers_v4[1] : "0.0.0.0"
  alternate_ipv6dns_server = length(each.value.dns_servers_v6) > 1 ? each.value.dns_servers_v6[1] : "::"
  description              = coalesce(each.value.description, "${each.value.name} Network Connectivity Policy.")
  dynamic_dns_domain       = each.value.update_domain
  enable_dynamic_dns       = each.value.enable_dynamic_dns
  enable_ipv4dns_from_dhcp = each.value.obtain_ipv4_dns_from_dhcp
  enable_ipv6              = each.value.obtain_ipv6_dns_from_dhcp == true || length(each.value.dns_servers_v6) > 0 ? true : false
  enable_ipv6dns_from_dhcp = each.value.obtain_ipv6_dns_from_dhcp
  preferred_ipv4dns_server = length(each.value.dns_servers_v4) > 0 ? each.value.dns_servers_v4[0] : "0.0.0.0"
  preferred_ipv6dns_server = length(each.value.dns_servers_v6) > 0 ? each.value.dns_servers_v6[0] : "::"
  name                     = each.value.name
  organization {
    moid        = var.orgs[each.value.organization]
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
