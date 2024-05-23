#_________________________________________________________________
#
# Intersight Adapter Configuration Policy
# GUI Location: Policies > Create Policy > Adapter Configuration
#_________________________________________________________________
resource "intersight_adapter_config_policy" "map" {
  for_each    = local.adapter_configuration
  description = coalesce(each.value.description, "${each.value.name} Adapter Configuration Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.org] }
  dynamic "settings" {
    for_each = { for v in each.value.add_vic_adapter_configuration : v.pci_slot => v }
    content {
      dce_interface_settings = settings.value.dce_interface_settings
      object_type            = "adapter.AdapterConfig"
      slot_id                = settings.value.pci_slot
      eth_settings {
        lldp_enabled = settings.value.enable_lldp
      }
      fc_settings {
        fip_enabled = settings.value.enable_fip
      }
      port_channel_settings {
        enabled = settings.value.enable_port_channel
      }
    }
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
