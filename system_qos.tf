#__________________________________________________________________
#
# Intersight System QoS Policy
# GUI Location: Policies > Create Policy > System QoS
#__________________________________________________________________

resource "intersight_fabric_system_qos_policy" "system_qos" {
  for_each    = local.system_qos
  description = lookup(each.value, "description", "${each.value.name} System QoS Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "classes" {
    for_each = { for v in each.value.classes : v.priority => v }
    content {
      additional_properties = ""
      admin_state = length(
        regexall("(Best Effort|FC)", classes.key)
      ) > 0 ? "Enabled" : classes.value.state
      bandwidth_percent = classes.value.bandwidth_percent
      cos = classes.key == "Best Effort" ? 255 : classes.key == "FC" ? 3 : length(
        regexall("Bronze", classes.key)) > 0 && classes.value.cos != null ? 1 : length(
        regexall("Gold", classes.key)) > 0 && classes.value.cos != null ? 4 : length(
        regexall("Platinum", classes.key)) > 0 && classes.value.cos != null ? 5 : length(
      regexall("Silver", classes.key)) > 0 && classes.value.cos != null ? 2 : classes.value.cos
      mtu                = classes.key == "FC" ? 2240 : classes.value.mtu
      multicast_optimize = classes.key == "Silver" ? true : false
      name               = classes.key
      object_type        = "fabric.QosClass"
      packet_drop = length(
        regexall("(Best Effort)", classes.key)) > 0 ? true : length(
        regexall("(FC)", classes.key)
      ) > 0 ? false : classes.value.packet_drop
      weight = classes.value.weight
    }
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
