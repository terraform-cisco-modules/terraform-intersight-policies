#__________________________________________________________________
#
# Intersight Ethernet Adapter Policy
# GUI Location: Policies > Create Policy > Ethernet Adapter
#__________________________________________________________________

resource "intersight_vnic_eth_adapter_policy" "map" {
  for_each = local.ethernet_adapter
  advanced_filter = length(regexall("EMPTY", each.value.adapter_template)
  ) == 0 ? false : each.value.enable_geneve_offload == true ? false : each.value.enable_advanced_filter
  description = length(regexall("EMPTY", each.value.adapter_template)
    ) == 0 ? local.eth_settings[each.value.adapter_template
  ].description : coalesce(each.value.description, "${each.value.name} Fibre-Channel Adapter Policy.")
  geneve_enabled = length(regexall("EMPTY", each.value.adapter_template)) == 0 ? false : length(
    compact([each.value.enable_geneve_offload])
  ) > 0 ? each.value.enable_geneve_offload : false
  interrupt_scaling = length(regexall("EMPTY", each.value.adapter_template)
  ) == 0 ? false : length(compact([each.value.enable_interrupt_scaling])) > 0 ? each.value.enable_interrupt_scaling : false
  name = each.value.name
  rss_settings = length(regexall("(Linux|Solaris|VMware)", each.value.adapter_template)
  ) > 0 ? false : each.value.receive_side_scaling_enable
  uplink_failback_timeout = length(regexall("(usNIC|usNICOracleRAC)", each.value.adapter_template)
  ) > 0 ? 0 : each.value.uplink_failback_timeout
  arfs_settings {
    enabled = length(regexall("EMPTY", each.value.adapter_template)
    ) == 0 ? false : each.value.enable_accelerated_receive_flow_steering
  }
  completion_queue_settings {
    nr_count = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 16 : length(
      regexall("EMPTY", each.value.adapter_template)
    ) == 0 ? lookup(local.eth_settings[each.value.adapter_template], "comp_count", 5) : each.value.completion.queue_count
    ring_size = length(regexall("(MQ|usNIC|usNICOracleRAC)", each.value.adapter_template)
    ) > 0 ? 4 : each.value.completion.ring_size
  }
  interrupt_settings {
    coalescing_time = each.value.interrupt_settings.timer
    coalescing_type = each.value.interrupt_settings.coalescing_type
    nr_count = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 32 : length(
      regexall("EMPTY", each.value.adapter_template)
      ) == 0 ? lookup(local.eth_settings[each.value.adapter_template], "int_count", 8
    ) : each.value.interrupt_settings.interrupts
    mode = length(regexall("(VMwarePassThru)", each.value.adapter_template)
    ) > 0 ? "MSI" : length(regexall("EMPTY", each.value.adapter_template)) == 0 ? "MSIx" : each.value.interrupt_settings.mode
  }
  nvgre_settings {
    enabled = length(regexall("EMPTY", each.value.adapter_template)) == 0 ? false : each.value.enable_nvgre_offload
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  roce_settings {
    class_of_service = each.value.roce_settings.cos
    enabled = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? false : length(
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|SMB(Client|Server)|Win-(AzureStack|HPN-SMBd))", each.value.adapter_template)
    ) > 0 ? true : each.value.roce_settings.enable_rdma_over_converged_ethernet
    memory_regions = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 0 : length(
      regexall("(MQ-SMBd)", each.value.adapter_template)) > 0 ? 65536 : length(
      regexall("(Linux-NVMe-RoCE|SMB(Client|Server)|Win-(AzureStack|HPN-SMBd))", each.value.adapter_template)
      ) > 0 ? 131072 : each.value.roce_settings.memory_regions != 0 ? each.value.roce_settings.memory_regions : length(regexall(
      true, each.value.roce_settings.enable_rdma_over_converged_ethernet)
    ) > 0 ? 131072 : 0
    queue_pairs = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 0 : length(
      regexall("(MQ-SMBd|SMBClient|Win-(AzureStack|HPN-SMBd))", each.value.adapter_template)) > 0 ? 256 : length(
      regexall("(Linux-NVMe-RoCE)", each.value.adapter_template)) > 0 ? 1024 : length(
      regexall("(SMBServer)", each.value.adapter_template)
      ) > 0 ? 2048 : each.value.roce_settings.queue_pairs != 0 ? each.value.roce_settings.queue_pairs : length(regexall(
      true, each.value.roce_settings.enable_rdma_over_converged_ethernet)
    ) > 0 ? 256 : 0
    resource_groups = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 0 : length(
      regexall("(MQ-SMBd|Win-HPN-SMBd)", each.value.adapter_template)) > 0 ? 2 : length(
      regexall("(Linux-NVMe-RoCE)", each.value.adapter_template)) > 0 ? 8 : length(
      regexall("SMB(Client|Server)", each.value.adapter_template)
      ) > 0 ? 32 : each.value.roce_settings.resource_groups != 0 ? each.value.roce_settings.resource_groups : length(regexall(
      true, each.value.roce_settings.enable_rdma_over_converged_ethernet)
    ) > 0 ? 2 : 0
    nr_version = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 1 : length(
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|Win-AzureStack|Win-HPN-SMBd)", each.value.adapter_template)
    ) > 0 ? 2 : each.value.roce_settings.version
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
    nr_count = length(regexall("EMPTY", each.value.adapter_template)
    ) == 0 ? lookup(local.eth_settings[each.value.adapter_template], "rx_queue_count", 4) : each.value.receive.queue_count
    ring_size = length(regexall("(Win-AzureStack)", each.value.adapter_template)
    ) > 0 ? 4096 : each.value.receive.ring_size
  }
  tcp_offload_settings {
    large_receive = each.value.tcp_offload.enable_large_recieve_offload
    large_send    = each.value.tcp_offload.enable_large_send_offload
    rx_checksum   = each.value.tcp_offload.enable_rx_checksum_offload
    tx_checksum   = each.value.tcp_offload.enable_tx_checksum_offload
  }
  tx_queue_settings {
    nr_count = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 1 : length(
      regexall("EMPTY", each.value.adapter_template)
    ) == 0 ? lookup(local.eth_settings[each.value.adapter_template], "rx_queue_count", 4) : each.value.transmit.queue_count
    ring_size = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 4096 : length(
      regexall("(Win-AzureStack)", each.value.adapter_template)
    ) > 0 ? 1024 : each.value.transmit.ring_size
  }
  vxlan_settings {
    enabled = length(regexall("(Win-AzureStack|Win-HPN|Win-HPN-SMBd)", each.value.adapter_template)
    ) > 0 ? true : length(regexall("EMPTY", each.value.adapter_template)) == 0 ? false : each.value.enable_vxlan_offload
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
