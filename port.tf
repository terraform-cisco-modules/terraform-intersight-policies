#__________________________________________________________________
#
# Intersight Port Policy
# GUI Location: Policies > Create Policy > Port
#__________________________________________________________________
resource "intersight_fabric_port_policy" "map" {
  depends_on = [
    intersight_fabric_eth_network_control_policy.map,
    intersight_fabric_eth_network_group_policy.map,
    intersight_fabric_flow_control_policy.map,
    intersight_fabric_link_aggregation_policy.map,
    intersight_fabric_link_control_policy.map
  ]
  for_each     = local.port
  description  = coalesce(each.value.description, "${each.value.name} Port Policy.")
  device_model = each.value.device_model
  name         = each.value.name
  organization { moid = var.orgs[each.value.org] }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#________________________________________________________________________________________________
#
# Intersight Port Policy - Port Role - Appliance
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Port Role - Appliance
#________________________________________________________________________________________________

resource "intersight_fabric_appliance_pc_role" "map" {
  depends_on  = [intersight_fabric_port_policy.map]
  for_each    = local.port_channel_appliances
  admin_speed = each.value.admin_speed
  # aggregate_port_id = lookup(each.value, "breakout_port_id", 0)
  mode     = each.value.mode
  pc_id    = each.value.pc_id
  priority = each.value.priority
  eth_network_control_policy {
    moid = contains(keys(local.ethernet_network_control), each.value.ethernet_network_control_policy
      ) == true ? intersight_fabric_eth_network_control_policy.map[each.value.ethernet_network_control_policy
    ].moid : local.policies_data["ethernet_network_control"][each.value.ethernet_network_control_policy].moid
  }
  eth_network_group_policy {
    moid = contains(keys(local.ethernet_network_group), each.value.ethernet_network_group_policy
      ) == true ? intersight_fabric_eth_network_group_policy.map[each.value.ethernet_network_group_policy
    ].moid : local.policies_data["ethernet_network_group"][each.value.ethernet_network_group_policy].moid
  }
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "link_aggregation_policy" {
    for_each = { for v in [each.value.link_aggregation_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.link_aggregation), link_aggregation_policy.value) == true ? intersight_fabric_link_aggregation_policy.map[link_aggregation_policy.value
      ].moid : local.policies_data["link_aggregation"][link_aggregation_policy.value].moid
    }
  }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = lookup(ports.value, "breakout_port_id", 0)
      port_id           = ports.value.port_id
      slot_id           = lookup(ports.value, "slot_id", 1)
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


#______________________________________________________________________________________________________________________
#
# Intersight Port Policy - Ethernet Uplink Port Channel
# GUI Location: Policies > Create Policy > Port > Port Channels > Create a Port Channel > Ethernet Uplink Port Channel
#______________________________________________________________________________________________________________________

resource "intersight_fabric_uplink_pc_role" "map" {
  depends_on  = [intersight_fabric_port_policy.map]
  for_each    = local.port_channel_ethernet_uplinks
  admin_speed = each.value.admin_speed
  pc_id       = each.value.pc_id
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "eth_network_group_policy" {
    for_each = { for v in [each.value.ethernet_network_group_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.ethernet_network_group), eth_network_group_policy.value
        ) == true ? intersight_fabric_eth_network_group_policy.map[eth_network_group_policy.value
      ].moid : local.policies_data["ethernet_network_group"][eth_network_group_policy.value].moid
    }
  }
  dynamic "flow_control_policy" {
    for_each = { for v in [each.value.flow_control_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.flow_control), flow_control_policy.value) == true ? intersight_fabric_flow_control_policy.map[flow_control_policy.value
      ].moid : local.policies_data["flow_control"][flow_control_policy.value].moid
    }
  }
  dynamic "link_aggregation_policy" {
    for_each = { for v in [each.value.link_aggregation_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.link_aggregation), link_aggregation_policy.value) == true ? intersight_fabric_link_aggregation_policy.map[link_aggregation_policy.value
      ].moid : local.policies_data["link_aggregation"][link_aggregation_policy.value].moid
    }
  }
  dynamic "link_control_policy" {
    for_each = { for v in [each.value.link_control_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.link_control), link_control_policy.value) == true ? intersight_fabric_link_control_policy.map[link_control_policy.value
      ].moid : local.policies_data["link_control"][link_control_policy.value].moid
    }
  }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = lookup(ports.value, "breakout_port_id", 0)
      port_id           = ports.value.port_id
      slot_id           = lookup(ports.value, "slot_id", 1)
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


#________________________________________________________________________________________________________________
#
# Intersight Port Policy - FC Uplink Port Channel
# GUI Location: Policies > Create Policy > Port > Port Channels > Create a Port Channel > FC Uplink Port Channel
#________________________________________________________________________________________________________________

resource "intersight_fabric_fc_uplink_pc_role" "map" {
  depends_on = [
    intersight_fabric_port_policy.map,
    intersight_fabric_port_mode.map
  ]
  for_each    = local.port_channel_fc_uplinks
  admin_speed = each.value.admin_speed
  pc_id       = each.value.pc_id
  vsan_id     = each.value.vsan_id
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = lookup(ports.value, "breakout_port_id", 0)
      port_id           = ports.value.port_id
      slot_id           = lookup(ports.value, "slot_id", 1)
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


#______________________________________________________________________________________________________________________
#
# Intersight Port Policy - FCoE Uplink Port Channel
# GUI Location: Policies > Create Policy > Port > Port Channels > Create a Port Channel > FCoE Uplink Port Channel
#______________________________________________________________________________________________________________________

resource "intersight_fabric_fcoe_uplink_pc_role" "map" {
  depends_on  = [intersight_fabric_port_policy.map]
  for_each    = local.port_channel_fcoe_uplinks
  admin_speed = each.value.admin_speed
  pc_id       = each.value.pc_id
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "link_aggregation_policy" {
    for_each = { for v in [each.value.link_aggregation_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.link_aggregation), link_aggregation_policy.value) == true ? intersight_fabric_link_aggregation_policy.map[link_aggregation_policy.value
      ].moid : local.policies_data["link_aggregation"][link_aggregation_policy.value].moid
    }
  }
  dynamic "link_control_policy" {
    for_each = { for v in [each.value.link_control_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.link_control), link_control_policy.value) == true ? intersight_fabric_link_control_policy.map[link_control_policy.value
      ].moid : local.policies_data["link_control"][link_control_policy.value].moid
    }
  }
  dynamic "ports" {
    for_each = each.value.interfaces
    content {
      aggregate_port_id = lookup(ports.value, "breakout_port_id", 0)
      port_id           = ports.value.port_id
      slot_id           = lookup(ports.value, "slot_id", 1)
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


#__________________________________________________________________
#
# Intersight Port Policy - Move the Slider for Port mode
# GUI Location: Policies > Create Policy > Port > Move the Slider
#__________________________________________________________________

resource "intersight_fabric_port_mode" "map" {
  depends_on    = [intersight_fabric_port_policy.map]
  for_each      = local.port_modes
  custom_mode   = each.value.custom_mode
  port_id_end   = element(each.value.port_list, 1)
  port_id_start = element(each.value.port_list, 0)
  slot_id       = lookup(each.value, "slot_id", 1)
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#________________________________________________________________________________________________
#
# Intersight Port Policy - Port Role - Appliance
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Port Role - Appliance
#________________________________________________________________________________________________

resource "intersight_fabric_appliance_role" "map" {
  depends_on        = [intersight_fabric_port_policy.map]
  for_each          = local.port_role_appliances
  admin_speed       = each.value.admin_speed
  aggregate_port_id = lookup(each.value, "breakout_port_id", 0)
  fec               = each.value.fec
  mode              = each.value.mode
  port_id           = each.value.port_id
  priority          = each.value.priority
  slot_id           = lookup(each.value, "slot_id", 1)
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  eth_network_control_policy {
    moid = contains(keys(local.ethernet_network_control), each.value.ethernet_network_control_policy
      ) == true ? intersight_fabric_eth_network_control_policy.map[each.value.ethernet_network_control_policy
    ].moid : local.policies_data["ethernet_network_control"][each.value.ethernet_network_control_policy].moid
  }
  eth_network_group_policy {
    moid = contains(keys(local.ethernet_network_group), each.value.ethernet_network_group_policy
      ) == true ? intersight_fabric_eth_network_group_policy.map[each.value.ethernet_network_group_policy
    ].moid : local.policies_data["ethernet_network_group"][each.value.ethernet_network_group_policy].moid
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

#__________________________________________________________________________________________
#
# Intersight Port Policy - Ethernet Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Ethernet Uplink
#__________________________________________________________________________________________

resource "intersight_fabric_uplink_role" "map" {
  depends_on        = [intersight_fabric_port_policy.map]
  for_each          = local.port_role_ethernet_uplinks
  admin_speed       = each.value.admin_speed
  aggregate_port_id = lookup(each.value, "breakout_port_id", 0)
  fec               = each.value.fec
  port_id           = each.value.port_id
  slot_id           = lookup(each.value, "slot_id", 1)
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "eth_network_group_policy" {
    for_each = { for v in [each.value.ethernet_network_group_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.ethernet_network_group), eth_network_group_policy.value
        ) == true ? intersight_fabric_eth_network_group_policy.map[eth_network_group_policy.value
      ].moid : local.policies_data["ethernet_network_group"][eth_network_group_policy.value].moid
    }
  }
  dynamic "flow_control_policy" {
    for_each = { for v in [each.value.flow_control_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.flow_control), flow_control_policy.value) == true ? intersight_fabric_flow_control_policy.map[flow_control_policy.value
      ].moid : local.policies_data["flow_control"][flow_control_policy.value].moid
    }
  }
  dynamic "link_control_policy" {
    for_each = { for v in [each.value.link_control_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.link_control), link_control_policy.value) == true ? intersight_fabric_link_control_policy.map[link_control_policy.value
      ].moid : local.policies_data["link_control"][link_control_policy.value].moid
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


#________________________________________________________________________
#
# Intersight Port Policy - FC Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > FC Uplink
#________________________________________________________________________

resource "intersight_fabric_fc_storage_role" "map" {
  depends_on = [
    intersight_fabric_port_policy.map,
    intersight_fabric_port_mode.map
  ]
  for_each          = local.port_role_fc_storage
  admin_speed       = each.value.admin_speed
  aggregate_port_id = lookup(each.value, "breakout_port_id", 0)
  port_id           = each.value.port_id
  slot_id           = lookup(each.value, "slot_id", 1)
  vsan_id           = each.value.vsan_id
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#________________________________________________________________________
#
# Intersight Port Policy - FC Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > FC Uplink
#________________________________________________________________________

resource "intersight_fabric_fc_uplink_role" "map" {
  depends_on = [
    intersight_fabric_port_policy.map,
    intersight_fabric_port_mode.map
  ]
  for_each          = local.port_role_fc_uplinks
  admin_speed       = each.value.admin_speed
  aggregate_port_id = lookup(each.value, "breakout_port_id", 0)
  port_id           = each.value.port_id
  slot_id           = lookup(each.value, "slot_id", 1)
  vsan_id           = each.value.vsan_id
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#__________________________________________________________________________________________
#
# Intersight Port Policy - Ethernet Uplink
# GUI Location: Policies > Create Policy > Port > Port Roles > Configure > Ethernet Uplink
#__________________________________________________________________________________________

resource "intersight_fabric_fcoe_uplink_role" "map" {
  depends_on        = [intersight_fabric_port_policy.map]
  for_each          = local.port_role_fcoe_uplinks
  admin_speed       = each.value.admin_speed
  aggregate_port_id = lookup(each.value, "breakout_port_id", 0)
  fec               = each.value.fec
  port_id           = each.value.port_id
  slot_id           = lookup(each.value, "slot_id", 1)
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "link_control_policy" {
    for_each = { for v in [each.value.link_control_policy] : v => v if element(split("/", v), 1) != "UNUSED" }
    content {
      moid = contains(keys(local.link_control), link_control_policy.value) == true ? intersight_fabric_link_control_policy.map[link_control_policy.value
      ].moid : local.policies_data["link_control"][link_control_policy.value].moid
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


#_____________________________________________________________________
#
# Intersight Port Policy - Server Ports
# GUI Location: Policies > Create Policy > Port > Port Roles > Server
#_____________________________________________________________________

resource "intersight_fabric_server_role" "map" {
  depends_on                = [intersight_fabric_port_policy.map]
  for_each                  = local.port_role_servers
  aggregate_port_id         = lookup(each.value, "breakout_port_id", 0)
  auto_negotiation_disabled = lookup(each.value, "auto_negotiation", false)
  fec                       = lookup(each.value, "fec", "Auto") # Auto, Cl74, Cl91
  port_id                   = each.value.port_id
  preferred_device_id       = lookup(each.value, "device_number", null)
  preferred_device_type     = lookup(each.value, "connected_device_type", "Auto") # Chassis, RackServer
  slot_id                   = lookup(each.value, "slot_id", 1)
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_lan_pin_group" "map" {
  depends_on = [
    intersight_fabric_port_policy.map,
    intersight_fabric_uplink_pc_role.map,
    intersight_fabric_fc_uplink_pc_role.map,
    intersight_fabric_uplink_role.map,
    intersight_fabric_fc_storage_role.map,
    intersight_fabric_fc_uplink_role.map
  ]
  for_each = { for k, v in local.port_pin_groups : k => v if v.pin_group_type == "lan" }
  name     = each.value.pin_group_name
  dynamic "pin_target_interface_role" {
    for_each = { for v in [0] : v => v if each.value.enabled == true }
    content {
      moid        = local.pin_group_maps[each.value.interface_type].moids[each.value.policy_name]
      object_type = local.pin_group_maps[each.value.interface_type].object
    }
  }
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}

resource "intersight_fabric_san_pin_group" "map" {
  depends_on = [
    intersight_fabric_port_policy.map,
    intersight_fabric_uplink_pc_role.map,
    intersight_fabric_fc_uplink_pc_role.map,
    intersight_fabric_uplink_role.map,
    intersight_fabric_fc_storage_role.map,
    intersight_fabric_fc_uplink_role.map
  ]
  for_each = { for k, v in local.port_pin_groups : k => v if v.pin_group_type == "san" }
  name     = each.value.pin_group_name
  dynamic "pin_target_interface_role" {
    for_each = { for v in [0] : v => v if each.value.enabled == true }
    content {
      moid        = local.pin_group_maps[each.value.interface_type].moids[each.value.policy_name]
      object_type = local.pin_group_maps[each.value.interface_type].object
    }
  }
  port_policy { moid = intersight_fabric_port_policy.map[each.value.port_policy].moid }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
