#__________________________________________________________________
#
# Intersight Ethernet Adapter Policy
# GUI Location: Policies > Create Policy > Ethernet Adapter
#__________________________________________________________________

resource "intersight_vnic_eth_adapter_policy" "map" {
  for_each                = { for k, v in local.ethernet_adapter : k => merge(v, { rss = v.receive_side_scaling.enable_receive_side_scaling }) }
  advanced_filter         = each.value.enable_geneve_offload == true ? false : each.value.enable_advanced_filter
  description             = coalesce(each.value.description, "${each.value.name} Fibre-Channel Adapter Policy.")
  geneve_enabled          = each.value.enable_geneve_offload
  interrupt_scaling       = each.value.enable_interrupt_scaling
  name                    = each.value.name
  rss_settings            = each.value.receive_side_scaling.enable_receive_side_scaling
  uplink_failback_timeout = each.value.uplink_failback_timeout
  arfs_settings { enabled = each.value.enable_accelerated_receive_flow_steering }
  completion_queue_settings {
    nr_count  = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 16 : each.value.completion.queue_count
    ring_size = each.value.completion.ring_size
  }
  interrupt_settings {
    coalescing_time = each.value.interrupt_settings.timer
    coalescing_type = each.value.interrupt_settings.coalescing_type
    nr_count        = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 32 : each.value.interrupt_settings.interrupts
    mode            = each.value.interrupt_settings.mode
  }
  nvgre_settings { enabled = each.value.enable_nvgre_offload }
  organization { moid = var.orgs[each.value.organization] }
  ptp_settings { enabled = each.value.enable_precision_time_protocol }
  roce_settings {
    class_of_service = each.value.roce_settings.class_of_service
    enabled          = each.value.roce_settings.enable_rdma_over_converged_ethernet
    memory_regions   = each.value.roce_settings.memory_regions
    queue_pairs      = each.value.roce_settings.queue_pairs
    resource_groups  = each.value.roce_settings.resource_groups
    nr_version       = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 1 : each.value.roce_settings.version
  }
  rss_hash_settings {
    ipv4_hash         = each.value.rss == false ? false : each.value.receive_side_scaling.enable_ipv4_hash
    ipv6_ext_hash     = each.value.rss == false ? false : each.value.receive_side_scaling.enable_ipv6_extensions_hash
    ipv6_hash         = each.value.rss == false ? false : each.value.receive_side_scaling.enable_ipv6_hash
    tcp_ipv4_hash     = each.value.rss == false ? false : each.value.receive_side_scaling.enable_tcp_and_ipv4_hash
    tcp_ipv6_ext_hash = each.value.rss == false ? false : each.value.receive_side_scaling.enable_tcp_and_ipv6_extensions_hash
    tcp_ipv6_hash     = each.value.rss == false ? false : each.value.receive_side_scaling.enable_tcp_and_ipv6_hash
    udp_ipv4_hash     = each.value.rss == false ? false : each.value.receive_side_scaling.enable_udp_and_ipv4_hash
    udp_ipv6_hash     = each.value.rss == false ? false : each.value.receive_side_scaling.enable_udp_and_ipv6_hash
  }
  rx_queue_settings {
    nr_count  = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 8 : each.value.receive.queue_count
    ring_size = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 4096 : each.value.receive.ring_size
  }
  tcp_offload_settings {
    large_receive = each.value.tcp_offload.enable_large_receive_offload
    large_send    = each.value.tcp_offload.enable_large_send_offload
    rx_checksum   = each.value.tcp_offload.enable_rx_checksum_offload
    tx_checksum   = each.value.tcp_offload.enable_tx_checksum_offload
  }
  tx_queue_settings {
    nr_count  = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 1 : each.value.transmit.queue_count
    ring_size = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 4096 : each.value.transmit.ring_size
  }
  vxlan_settings { enabled = each.value.enable_vxlan_offload }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
