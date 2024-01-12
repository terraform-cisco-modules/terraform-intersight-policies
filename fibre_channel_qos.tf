#__________________________________________________________________
#
# Intersight Fibre Channel QoS Policy
# GUI Location: Policies > Create Policy > Fibre Channel QoS
#__________________________________________________________________

resource "intersight_vnic_fc_qos_policy" "map" {
  for_each            = local.fibre_channel_qos
  burst               = each.value.burst # FI-Attached
  cos                 = each.value.cos   # Standalone
  description         = coalesce(each.value.description, "${each.value.name} Fibre-Channel QoS Policy.")
  max_data_field_size = each.value.max_data_field_size
  name                = each.value.name
  rate_limit          = each.value.rate_limit
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_vnic_fc_qos_policy" "data" {
  depends_on = [intersight_vnic_fc_qos_policy.map]
  for_each = {
    for v in local.pp.fc_qos : v => v if lookup(local.fibre_channel_qos, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = var.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, burst, cos, create_time, description, domain_group_moid, max_data_field_size,
      mod_time, owners, parent, permission_resources, rate_limit, shared_scope, tags, version_context
    ]
    prevent_destroy = true
  }
}
