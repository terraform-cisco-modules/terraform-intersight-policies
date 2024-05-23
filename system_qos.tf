#__________________________________________________________________
#
# Intersight System QoS Policy
# GUI Location: Policies > Create Policy > System QoS
#__________________________________________________________________
resource "intersight_fabric_system_qos_policy" "map" {
  for_each    = local.system_qos
  description = coalesce(each.value.description, "${each.value.name} System QoS Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.org] }
  dynamic "classes" {
    for_each = each.value.classes
    content {
      additional_properties = ""
      admin_state = length(regexall("(Best Effort|FC)", classes.key)
      ) > 0 ? "Enabled" : lookup(classes.value, "state", local.qos.classes[classes.key].state)
      bandwidth_percent = length(regexall("Enabled", lookup(classes.value, "state", local.qos.classes[classes.key].weight))
      ) > 0 ? tonumber(format("%.0f", tonumber((tonumber(lookup(classes.value, "weight", local.qos.classes[classes.key].weight)) / each.value.bandwidth_total) * 100))) : 0
      cos = lookup(classes.value, "cos", local.qos.classes[classes.key].cos)
      mtu = classes.key == "FC" ? 2240 : length(
        regexall("Enabled", lookup(classes.value, "state", local.qos.classes[classes.key].state))
      ) > 0 && each.value.jumbo_mtu == true ? 9216 : 1500
      multicast_optimize = classes.key == "Silver" ? true : false
      name               = classes.key
      object_type        = "fabric.QosClass"
      packet_drop = length(
        regexall("(Best Effort)", classes.key)) > 0 ? true : length(
        regexall("(FC)", classes.key)
      ) > 0 ? false : lookup(classes.value, "packet_drop", local.qos.classes[classes.key].packet_drop)
      weight = lookup(classes.value, "weight", local.qos.classes[classes.key].weight)
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
