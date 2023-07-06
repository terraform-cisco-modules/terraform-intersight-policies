#__________________________________________________________________
#
# Intersight Fibre Channel Adapter Policy
# GUI Location: Policies > Create Policy > Fibre Channel Adapter
#__________________________________________________________________

resource "intersight_vnic_fc_adapter_policy" "fibre_channel_adapter" {
  for_each = local.fibre_channel_adapter
  description = length(
    regexall("(FCNVMeInitiator)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for FCNVMeInitiator." : length(
    regexall("(FCNVMeTarget)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for FCNVMeTarget." : length(
    regexall("(Initiator)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for Initiator." : length(
    regexall("(Linux)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for linux." : length(
    regexall("(Solaris)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for Solaris." : length(
    regexall("(VMware)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for VMware." : length(
    regexall("(WindowsBoot)", each.value.adapter_template)) > 0 ? "Recommended adapter settings for WindowsBoot." : length(
    regexall("(Windows)", each.value.adapter_template)
  ) > 0 ? "Recommended adapter settings for Windows." : each.value.description != "" ? each.value.description : "${each.value.name} Fibre-Channel Adapter Policy."
  error_detection_timeout = each.value.error_detection_timeout
  io_throttle_count = length(
    regexall("(FCNVMeInitiator|Initiator|Solaris|VMware|Windows)", each.value.adapter_template)
  ) > 0 ? 256 : each.value.io_throttle_count
  lun_count                   = each.value.maximum_luns_per_target
  lun_queue_depth             = each.value.lun_queue_depth
  name                        = each.value.name
  resource_allocation_timeout = each.value.resource_allocation_timeout
  error_recovery_settings {
    enabled = each.value.error_recovery.fcp_error_recovery
    io_retry_count = length(
      regexall("(FCNVMeInitiator|Initiator|Solaris|VMware|Windows)", each.value.adapter_template)
    ) > 0 ? 30 : each.value.error_recovery.port_down_io_retry
    io_retry_timeout  = each.value.error_recovery.io_retry_timeout
    link_down_timeout = each.value.error_recovery.link_down_timeout
    port_down_timeout = length(
      regexall("(FCNVMeInitiator|Initiator|Windows)", each.value.adapter_template)
    ) > 0 ? 30000 : each.value.error_recovery.port_down_timeout
  }
  flogi_settings {
    retries = each.value.flogi.retries
    timeout = each.value.flogi.timeout
  }
  interrupt_settings {
    mode = each.value.interrupt_settings.mode
  }
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  plogi_settings {
    retries = each.value.plogi.retries
    timeout = each.value.plogi.timeout
  }
  rx_queue_settings {
    ring_size = length(
      regexall("(FCNVMeTarget|Target)", each.value.adapter_template)
    ) > 0 ? 2048 : each.value.receive.ring_size
  }
  scsi_queue_settings {
    nr_count = length(
      regexall("(FCNVMeTarget|FCNVMeInitiator)", each.value.adapter_template)
    ) > 0 ? 16 : each.value.scsi_io.queue_count
    ring_size = each.value.scsi_io.ring_size
  }
  tx_queue_settings {
    ring_size = each.value.transmit.ring_size
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
