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
    for_each = { for k, v in each.value.classes : k => v }
    content {
      additional_properties = ""
      admin_state = length(regexall("(Best Effort|FC)", classes.value.priority)
      ) > 0 ? "Enabled" : lookup(classes.value, "state", local.qos.classes[classes.value.priority].state)
      bandwidth_percent = length(regexall("Enabled", lookup(classes.value, "state", local.qos.classes[classes.value.priority].weight))
      ) > 0 ? tonumber(format("%.0f", tonumber((tonumber(lookup(classes.value, "weight", local.qos.classes[classes.value.priority].weight)) / each.value.bandwidth_total) * 100))) : 0
      cos = lookup(classes.value, "cos", local.qos.classes[classes.value.priority].cos)
      mtu = classes.value.priority == "FC" ? 2240 : length(
        regexall("Enabled", lookup(classes.value, "state", local.qos.classes[classes.value.priority].state))
      ) > 0 && each.value.jumbo_mtu == true ? 9216 : 1500
      multicast_optimize = classes.value.priority == "Silver" ? true : false
      name               = classes.value.priority
      object_type        = "fabric.QosClass"
      packet_drop = length(
        regexall("(Best Effort)", classes.value.priority)) > 0 ? true : length(
        regexall("(FC)", classes.value.priority)
      ) > 0 ? false : lookup(classes.value, "packet_drop", local.qos.classes[classes.value.priority].packet_drop)
      weight = lookup(classes.value, "weight", local.qos.classes[classes.value.priority].weight)
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
