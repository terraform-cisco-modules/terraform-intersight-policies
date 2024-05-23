#__________________________________________________________________
#
# Intersight Fibre Channel Adapter Policy
# GUI Location: Policies > Create Policy > Fibre Channel Adapter
#__________________________________________________________________
resource "intersight_vnic_fc_adapter_policy" "map" {
  for_each                    = local.fibre_channel_adapter
  description                 = coalesce(each.value.description, "${each.value.name} Fibre-Channel Adapter Policy.")
  error_detection_timeout     = each.value.error_detection_timeout
  io_throttle_count           = each.value.io_throttle_count
  lun_count                   = each.value.maximum_luns_per_target
  lun_queue_depth             = each.value.lun_queue_depth
  name                        = each.value.name
  resource_allocation_timeout = each.value.resource_allocation_timeout
  error_recovery_settings {
    enabled           = each.value.error_recovery.fcp_error_recovery
    io_retry_count    = each.value.error_recovery.port_down_io_retry
    io_retry_timeout  = each.value.error_recovery.io_retry_timeout
    link_down_timeout = each.value.error_recovery.link_down_timeout
    port_down_timeout = each.value.error_recovery.port_down_timeout
  }
  flogi_settings {
    retries = each.value.flogi.retries
    timeout = each.value.flogi.timeout
  }
  interrupt_settings { mode = each.value.interrupt.mode }
  organization { moid = var.orgs[each.value.org] }
  plogi_settings {
    retries = each.value.plogi.retries
    timeout = each.value.plogi.timeout
  }
  rx_queue_settings {
    ring_size = each.value.receive.ring_size
  }
  scsi_queue_settings {
    nr_count  = each.value.scsi_io.queue_count
    ring_size = each.value.scsi_io.ring_size
  }
  tx_queue_settings { ring_size = each.value.transmit.ring_size }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
