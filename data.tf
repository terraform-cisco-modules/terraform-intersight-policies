#__________________________________________________________________
#
# Pool Data Objects
#__________________________________________________________________

data "intersight_search_search_item" "ip" {
  for_each              = { for v in [0] : v => v if length(local.ip_pools) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "ippool.Pool" })
}

data "intersight_search_search_item" "iqn" {
  for_each              = { for v in [0] : v => v if length(local.iqn_pools) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "iqnpool.Pool" })
}

data "intersight_search_search_item" "mac" {
  for_each              = { for v in [0] : v => v if length(local.mac_pools) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "macpool.Pool" })
}

data "intersight_search_search_item" "wwnn" {
  for_each              = { for v in [0] : v => v if length(local.wwnn_pools) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fcpool.Pool" })
}

data "intersight_search_search_item" "wwpn" {
  for_each              = { for v in [0] : v => v if length(local.wwpn_pools) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fcpool.Pool" })
}

#__________________________________________________________________
#
# Policies Data Objects
#__________________________________________________________________

#________________________________________
#
# Ethernet Data Objects
#________________________________________

data "intersight_search_search_item" "ethernet_adapter" {
  for_each              = { for v in [0] : v => v if length(local.lcp_eth_adtr) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.EthAdapterPolicy" })
}

data "intersight_search_search_item" "ethernet_network_control" {
  for_each              = { for v in [0] : v => v if length(local.eth_ntwk_ctrl) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fabric.EthNetworkControlPolicy" })
}

data "intersight_search_search_item" "ethernet_network_group" {
  for_each              = { for v in [0] : v => v if length(local.eth_ntwk_grp) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fabric.EthNetworkGroupPolicy" })
}

data "intersight_search_search_item" "ethernet_network" {
  for_each              = { for v in [0] : v => v if length(local.lcp_eth_ntwk) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.EthNetworkPolicy" })
}

data "intersight_search_search_item" "ethernet_qos" {
  for_each              = { for v in [0] : v => v if length(local.lcp_eth_qos) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.EthQosPolicy" })
}

#________________________________________
#
# Fibre-Channel Data Objects
#________________________________________

data "intersight_search_search_item" "fibre_channel_adapter" {
  for_each              = { for v in [0] : v => v if length(local.scp_fc_adtr) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.FcAdapterPolicy" })
}

data "intersight_search_search_item" "fibre_channel_network" {
  for_each              = { for v in [0] : v => v if length(local.scp_fc_ntwk) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.FcNetworkPolicy" })
}

data "intersight_search_search_item" "fibre_channel_qos" {
  for_each              = { for v in [0] : v => v if length(local.scp_fc_qos) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.FcQosPolicy" })
}

data "intersight_search_search_item" "fc_zone" {
  for_each              = { for v in [0] : v => v if length(local.scp_fc_zone) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fabric.FcZonePolicy" })
}

#________________________________________
#
# iSCSI Policy Data Objects
#________________________________________

data "intersight_search_search_item" "iscsi_adapter" {
  for_each              = { for v in [0] : v => v if length(local.iadapter) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.IscsiAdapterPolicy" })
}

data "intersight_search_search_item" "iscsi_boot" {
  for_each              = { for v in [0] : v => v if length(local.lcp_iboot) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.IscsiBootPolicy" })
}

data "intersight_search_search_item" "iscsi_static_target" {
  for_each              = { for v in [0] : v => v if length(local.itarget) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "vnic.IscsiStaticTargetPolicy" })
}

#________________________________________
#
# Port Policy Data Objects
#________________________________________

data "intersight_search_search_item" "flow_control" {
  for_each              = { for v in [0] : v => v if length(local.flow_ctrl) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fabric.FlowControlPolicy" })
}

data "intersight_search_search_item" "link_aggregation" {
  for_each              = { for v in [0] : v => v if length(local.link_agg) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fabric.LinkAggregationPolicy" })
}

data "intersight_search_search_item" "link_control" {
  for_each              = { for v in [0] : v => v if length(local.link_ctrl) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fabric.LinkControlPolicy" })
}

#________________________________________
#
# Multicast Policy Data Objects
#________________________________________

data "intersight_search_search_item" "multicast" {
  for_each              = { for v in [0] : v => v if length(local.mcast) > 0 }
  additional_properties = jsonencode({ "ObjectType" = "fabric.MulticastPolicy" })
}
