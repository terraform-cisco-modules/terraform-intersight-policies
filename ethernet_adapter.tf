#__________________________________________________________________
#
# Intersight Ethernet Adapter Policy
# GUI Location: Policies > Create Policy > Ethernet Adapter
#__________________________________________________________________

resource "intersight_vnic_eth_adapter_policy" "ethernet_adapter" {
  for_each = local.ethernet_adapter
  advanced_filter = length(regexall("EMPTY", each.value.adapter_template)
  ) == 0 ? false : each.value.enable_geneve_offload == true ? false : each.value.enable_advanced_filter
  description = length(
    regexall("(Linux-NVMe-RoCE)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for NVMe using RDMA." : length(
    regexall("(Linux)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for linux." : length(
    regexall("(MQ-SMBd)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for MultiQueue with RDMA." : length(
    regexall("(MQ)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for VM Multi Queue Connection with no RDMA." : length(
    regexall("(SMBClient)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for SMB Client." : length(
    regexall("(SMBServer)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for SMB server." : length(
    regexall("(Solaris)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for Solaris." : length(
    regexall("(SRIOV)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for Win8 SRIOV-VMFEX PF." : length(
    regexall("(usNICOracleRAC)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for usNIC Oracle RAC Connection." : length(
    regexall("(usNIC)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for usNIC Connection." : length(
    regexall("(VMwarePassThru)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for VMware pass-thru." : length(
    regexall("(VMware)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for VMware." : length(
    regexall("(Win-AzureStack)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for Azure Stack." : length(
    regexall("(Win-HPN-SMBd)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for Windows high performance and networking with RoCE V2." : length(
    regexall("(Win-HPN)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for Windows high performance and networking." : length(
    regexall("(Windows)", each.value.adapter_template)
  ) > 0 ? "Recommended adapter settings for Windows." : each.value.description != null ? each.value.description : ""
  geneve_enabled = length(regexall("EMPTY", each.value.adapter_template)) == 0 ? false : length(
    compact([each.value.enable_geneve_offload])
  ) > 0 ? each.value.enable_geneve_offload : false
  interrupt_scaling = length(regexall("EMPTY", each.value.adapter_template)) == 0 ? false : length(
    compact([each.value.enable_interrupt_scaling])
  ) > 0 ? each.value.enable_interrupt_scaling : false
  name = each.value.name
  rss_settings = length(regexall("(Linux|Solaris|VMware)", each.value.adapter_template)
  ) > 0 ? false : each.value.receive_side_scaling_enable
  uplink_failback_timeout = length(regexall("(usNIC|usNICOracleRAC)", each.value.adapter_template)
  ) > 0 ? 0 : each.value.uplink_failback_timeout
  arfs_settings {
    enabled = length(regexall("EMPTY", each.value.adapter_template)) == 0 ? false : each.value.enable_accelerated_receive_flow_steering
  }
  completion_queue_settings {
    nr_count = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 16 : length(
      regexall("(Linux-NVMe-RoCE|Linux|Solaris|VMware)", each.value.adapter_template)) > 0 ? 2 : length(
      regexall("(usNIC)", each.value.adapter_template)) > 0 ? 6 : length(
      regexall("(VMwarePassThru)", each.value.adapter_template)) > 0 ? 8 : length(
      regexall("(Win-AzureStack)", each.value.adapter_template)) > 0 ? 11 : length(
      regexall("(usNIC)", each.value.adapter_template)) > 0 ? 12 : length(
      regexall("(MQ-SMBd|MQ)", each.value.adapter_template)) > 0 ? 576 : length(
      regexall("(usNICOracleRAC)", each.value.adapter_template)
    ) > 0 ? 2000 : each.value.completion.queue_count
    ring_size = length(regexall("(MQ|usNIC|usNICOracleRAC)", each.value.adapter_template)
    ) > 0 ? 4 : each.value.completion.ring_size
  }
  interrupt_settings {
    coalescing_time = each.value.interrupt_settings.timer
    coalescing_type = each.value.interrupt_settings.coalescing_type
    nr_count = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 32 : length(
      regexall("(Linux|Solaris|VMware)", each.value.adapter_template)) > 0 ? 4 : length(
      regexall("(VMwarePassThru)", each.value.adapter_template)) > 0 ? 12 : length(
      regexall("(SRIOV)", each.value.adapter_template)) > 0 ? 32 : length(
      regexall("(MQ-SMBd|Win-HPN|Win-HPN-SMBd)", each.value.adapter_template)) > 0 ? 512 : length(
      regexall("(Linux-NVMe-RoCE|MQ|Win-AzureStack)", each.value.adapter_template)) > 0 ? 256 : length(
      regexall("(usNICOracleRAC)", each.value.adapter_template)
    ) > 0 ? 1024 : each.value.interrupt_settings.interrupts
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
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|SMBClient|SMBServer|Win-AzureStack|Win-HPN-SMBd)", each.value.adapter_template)
    ) > 0 ? true : each.value.roce_settings.enable_rdma_over_converged_ethernet
    memory_regions = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 0 : length(
      regexall("(MQ-SMBd)", each.value.adapter_template)) > 0 ? 65536 : length(
      regexall("(Linux-NVMe-RoCE|SMBClient|SMBServer|Win-AzureStack|Win-HPN-SMBd)", each.value.adapter_template)
      ) > 0 ? 131072 : each.value.roce_settings.memory_regions != 0 ? each.value.roce_settings.memory_regions : length(regexall(
      true, each.value.roce_settings.enable_rdma_over_converged_ethernet)
    ) > 0 ? 131072 : 0
    queue_pairs = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 0 : length(
      regexall("(MQ-SMBd|SMBClient|Win-AzureStack|Win-HPN-SMBd)", each.value.adapter_template)) > 0 ? 256 : length(
      regexall("(Linux-NVMe-RoCE)", each.value.adapter_template)) > 0 ? 1024 : length(
      regexall("(SMBServer)", each.value.adapter_template)
      ) > 0 ? 2048 : each.value.roce_settings.queue_pairs != 0 ? each.value.roce_settings.queue_pairs : length(regexall(
      true, each.value.roce_settings.enable_rdma_over_converged_ethernet)
    ) > 0 ? 256 : 0
    resource_groups = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 0 : length(
      regexall("(MQ-SMBd|Win-HPN-SMBd)", each.value.adapter_template)) > 0 ? 2 : length(
      regexall("(Linux-NVMe-RoCE)", each.value.adapter_template)) > 0 ? 8 : length(
      regexall("(SMBClient|SMBServer)", each.value.adapter_template)
      ) > 0 ? 32 : each.value.roce_settings.resource_groups != 0 ? each.value.roce_settings.resource_groups : length(regexall(
      true, each.value.roce_settings.enable_rdma_over_converged_ethernet)
    ) > 0 ? 2 : 0
    nr_version = length(regexall(true, each.value.enable_geneve_offload)) > 0 ? 1 : length(
      regexall("(Linux-NVMe-RoCE|MQ-SMBd|Win-AzureStack|Win-HPN-SMBd)", each.value.adapter_template)
    ) > 0 ? 2 : each.value.roce_settings.version
  }
  rss_hash_settings {
    ipv4_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_ipv4_hash
    ipv6_ext_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_ipv6_extensions_hash
    ipv6_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_ipv6_hash
    tcp_ipv4_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_tcp_and_ipv4_hash
    tcp_ipv6_ext_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_tcp_and_ipv6_extensions_hash
    tcp_ipv6_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_tcp_and_ipv6_hash
    udp_ipv4_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_udp_and_ipv4_hash
    udp_ipv6_hash = length(regexall(false, each.value.rss)
    ) > 0 ? false : each.value.receive_side_scaling.enable_udp_and_ipv6_hash
  }
  rx_queue_settings {
    nr_count = length(
      regexall("(Linux|Linux-NVMe-RoCE|Solaris|VMware)", each.value.adapter_template)) > 0 ? 1 : length(
      regexall("(usNIC)", each.value.adapter_template)) > 0 ? 6 : length(
      regexall("(Win-AzureStack)", each.value.adapter_template)) > 0 ? 8 : length(
      regexall("(MQ-SMBd|MQ)", each.value.adapter_template)) > 0 ? 512 : length(
      regexall("(usNICOracleRAC)", each.value.adapter_template)
    ) > 0 ? 1000 : each.value.receive.queue_count
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
      regexall("(Win-AzureStack)", each.value.adapter_template)) > 0 ? 3 : length(
      regexall("(VMwarePassThru)", each.value.adapter_template)) > 0 ? 4 : length(
      regexall("(usNIC)", each.value.adapter_template)) > 0 ? 6 : length(
      regexall("(MQ-SMBd|MQ)", each.value.adapter_template)) > 0 ? 64 : length(
      regexall("(usNICOracleRAC)", each.value.adapter_template)
    ) > 0 ? 1000 : each.value.transmit.queue_count
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
