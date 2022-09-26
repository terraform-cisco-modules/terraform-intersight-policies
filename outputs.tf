# output "ip_pools" {
#   description = "Moid of the IP Pools."
#   value = lookup(local.modules, "pools_ip", true) ? { for v in sort(
#     keys(module.ip_pools)
#   ) : v => module.ip_pools[v] } : {}
# }
# 
# output "iqn_pools" {
#   description = "Moid of the IQN Pools."
#   value = lookup(local.modules, "pools_iqn", true) ? { for v in sort(
#     keys(module.iqn_pools)
#   ) : v => module.iqn_pools[v] } : {}
# }
# 
# output "mac_pools" {
#   description = "Moid of the MAC Pools."
#   value = lookup(local.modules, "pools_mac", true) ? { for v in sort(
#     keys(module.mac_pools)
#   ) : v => module.mac_pools[v] } : {}
# }
# 
# output "resource_pools" {
#   description = "Moid of the Resource Pools."
#   value = lookup(local.modules, "pools_resource", true) ? { for v in sort(
#     keys(module.resource_pools)
#   ) : v => module.resource_pools[v] } : {}
# }
# 
# output "uuid_pools" {
#   description = "Moid of the UUID Pools."
#   value = lookup(local.modules, "pools_uuid", true) ? { for v in sort(
#     keys(module.uuid_pools)
#   ) : v => module.uuid_pools[v] } : {}
# }
# 
# output "wwnn_pools" {
#   description = "Moid of the WWNN Pools."
#   value = lookup(local.modules, "pools_wwnn", true) ? { for v in sort(
#     keys(module.wwnn_pools)
#   ) : v => module.wwnn_pools[v] } : {}
# }
# 
# output "wwpn_pools" {
#   description = "Moid of the WWPN Pools."
#   value = lookup(local.modules, "pools_wwpn", true) ? { for v in sort(
#     keys(module.wwpn_pools)
#   ) : v => module.wwpn_pools[v] } : {}
# }
# 
output "domains" {
  value = local.domains
}

output "orgs" {
  value = local.orgs
}

