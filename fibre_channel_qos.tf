#__________________________________________________________________
#
# Intersight Fibre Channel QoS Policy
# GUI Location: Policies > Create Policy > Fibre Channel QoS
#__________________________________________________________________
resource "intersight_vnic_fc_qos_policy" "map" {
  for_each            = local.fibre_channel_qos
  burst               = each.value.burst            # FI-Attached
  cos                 = each.value.class_of_service # Standalone
  description         = coalesce(each.value.description, "${each.value.name} Fibre-Channel QoS Policy.")
  max_data_field_size = each.value.max_data_field_size
  name                = each.value.name
  rate_limit          = each.value.rate_limit
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
