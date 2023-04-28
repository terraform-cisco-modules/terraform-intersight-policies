#__________________________________________________________________
#
# Intersight Fibre Channel Adapter Policy
# GUI Location: Policies > Create Policy > Fibre Channel Adapter
#__________________________________________________________________

resource "intersight_vnic_fc_adapter_policy" "fibre_channel_adapter" {
  for_each = local.fibre_channel_adapter
  description = length(
    regexall("(FCNVMeInitiator)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for FCNVMeInitiator." : length(
    regexall("(FCNVMeTarget)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for FCNVMeTarget." : length(
    regexall("(Initiator)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Initiator." : length(
    regexall("(Linux)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for linux." : length(
    regexall("(Solaris)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for Solaris." : length(
    regexall("(VMware)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for VMware." : length(
    regexall("(WindowsBoot)", coalesce(each.value.adapter_template, "EMPTY"))) > 0 ? "Recommended adapter settings for WindowsBoot." : length(
    regexall("(Windows)", coalesce(each.value.adapter_template, "EMPTY"))
  ) > 0 ? "Recommended adapter settings for Windows." : each.value.description != "" ? each.value.description : "${each.value.name} Fibre-Channel Adapter Policy."
  error_detection_timeout     = each.value.error_detection_timeout
  io_throttle_count           = length(
      regexall("(FCNVMeInitiator|Initiator|Solaris|VMware|Windows)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 256 : each.value.io_throttle_count
  lun_count                   = each.value.max_luns_per_target
  lun_queue_depth             = each.value.lun_queue_depth
  name                        = each.value.name
  resource_allocation_timeout = each.value.resource_allocation_timeout
  error_recovery_settings {
    enabled           = each.value.enable_fcp_error_recovery
    io_retry_count    = length(
      regexall("(FCNVMeInitiator|Initiator|Solaris|VMware|Windows)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 30 : each.value.error_recovery_port_down_io_retry
    io_retry_timeout  = each.value.error_recovery_io_retry_timeout
    link_down_timeout = each.value.error_recovery_link_down_timeout
    port_down_timeout = length(
      regexall("(FCNVMeInitiator|Initiator|Windows)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 30000 : each.value.error_recovery_port_down_timeout
  }
  flogi_settings {
    retries = each.value.flogi_retries
    timeout = each.value.flogi_timeout
  }
  interrupt_settings {
    mode = each.value.interrupt_mode
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  plogi_settings {
    retries = each.value.plogi_retries
    timeout = each.value.plogi_timeout
  }
  rx_queue_settings {
    ring_size = length(
      regexall("(FCNVMeTarget|Target)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 2048 : each.value.receive_ring_size
  }
  scsi_queue_settings {
    nr_count = length(
      regexall("(FCNVMeTarget|FCNVMeInitiator)", coalesce(each.value.adapter_template, "EMPTY"))
    ) > 0 ? 16 : each.value.scsi_io_queue_count
    ring_size = each.value.scsi_io_ring_size
  }
  tx_queue_settings {
    ring_size = each.value.transmit_ring_size
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
