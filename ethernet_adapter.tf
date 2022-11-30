#__________________________________________________________________
#
# Intersight Ethernet Adapter Policy
# GUI Location: Policies > Create Policy > Ethernet Adapter
#__________________________________________________________________

resource "intersight_vnic_eth_adapter_policy" "ethernet_adapter" {
  for_each = local.ethernet_adapter
  advanced_filter = length(
    compact([each.value.adapter_template])) > 0 ? false : length(
    compact([each.value.enable_advanced_filter])
  ) > 0 ? each.value.enable_advanced_filter : false
  description = length(
    regexall("(Linux-NVMe-RoCE)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for NVMe using RDMA." : length(
    regexall("(Linux)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for linux." : length(
    regexall("(MQ-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for MultiQueue with RDMA." : length(
    regexall("(MQ)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for VM Multi Queue Connection with no RDMA." : length(
    regexall("(SMBClient)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for SMB Client." : length(
    regexall("(SMBServer)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for SMB server." : length(
    regexall("(Solaris)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Solaris." : length(
    regexall("(SRIOV)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Win8 SRIOV-VMFEX PF." : length(
    regexall("(usNICOracleRAC)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for usNIC Oracle RAC Connection." : length(
    regexall("(usNIC)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for usNIC Connection." : length(
    regexall("(VMwarePassThru)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for VMware pass-thru." : length(
    regexall("(VMware)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for VMware." : length(
    regexall("(Win-AzureStack)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Azure Stack." : length(
    regexall("(Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Windows high performance and networking with RoCE V2." : length(
    regexall("(Win-HPN)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Windows high performance and networking." : length(
    regexall("(Windows)", coalesce(each.value.adapter_template, "EMPTY"))
  ) > 0 ? "Recommended adapter settings for Windows." : each.value.description != null ? each.value.description : ""
  geneve_enabled = length(
    compact([each.value.adapter_template])) > 0 ? false : length(
    compact([each.value.enable_geneve_offload])
  ) > 0 ? each.value.enable_geneve_offload : false
  interrupt_scaling = length(
    compact([each.value.adapter_template])) > 0 ? false : length(
    compact([each.value.enable_interrupt_scaling])
  ) > 0 ? each.value.enable_interrupt_scaling : false
  name = each.value.name
  rss_settings = length(
    regexall("(Linux|Solaris|VMware)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? false : length(compact([each.value.adapter_template])
  ) > 0 ? true : each.value.receive_side_scaling_enable != null ? each.value.receive_side_scaling_enable : true
  uplink_failback_timeout = length(
    regexall("(usNIC|usNICOracleRAC)", coalesce(each.value.adapter_template, "EMPTY"))
  ) > 0 ? 0 : each.value.uplink_failback_timeout != null ? each.value.uplink_failback_timeout : 5
  arfs_settings {
    enabled = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.enable_accelerated_receive_flow_steering])
    ) > 0 ? each.value.enable_accelerated_receive_flow_steering : false
  }
  completion_queue_settings {
    nr_count = length(
      regexall("(Linux-NVMe-RoCE|Linux|Solaris|VMware)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 2 : length(
      regexall("(usNIC)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 6 : length(
      regexall("(VMwarePassThru)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 8 : length(
      regexall("(Win-AzureStack)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 11 : length(
      regexall("(usNIC)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 12 : length(
      regexall("(MQ-SMBd|MQ)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 576 : length(
      regexall("(usNICOracleRAC)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 2000 : each.value.completion_queue_count != null ? each.value.completion_queue_count : 5
    ring_size = length(
      regexall("(MQ|usNIC|usNICOracleRAC)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 4 : each.value.completion_ring_size != null ? each.value.completion_ring_size : 1
  }
  interrupt_settings {
    coalescing_time = each.value.adapter_template != null ? 125 : each.value.interrupt_timer != null ? each.value.interrupt_timer : 125
    coalescing_type = length(
      compact([each.value.adapter_template])) > 0 ? "MIN" : length(
      compact([each.value.interrupt_coalescing_type])
    ) > 0 ? each.value.interrupt_coalescing_type : "MIN"
    nr_count = length(
      regexall("(Linux|Solaris|VMware)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 4 : length(
      regexall("(VMwarePassThru)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 12 : length(
      regexall("(SRIOV)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 32 : length(
      regexall("(MQ-SMBd|Win-HPN|Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 512 : length(
      regexall("(Linux-NVMe-RoCE|MQ|Win-AzureStack)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 256 : length(
      regexall("(usNICOracleRAC)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 1024 : each.value.adapter_template != null ? 8 : each.value.interrupts != null ? each.value.interrupts : 8
    mode = length(
      regexall("(VMwarePassThru)", coalesce(each.value.adapter_template, "EMPTY"))
      ) > 0 ? "MSI" : length(compact([each.value.adapter_template])
      ) > 0 ? "MSIx" : length(compact([each.value.interrupt_mode])
    ) > 0 ? each.value.interrupt_mode : "MSIx"
  }
  nvgre_settings {
    enabled = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.enable_nvgre_offload])
    ) > 0 ? each.value.enable_nvgre_offload : false
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  roce_settings {
    class_of_service = each.value.adapter_template != null ? 5 : each.value.roce_cos != null ? each.value.roce_cos : 5
    enabled = length(
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|SMBClient|SMBServer|Win-AzureStack|Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? true : each.value.roce_enable != null ? each.value.roce_enable : false
    memory_regions = length(
      regexall("(MQ-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 65536 : length(
      regexall("(Linux-NVMe-RoCE|SMBClient|SMBServer|Win-AzureStack|Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 131072 : each.value.roce_memory_regions != null ? each.value.roce_memory_regions : each.value.roce_enable == true ? 131072 : 0
    queue_pairs = length(
      regexall("(MQ-SMBd|SMBClient|Win-AzureStack|Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 256 : length(
      regexall("(Linux-NVMe-RoCE)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 1024 : length(
      regexall("(SMBServer)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 2048 : each.value.roce_queue_pairs != null ? each.value.roce_queue_pairs : each.value.roce_enable == true ? 256 : 0
    resource_groups = length(
      regexall("(MQ-SMBd|Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 2 : length(
      regexall("(Linux-NVMe-RoCE)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 8 : length(
      regexall("(SMBClient|SMBServer)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 32 : each.value.roce_resource_groups != null ? each.value.roce_resource_groups : each.value.roce_enable == true ? 4 : 0
    nr_version = length(
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|Win-AzureStack|Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 2 : each.value.roce_version != null ? each.value.roce_version : 1
  }
  rss_hash_settings {
    ipv4_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.rss_enable_ipv4_hash])) > 0 ? each.value.rss_enable_ipv4_hash : length(
      regexall(true, coalesce(each.value.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    ipv6_ext_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
    compact([each.value.rss_enable_ipv6_extensions_hash])) > 0 ? each.value.rss_enable_ipv6_extensions_hash : false
    ipv6_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.rss_enable_ipv6_hash])
      ) > 0 ? each.value.rss_enable_ipv6_hash : length(
      regexall(true, coalesce(each.value.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    tcp_ipv4_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.rss_enable_tcp_and_ipv4_hash])) > 0 ? each.value.rss_enable_tcp_and_ipv4_hash : length(
      regexall(true, coalesce(each.value.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    tcp_ipv6_ext_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
    compact([each.value.rss_enable_tcp_and_ipv6_extensions_hash])) > 0 ? each.value.rss_enable_tcp_and_ipv6_extensions_hash : false
    tcp_ipv6_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.rss_enable_tcp_and_ipv6_hash])) > 0 ? each.value.rss_enable_tcp_and_ipv6_hash : length(
      regexall(true, coalesce(each.value.receive_side_scaling_enable, false))
    ) > 0 ? true : false
    udp_ipv4_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.rss_enable_udp_and_ipv4_hash])
    ) > 0 ? each.value.rss_enable_udp_and_ipv4_hash : false
    udp_ipv6_hash = length(
      compact([each.value.adapter_template])) > 0 ? false : length(
      compact([each.value.rss_enable_udp_and_ipv6_hash])
    ) > 0 ? each.value.rss_enable_udp_and_ipv6_hash : false
  }
  rx_queue_settings {
    nr_count = length(
      regexall("(Linux|Linux-NVMe-RoCE|Solaris|VMware)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 1 : length(
      regexall("(usNIC)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 6 : length(
      regexall("(Win-AzureStack)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 8 : length(
      regexall("(MQ-SMBd|MQ)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 512 : length(
      regexall("(usNICOracleRAC)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 1000 : each.value.receive_queue_count != null ? each.value.receive_queue_count : 4
    ring_size = length(
      regexall("(Win-AzureStack)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 4096 : each.value.receive_ring_size != null ? each.value.receive_ring_size : 512
  }
  tcp_offload_settings {
    large_receive = length(
      compact([each.value.adapter_template])) > 0 ? true : length(
      compact([each.value.tcp_offload_large_recieve])
    ) > 0 ? each.value.tcp_offload_large_recieve : true
    large_send = length(
      compact([each.value.adapter_template])) > 0 ? true : length(
      compact([each.value.tcp_offload_large_send])
    ) > 0 ? each.value.tcp_offload_large_send : true
    rx_checksum = length(
      compact([each.value.adapter_template])) > 0 ? true : length(
      compact([each.value.tcp_offload_rx_checksum])
    ) > 0 ? each.value.tcp_offload_rx_checksum : true
    tx_checksum = length(
      compact([each.value.adapter_template])) > 0 ? true : length(
      compact([each.value.tcp_offload_tx_checksum])
    ) > 0 ? each.value.tcp_offload_tx_checksum : true
  }
  tx_queue_settings {
    nr_count = length(
      regexall("(Win-AzureStack)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 3 : length(
      regexall("(VMwarePassThru)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 4 : length(
      regexall("(usNIC)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 6 : length(
      regexall("(MQ-SMBd|MQ)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? 64 : length(
      regexall("(usNICOracleRAC)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 1000 : each.value.transmit_queue_count != null ? each.value.transmit_queue_count : 1
    ring_size = length(
      regexall("(Win-AzureStack)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 1024 : each.value.transmit_ring_size != null ? each.value.transmit_ring_size : 256
  }
  vxlan_settings {
    enabled = length(
      regexall("(Win-AzureStack|Win-HPN|Win-HPN-SMBd)", coalesce(each.value.adapter_template, "EMPTY"))
      ) > 0 ? true : length(compact([each.value.adapter_template])
    ) > 0 ? false : each.value.enable_vxlan_offload != null ? each.value.enable_vxlan_offload : false
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
