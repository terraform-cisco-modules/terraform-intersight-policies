#__________________________________________________________________
#
# Organization Data Objects
#__________________________________________________________________

data "intersight_organization_organization" "orgs" {
}

#__________________________________________________________________
#
# Pool Data Objects
#__________________________________________________________________

data "intersight_ippool_pool" "ip" {
  for_each = { for v in [0] : v => v if length(local.ip_pools) > 0 }
}

data "intersight_iqnpool_pool" "iqn" {
  for_each = { for v in [0] : v => v if length(local.iqn_pools) > 0 }
}

data "intersight_macpool_pool" "mac" {
  for_each = { for v in [0] : v => v if length(local.mac_pools) > 0 }
}

data "intersight_fcpool_pool" "wwnn" {
  for_each     = { for v in [0] : v => v if length(local.wwnn_pools) > 0 }
  pool_purpose = "WWNN"
}

data "intersight_fcpool_pool" "wwpn" {
  for_each     = { for v in [0] : v => v if length(local.wwpn_pools) > 0 }
  pool_purpose = "WWPN"
}

#__________________________________________________________________
#
# Policies Data Objects
#__________________________________________________________________

#________________________________________
#
# Ethernet Data Objects
#________________________________________

data "intersight_vnic_eth_adapter_policy" "ethernet_adapter" {
  depends_on = [
    intersight_vnic_eth_adapter_policy.ethernet_adapter
  ]
  for_each = { for v in [0] : v => v if length(local.lcp_eth_adtr) > 0 }
}

data "intersight_fabric_eth_network_control_policy" "ethernet_network_control" {
  depends_on = [
    intersight_fabric_eth_network_control_policy.ethernet_network_control
  ]
  for_each = { for v in [0] : v => v if length(local.eth_ntwk_ctrl) > 0 }
}

data "intersight_fabric_eth_network_group_policy" "ethernet_network_group" {
  depends_on = [
    intersight_fabric_eth_network_group_policy.ethernet_network_group
  ]
  for_each = { for v in [0] : v => v if length(local.eth_ntwk_grp) > 0 }
}

data "intersight_vnic_eth_network_policy" "ethernet_network" {
  depends_on = [
    intersight_vnic_eth_network_policy.ethernet_network
  ]
  for_each = { for v in [0] : v => v if length(local.lcp_eth_ntwk) > 0 }
}

data "intersight_vnic_eth_qos_policy" "ethernet_qos" {
  depends_on = [
    intersight_vnic_eth_qos_policy.ethernet_qos
  ]
  for_each = { for v in [0] : v => v if length(local.lcp_eth_qos) > 0 }
}

#________________________________________
#
# Fibre-Channel Data Objects
#________________________________________

data "intersight_vnic_fc_adapter_policy" "fibre_channel_adapter" {
  depends_on = [
    intersight_vnic_fc_adapter_policy.fibre_channel_adapter
  ]
  for_each = { for v in [0] : v => v if length(local.scp_fc_adtr) > 0 }
}

data "intersight_vnic_fc_network_policy" "fibre_channel_network" {
  depends_on = [
    intersight_vnic_fc_network_policy.fibre_channel_network
  ]
  for_each = { for v in [0] : v => v if length(local.scp_fc_ntwk) > 0 }
}

data "intersight_vnic_fc_qos_policy" "fibre_channel_qos" {
  depends_on = [
    intersight_vnic_fc_qos_policy.fibre_channel_qos
  ]
  for_each = { for v in [0] : v => v if length(local.scp_fc_qos) > 0 }
}

data "intersight_fabric_fc_zone_policy" "fc_zone" {
  depends_on = [
    intersight_fabric_fc_zone_policy.fc_zone
  ]
  for_each = { for v in [0] : v => v if length(local.scp_fc_zone) > 0 }
}

#________________________________________
#
# iSCSI Policy Data Objects
#________________________________________

data "intersight_vnic_iscsi_adapter_policy" "iscsi_adapter" {
  depends_on = [
    intersight_vnic_iscsi_adapter_policy.iscsi_adapter
  ]
  for_each = { for v in [0] : v => v if length(local.iadapter) > 0 }
}

data "intersight_vnic_iscsi_boot_policy" "iscsi_boot" {
  depends_on = [
    intersight_vnic_iscsi_boot_policy.iscsi_boot
  ]
  for_each = { for v in [0] : v => v if length(local.lcp_iboot) > 0 }
}

data "intersight_vnic_iscsi_static_target_policy" "iscsi_static_target" {
  depends_on = [
    intersight_vnic_iscsi_static_target_policy.iscsi_static_target
  ]
  for_each = { for v in [0] : v => v if length(local.itarget) > 0 }
}

#________________________________________
#
# Port Policy Data Objects
#________________________________________

data "intersight_fabric_flow_control_policy" "flow_control" {
  depends_on = [
    intersight_fabric_flow_control_policy.flow_control
  ]
  for_each = { for v in [0] : v => v if length(local.flow_ctrl) > 0 }
}

data "intersight_fabric_link_aggregation_policy" "link_aggregation" {
  depends_on = [
    intersight_fabric_link_aggregation_policy.link_aggregation
  ]
  for_each = { for v in [0] : v => v if length(local.link_agg) > 0 }
}

data "intersight_fabric_link_control_policy" "link_control" {
  depends_on = [
    intersight_fabric_link_control_policy.link_control
  ]
  for_each = { for v in [0] : v => v if length(local.link_ctrl) > 0 }
}

#________________________________________
#
# Multicast Policy Data Objects
#________________________________________

data "intersight_fabric_multicast_policy" "multicast" {
  depends_on = [
    intersight_fabric_multicast_policy.multicast
  ]
  for_each = { for v in [0] : v => v if length(local.mcast) > 0 }
}
