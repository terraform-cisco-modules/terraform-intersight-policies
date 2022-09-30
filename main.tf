locals {
  defaults   = lookup(var.model, "defaults", {})
  domains    = var.domains
  modules    = lookup(var.model, "modules", {})
  intersight = lookup(var.model, "intersight", {})
  orgs       = var.pools.orgs
  pools      = var.pools
  policies   = lookup(local.intersight, "policies", {})
  port = flatten([
    for value in lookup(local.policies, "port", []) : [
      for i in range(length(value.names)) : {
        description  = lookup(value, "description", "")
        device_model = lookup(value, "device_model", local.defaults.intersight.policies.port.device_model)
        name         = "${element(value.names, i)}${local.defaults.intersight.policies.port.name_suffix}"
        organization = local.orgs[lookup(value, "organization", local.defaults.intersight.organization)]
        port_channel_appliances = [
          for v in lookup(value, "port_channel_appliances", []) : {
            admin_speed = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_appliances.admin_speed)
            ethernet_network_control_policy = lookup(
              v, "ethernet_network_control_policy", local.defaults.intersight.policies.port.port_channel_appliances.ethernet_network_control_policy
            )
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_channel_appliances.ethernet_network_group_policy
            )
            interfaces = lookup(v, "interfaces", [])
            mode       = lookup(v, "mode", local.defaults.intersight.policies.port.port_channel_appliances.mode)
            pc_id      = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
            priority   = lookup(v, "priority", local.defaults.intersight.policies.port.port_channel_appliances.priority)
          }
        ]
        port_channel_ethernet_uplinks = [
          for v in lookup(value, "port_channel_ethernet_uplinks", []) : {
            admin_speed = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.admin_speed)
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.ethernet_network_group_policy
            )
            flow_control_policy = lookup(v, "flow_control_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.flow_control_policy
            )
            interfaces = lookup(v, "interfaces", [])
            link_aggregation_policy = lookup(
              v, "link_aggregation_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.link_aggregation_policy
            )
            link_control_policy = lookup(
              v, "link_control_policy", local.defaults.intersight.policies.port.port_channel_ethernet_uplinks.link_control_policy
            )
            pc_id = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
          }
        ]
        port_channel_fc_uplinks = [
          for v in lookup(value, "port_channel_fc_uplinks", []) : {
            admin_speed  = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_fc_uplinks.admin_speed)
            fill_pattern = lookup(v, "fill_pattern", local.defaults.intersight.policies.port.port_channel_fc_uplinks.fill_pattern)
            interfaces   = lookup(v, "interfaces", [])
            pc_id        = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
            vsan_id      = length(v.vsan_ids) == 1 ? element(v.vsan_ids, 0) : element(v.vsan_ids, i)
          }
        ]
        port_channel_fcoe_uplinks = [
          for v in lookup(value, "port_channel_fcoe_uplinks", []) : {
            admin_speed = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.admin_speed)
            interfaces  = lookup(v, "interfaces", [])
            link_aggregation_policy = lookup(v, "link_aggregation_policy", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.link_aggregation_policy
            )
            link_control_policy = lookup(
              v, "link_control_policy", local.defaults.intersight.policies.port.port_channel_fcoe_uplinks.link_control_policy
            )
            pc_id = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
          }
        ]
        port_modes = [
          for v in lookup(value, "port_modes", []) : {
            custom_mode = lookup(v, "custom_mode", local.defaults.intersight.policies.port.port_modes.custom_mode)
            port_list   = v.port_list
            slot_id     = lookup(v, "slot_id", 1)
          }
        ]
        port_role_appliances = [
          for v in lookup(value, "port_role_appliances", []) : {
            admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_appliances.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            ethernet_network_control_policy = lookup(v, "ethernet_network_control_policy", local.defaults.intersight.policies.port.port_role_appliances.ethernet_network_control_policy
            )
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_role_appliances.ethernet_network_group_policy
            )
            fec       = lookup(v, "fec", local.defaults.intersight.policies.port.port_role_appliances.fec)
            mode      = lookup(v, "mode", local.defaults.intersight.policies.port.port_role_appliances.mode)
            port_list = v.port_list
            priority  = lookup(v, "priority", local.defaults.intersight.policies.port.port_role_appliances.priority)
            slot_id   = lookup(v, "slot_id", 1)
          }
        ]
        port_role_ethernet_uplinks = [
          for v in lookup(value, "port_role_ethernet_uplinks", []) : {
            admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.ethernet_network_group_policy
            )
            fec = lookup(v, "fec", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.fec)
            flow_control_policy = lookup(
              v, "flow_control_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.flow_control_policy
            )
            link_control_policy = lookup(
              v, "link_control_policy", local.defaults.intersight.policies.port.port_role_ethernet_uplinks.link_control_policy
            )
            port_list = v.port_list
            slot_id   = lookup(v, "slot_id", 1)
          }
        ]
        port_role_fc_storage = [
          for v in lookup(value, "port_role_fc_storage", []) : {
            admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_fc_storage.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            port_list        = v.port_list
            slot_id          = lookup(v, "slot_id", 1)
            vsan_id          = v.vsan_id
          }
        ]
        port_role_fc_uplinks = [
          for v in lookup(value, "port_role_fc_uplinks", []) : {
            admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_fc_uplinks.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            fill_pattern     = lookup(v, "fill_pattern", local.defaults.intersight.policies.port.port_role_fc_uplinks.fill_pattern)
            port_list        = v.port_list
            slot_id          = lookup(v, "slot_id", 1)
            vsan_id          = v.vsan_id
          }
        ]
        port_role_fcoe_uplinks = [
          for v in lookup(value, "port_role_fcoe_uplinks", []) : {
            admin_speed      = lookup(v, "admin_speed", local.defaults.intersight.policies.port.port_role_fcoe_uplinks.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            interfaces       = lookup(v, "interfaces", [])
            fec              = lookup(v, "fec", local.defaults.intersight.policies.port.port_role_fcoe_uplinks.fec)
            link_control_policy = lookup(
              v, "link_control_policy", local.defaults.intersight.policies.port.port_role_fcoe_uplinks.link_control_policy
            )
            port_list = v.port_list
            slot_id   = lookup(v, "slot_id", 1)
          }
        ]
        port_role_servers = [
          for v in lookup(value, "port_role_servers", []) : {
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            port_list        = v.port_list
            slot_id          = lookup(v, "slot_id", 1)
          }
        ]
        profiles = [
          for v in local.domains : v.name if length(regexall(
            "^${element(value.names, i)}$", v.port_policy)) > 0 || length(regexall(
            "^${element(value.names, i)}${local.defaults.intersight.policies.port.name_suffix}$, v.port_policy")
          ) > 0
        ]
        tags = lookup(value, "tags", local.defaults.intersight.tags)

      }
      ] if lookup(
    local.modules.policies, "port", true)
  ])
}

#_________________________________________________________________
#
# Intersight Adapter Configuration Policy
# GUI Location: Policies > Create Policy > Adapter Configuration
#_________________________________________________________________

module "adapter_configuration" {
  source  = "terraform-cisco-modules/policies-adapter-configuration/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "adapter_configuration", []) : v.name => v if lookup(
      local.modules.policies, "adapter_configuration", true
    )
  }
  adapter_ports = lookup(
    each.value, "adapter_ports", local.defaults.intersight.policies.adapter_configuration.adapter_ports
  )
  description = lookup(each.value, "description", "")
  enable_fip = lookup(
    each.value, "enable_fip", local.defaults.intersight.policies.adapter_configuration.enable_fip
  )
  enable_lldp = lookup(
    each.value, "enable_lldp", local.defaults.intersight.policies.adapter_configuration.enable_lldp
  )
  enable_port_channel = lookup(
    each.value, "enable_port_channel", local.defaults.intersight.policies.adapter_configuration.enable_port_channel
  )
  fec_modes = lookup(
    each.value, "fec_modes", local.defaults.intersight.policies.adapter_configuration.fec_modes
  )
  name = "${each.value.name}${local.defaults.intersight.policies.adapter_configuration.name_suffix}"
  pci_slot = lookup(
    each.value, "pci_slot", local.defaults.intersight.policies.adapter_configuration.pci_slot
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight BIOS Policy
# GUI Location: Policies > Create Policy > BIOS
#__________________________________________________________________

module "bios" {
  source  = "terraform-cisco-modules/policies-bios/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "bios", []) : v.name => v if lookup(
      local.modules.policies, "bios", true
    )
  }
  bios_template = lookup(each.value, "bios_template", "")
  description   = lookup(each.value, "description", "")
  name          = "${each.value.name}${local.defaults.intersight.policies.bios.name_suffix}"
  organization  = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags          = lookup(each.value, "tags", local.defaults.intersight.tags)
  #+++++++++++++++++++++++++++++++
  # Boot Options Section
  #+++++++++++++++++++++++++++++++
  boot_option_num_retry        = lookup(each.value, "boot_option_num_retry", local.defaults.intersight.policies.bios.boot_option_num_retry)
  boot_option_re_cool_down     = lookup(each.value, "boot_option_re_cool_down", local.defaults.intersight.policies.bios.boot_option_re_cool_down)
  boot_option_retry            = lookup(each.value, "boot_option_retry", local.defaults.intersight.policies.bios.boot_option_retry)
  ipv4http                     = lookup(each.value, "ipv4http", local.defaults.intersight.policies.bios.ipv4http)
  ipv4pxe                      = lookup(each.value, "ipv4pxe", local.defaults.intersight.policies.bios.ipv4pxe)
  ipv6http                     = lookup(each.value, "ipv6http", local.defaults.intersight.policies.bios.ipv6http)
  ipv6pxe                      = lookup(each.value, "ipv6pxe", local.defaults.intersight.policies.bios.ipv6pxe)
  network_stack                = lookup(each.value, "network_stack", local.defaults.intersight.policies.bios.network_stack)
  onboard_scu_storage_support  = lookup(each.value, "onboard_scu_storage_support", local.defaults.intersight.policies.bios.onboard_scu_storage_support)
  onboard_scu_storage_sw_stack = lookup(each.value, "onboard_scu_storage_sw_stack", local.defaults.intersight.policies.bios.onboard_scu_storage_sw_stack)
  pop_support                  = lookup(each.value, "pop_support", local.defaults.intersight.policies.bios.pop_support)
  psata                        = lookup(each.value, "psata", local.defaults.intersight.policies.bios.psata)
  sata_mode_select             = lookup(each.value, "sata_mode_select", local.defaults.intersight.policies.bios.sata_mode_select)
  vmd_enable                   = lookup(each.value, "vmd_enable", local.defaults.intersight.policies.bios.vmd_enable)
  #+++++++++++++++++++++++++++++++
  # Intel Directed IO Section
  #+++++++++++++++++++++++++++++++
  intel_vt_for_directed_io           = lookup(each.value, "intel_vt_for_directed_io", local.defaults.intersight.policies.bios.intel_vt_for_directed_io)
  intel_vtd_coherency_support        = lookup(each.value, "intel_vtd_coherency_support", local.defaults.intersight.policies.bios.intel_vtd_coherency_support)
  intel_vtd_interrupt_remapping      = lookup(each.value, "intel_vtd_interrupt_remapping", local.defaults.intersight.policies.bios.intel_vtd_interrupt_remapping)
  intel_vtd_pass_through_dma_support = lookup(each.value, "intel_vtd_pass_through_dma_support", local.defaults.intersight.policies.bios.intel_vtd_pass_through_dma_support)
  intel_vtdats_support               = lookup(each.value, "intel_vtdats_support", local.defaults.intersight.policies.bios.intel_vtdats_support)
  #+++++++++++++++++++++++++++++++
  # LOM and PCIe Slots Section
  #+++++++++++++++++++++++++++++++
  acs_control_gpu1state          = lookup(each.value, "acs_control_gpu1state", local.defaults.intersight.policies.bios.acs_control_gpu1state)
  acs_control_gpu2state          = lookup(each.value, "acs_control_gpu2state", local.defaults.intersight.policies.bios.acs_control_gpu2state)
  acs_control_gpu3state          = lookup(each.value, "acs_control_gpu3state", local.defaults.intersight.policies.bios.acs_control_gpu3state)
  acs_control_gpu4state          = lookup(each.value, "acs_control_gpu4state", local.defaults.intersight.policies.bios.acs_control_gpu4state)
  acs_control_gpu5state          = lookup(each.value, "acs_control_gpu5state", local.defaults.intersight.policies.bios.acs_control_gpu5state)
  acs_control_gpu6state          = lookup(each.value, "acs_control_gpu6state", local.defaults.intersight.policies.bios.acs_control_gpu6state)
  acs_control_gpu7state          = lookup(each.value, "acs_control_gpu7state", local.defaults.intersight.policies.bios.acs_control_gpu7state)
  acs_control_gpu8state          = lookup(each.value, "acs_control_gpu8state", local.defaults.intersight.policies.bios.acs_control_gpu8state)
  acs_control_slot11state        = lookup(each.value, "acs_control_slot11state", local.defaults.intersight.policies.bios.acs_control_slot11state)
  acs_control_slot12state        = lookup(each.value, "acs_control_slot12state", local.defaults.intersight.policies.bios.acs_control_slot12state)
  acs_control_slot13state        = lookup(each.value, "acs_control_slot13state", local.defaults.intersight.policies.bios.acs_control_slot13state)
  acs_control_slot14state        = lookup(each.value, "acs_control_slot14state", local.defaults.intersight.policies.bios.acs_control_slot14state)
  cdn_support                    = lookup(each.value, "cdn_support", local.defaults.intersight.policies.bios.cdn_support)
  edpc_en                        = lookup(each.value, "edpc_en", local.defaults.intersight.policies.bios.edpc_en)
  enable_clock_spread_spec       = lookup(each.value, "enable_clock_spread_spec", local.defaults.intersight.policies.bios.enable_clock_spread_spec)
  lom_port0state                 = lookup(each.value, "lom_port0state", local.defaults.intersight.policies.bios.lom_port0state)
  lom_port1state                 = lookup(each.value, "lom_port1state", local.defaults.intersight.policies.bios.lom_port1state)
  lom_port2state                 = lookup(each.value, "lom_port2state", local.defaults.intersight.policies.bios.lom_port2state)
  lom_port3state                 = lookup(each.value, "lom_port3state", local.defaults.intersight.policies.bios.lom_port3state)
  lom_ports_all_state            = lookup(each.value, "lom_ports_all_state", local.defaults.intersight.policies.bios.lom_ports_all_state)
  pci_option_ro_ms               = lookup(each.value, "pci_option_ro_ms", local.defaults.intersight.policies.bios.pci_option_ro_ms)
  pci_rom_clp                    = lookup(each.value, "pci_rom_clp", local.defaults.intersight.policies.bios.pci_rom_clp)
  pcie_ari_support               = lookup(each.value, "pcie_ari_support", local.defaults.intersight.policies.bios.pcie_ari_support)
  pcie_pll_ssc                   = lookup(each.value, "pcie_pll_ssc", local.defaults.intersight.policies.bios.pcie_pll_ssc)
  pcie_slot_mraid1link_speed     = lookup(each.value, "pcie_slot_mraid1link_speed", local.defaults.intersight.policies.bios.pcie_slot_mraid1link_speed)
  pcie_slot_mraid1option_rom     = lookup(each.value, "pcie_slot_mraid1option_rom", local.defaults.intersight.policies.bios.pcie_slot_mraid1option_rom)
  pcie_slot_mraid2link_speed     = lookup(each.value, "pcie_slot_mraid2link_speed", local.defaults.intersight.policies.bios.pcie_slot_mraid2link_speed)
  pcie_slot_mraid2option_rom     = lookup(each.value, "pcie_slot_mraid2option_rom", local.defaults.intersight.policies.bios.pcie_slot_mraid2option_rom)
  pcie_slot_mstorraid_link_speed = lookup(each.value, "pcie_slot_mstorraid_link_speed", local.defaults.intersight.policies.bios.pcie_slot_mstorraid_link_speed)
  pcie_slot_mstorraid_option_rom = lookup(each.value, "pcie_slot_mstorraid_option_rom", local.defaults.intersight.policies.bios.pcie_slot_mstorraid_option_rom)
  pcie_slot_nvme1link_speed      = lookup(each.value, "pcie_slot_nvme1link_speed", local.defaults.intersight.policies.bios.pcie_slot_nvme1link_speed)
  pcie_slot_nvme1option_rom      = lookup(each.value, "pcie_slot_nvme1option_rom", local.defaults.intersight.policies.bios.pcie_slot_nvme1option_rom)
  pcie_slot_nvme2link_speed      = lookup(each.value, "pcie_slot_nvme2link_speed", local.defaults.intersight.policies.bios.pcie_slot_nvme2link_speed)
  pcie_slot_nvme2option_rom      = lookup(each.value, "pcie_slot_nvme2option_rom", local.defaults.intersight.policies.bios.pcie_slot_nvme2option_rom)
  pcie_slot_nvme3link_speed      = lookup(each.value, "pcie_slot_nvme3link_speed", local.defaults.intersight.policies.bios.pcie_slot_nvme3link_speed)
  pcie_slot_nvme3option_rom      = lookup(each.value, "pcie_slot_nvme3option_rom", local.defaults.intersight.policies.bios.pcie_slot_nvme3option_rom)
  pcie_slot_nvme4link_speed      = lookup(each.value, "pcie_slot_nvme4link_speed", local.defaults.intersight.policies.bios.pcie_slot_nvme4link_speed)
  pcie_slot_nvme4option_rom      = lookup(each.value, "pcie_slot_nvme4option_rom", local.defaults.intersight.policies.bios.pcie_slot_nvme4option_rom)
  pcie_slot_nvme5link_speed      = lookup(each.value, "pcie_slot_nvme5link_speed", local.defaults.intersight.policies.bios.pcie_slot_nvme5link_speed)
  pcie_slot_nvme5option_rom      = lookup(each.value, "pcie_slot_nvme5option_rom", local.defaults.intersight.policies.bios.pcie_slot_nvme5option_rom)
  pcie_slot_nvme6link_speed      = lookup(each.value, "pcie_slot_nvme6link_speed", local.defaults.intersight.policies.bios.pcie_slot_nvme6link_speed)
  pcie_slot_nvme6option_rom      = lookup(each.value, "pcie_slot_nvme6option_rom", local.defaults.intersight.policies.bios.pcie_slot_nvme6option_rom)
  slot10link_speed               = lookup(each.value, "slot10link_speed", local.defaults.intersight.policies.bios.slot10link_speed)
  slot10state                    = lookup(each.value, "slot10state", local.defaults.intersight.policies.bios.slot10state)
  slot11link_speed               = lookup(each.value, "slot11link_speed", local.defaults.intersight.policies.bios.slot11link_speed)
  slot11state                    = lookup(each.value, "slot11state", local.defaults.intersight.policies.bios.slot11state)
  slot12link_speed               = lookup(each.value, "slot12link_speed", local.defaults.intersight.policies.bios.slot12link_speed)
  slot12state                    = lookup(each.value, "slot12state", local.defaults.intersight.policies.bios.slot12state)
  slot13state                    = lookup(each.value, "slot13state", local.defaults.intersight.policies.bios.slot13state)
  slot14state                    = lookup(each.value, "slot14state", local.defaults.intersight.policies.bios.slot14state)
  slot1link_speed                = lookup(each.value, "slot1link_speed", local.defaults.intersight.policies.bios.slot1link_speed)
  slot1state                     = lookup(each.value, "slot1state", local.defaults.intersight.policies.bios.slot1state)
  slot2link_speed                = lookup(each.value, "slot2link_speed", local.defaults.intersight.policies.bios.slot2link_speed)
  slot2state                     = lookup(each.value, "slot2state", local.defaults.intersight.policies.bios.slot2state)
  slot3link_speed                = lookup(each.value, "slot3link_speed", local.defaults.intersight.policies.bios.slot3link_speed)
  slot3state                     = lookup(each.value, "slot3state", local.defaults.intersight.policies.bios.slot3state)
  slot4link_speed                = lookup(each.value, "slot4link_speed", local.defaults.intersight.policies.bios.slot4link_speed)
  slot4state                     = lookup(each.value, "slot4state", local.defaults.intersight.policies.bios.slot4state)
  slot5link_speed                = lookup(each.value, "slot5link_speed", local.defaults.intersight.policies.bios.slot5link_speed)
  slot5state                     = lookup(each.value, "slot5state", local.defaults.intersight.policies.bios.slot5state)
  slot6link_speed                = lookup(each.value, "slot6link_speed", local.defaults.intersight.policies.bios.slot6link_speed)
  slot6state                     = lookup(each.value, "slot6state", local.defaults.intersight.policies.bios.slot6state)
  slot7link_speed                = lookup(each.value, "slot7link_speed", local.defaults.intersight.policies.bios.slot7link_speed)
  slot7state                     = lookup(each.value, "slot7state", local.defaults.intersight.policies.bios.slot7state)
  slot8link_speed                = lookup(each.value, "slot8link_speed", local.defaults.intersight.policies.bios.slot8link_speed)
  slot8state                     = lookup(each.value, "slot8state", local.defaults.intersight.policies.bios.slot8state)
  slot9link_speed                = lookup(each.value, "slot9link_speed", local.defaults.intersight.policies.bios.slot9link_speed)
  slot9state                     = lookup(each.value, "slot9state", local.defaults.intersight.policies.bios.slot9state)
  slot_flom_link_speed           = lookup(each.value, "slot_flom_link_speed", local.defaults.intersight.policies.bios.slot_flom_link_speed)
  slot_front_nvme10link_speed    = lookup(each.value, "slot_front_nvme10link_speed", local.defaults.intersight.policies.bios.slot_front_nvme10link_speed)
  slot_front_nvme10option_rom    = lookup(each.value, "slot_front_nvme10option_rom", local.defaults.intersight.policies.bios.slot_front_nvme10option_rom)
  slot_front_nvme11link_speed    = lookup(each.value, "slot_front_nvme11link_speed", local.defaults.intersight.policies.bios.slot_front_nvme11link_speed)
  slot_front_nvme11option_rom    = lookup(each.value, "slot_front_nvme11option_rom", local.defaults.intersight.policies.bios.slot_front_nvme11option_rom)
  slot_front_nvme12link_speed    = lookup(each.value, "slot_front_nvme12link_speed", local.defaults.intersight.policies.bios.slot_front_nvme12link_speed)
  slot_front_nvme12option_rom    = lookup(each.value, "slot_front_nvme12option_rom", local.defaults.intersight.policies.bios.slot_front_nvme12option_rom)
  slot_front_nvme13option_rom    = lookup(each.value, "slot_front_nvme13option_rom", local.defaults.intersight.policies.bios.slot_front_nvme13option_rom)
  slot_front_nvme14option_rom    = lookup(each.value, "slot_front_nvme14option_rom", local.defaults.intersight.policies.bios.slot_front_nvme14option_rom)
  slot_front_nvme15option_rom    = lookup(each.value, "slot_front_nvme15option_rom", local.defaults.intersight.policies.bios.slot_front_nvme15option_rom)
  slot_front_nvme16option_rom    = lookup(each.value, "slot_front_nvme16option_rom", local.defaults.intersight.policies.bios.slot_front_nvme16option_rom)
  slot_front_nvme17option_rom    = lookup(each.value, "slot_front_nvme17option_rom", local.defaults.intersight.policies.bios.slot_front_nvme17option_rom)
  slot_front_nvme18option_rom    = lookup(each.value, "slot_front_nvme18option_rom", local.defaults.intersight.policies.bios.slot_front_nvme18option_rom)
  slot_front_nvme19option_rom    = lookup(each.value, "slot_front_nvme19option_rom", local.defaults.intersight.policies.bios.slot_front_nvme19option_rom)
  slot_front_nvme1link_speed     = lookup(each.value, "slot_front_nvme1link_speed", local.defaults.intersight.policies.bios.slot_front_nvme1link_speed)
  slot_front_nvme1option_rom     = lookup(each.value, "slot_front_nvme1option_rom", local.defaults.intersight.policies.bios.slot_front_nvme1option_rom)
  slot_front_nvme20option_rom    = lookup(each.value, "slot_front_nvme20option_rom", local.defaults.intersight.policies.bios.slot_front_nvme20option_rom)
  slot_front_nvme21option_rom    = lookup(each.value, "slot_front_nvme21option_rom", local.defaults.intersight.policies.bios.slot_front_nvme21option_rom)
  slot_front_nvme22option_rom    = lookup(each.value, "slot_front_nvme22option_rom", local.defaults.intersight.policies.bios.slot_front_nvme22option_rom)
  slot_front_nvme23option_rom    = lookup(each.value, "slot_front_nvme23option_rom", local.defaults.intersight.policies.bios.slot_front_nvme23option_rom)
  slot_front_nvme24option_rom    = lookup(each.value, "slot_front_nvme24option_rom", local.defaults.intersight.policies.bios.slot_front_nvme24option_rom)
  slot_front_nvme2link_speed     = lookup(each.value, "slot_front_nvme2link_speed", local.defaults.intersight.policies.bios.slot_front_nvme2link_speed)
  slot_front_nvme2option_rom     = lookup(each.value, "slot_front_nvme2option_rom", local.defaults.intersight.policies.bios.slot_front_nvme2option_rom)
  slot_front_nvme3link_speed     = lookup(each.value, "slot_front_nvme3link_speed", local.defaults.intersight.policies.bios.slot_front_nvme3link_speed)
  slot_front_nvme3option_rom     = lookup(each.value, "slot_front_nvme3option_rom", local.defaults.intersight.policies.bios.slot_front_nvme3option_rom)
  slot_front_nvme4link_speed     = lookup(each.value, "slot_front_nvme4link_speed", local.defaults.intersight.policies.bios.slot_front_nvme4link_speed)
  slot_front_nvme4option_rom     = lookup(each.value, "slot_front_nvme4option_rom", local.defaults.intersight.policies.bios.slot_front_nvme4option_rom)
  slot_front_nvme5link_speed     = lookup(each.value, "slot_front_nvme5link_speed", local.defaults.intersight.policies.bios.slot_front_nvme5link_speed)
  slot_front_nvme5option_rom     = lookup(each.value, "slot_front_nvme5option_rom", local.defaults.intersight.policies.bios.slot_front_nvme5option_rom)
  slot_front_nvme6link_speed     = lookup(each.value, "slot_front_nvme6link_speed", local.defaults.intersight.policies.bios.slot_front_nvme6link_speed)
  slot_front_nvme6option_rom     = lookup(each.value, "slot_front_nvme6option_rom", local.defaults.intersight.policies.bios.slot_front_nvme6option_rom)
  slot_front_nvme7link_speed     = lookup(each.value, "slot_front_nvme7link_speed", local.defaults.intersight.policies.bios.slot_front_nvme7link_speed)
  slot_front_nvme7option_rom     = lookup(each.value, "slot_front_nvme7option_rom", local.defaults.intersight.policies.bios.slot_front_nvme7option_rom)
  slot_front_nvme8link_speed     = lookup(each.value, "slot_front_nvme8link_speed", local.defaults.intersight.policies.bios.slot_front_nvme8link_speed)
  slot_front_nvme8option_rom     = lookup(each.value, "slot_front_nvme8option_rom", local.defaults.intersight.policies.bios.slot_front_nvme8option_rom)
  slot_front_nvme9link_speed     = lookup(each.value, "slot_front_nvme9link_speed", local.defaults.intersight.policies.bios.slot_front_nvme9link_speed)
  slot_front_nvme9option_rom     = lookup(each.value, "slot_front_nvme9option_rom", local.defaults.intersight.policies.bios.slot_front_nvme9option_rom)
  slot_front_slot5link_speed     = lookup(each.value, "slot_front_slot5link_speed", local.defaults.intersight.policies.bios.slot_front_slot5link_speed)
  slot_front_slot6link_speed     = lookup(each.value, "slot_front_slot6link_speed", local.defaults.intersight.policies.bios.slot_front_slot6link_speed)
  slot_gpu1state                 = lookup(each.value, "slot_gpu1state", local.defaults.intersight.policies.bios.slot_gpu1state)
  slot_gpu2state                 = lookup(each.value, "slot_gpu2state", local.defaults.intersight.policies.bios.slot_gpu2state)
  slot_gpu3state                 = lookup(each.value, "slot_gpu3state", local.defaults.intersight.policies.bios.slot_gpu3state)
  slot_gpu4state                 = lookup(each.value, "slot_gpu4state", local.defaults.intersight.policies.bios.slot_gpu4state)
  slot_gpu5state                 = lookup(each.value, "slot_gpu5state", local.defaults.intersight.policies.bios.slot_gpu5state)
  slot_gpu6state                 = lookup(each.value, "slot_gpu6state", local.defaults.intersight.policies.bios.slot_gpu6state)
  slot_gpu7state                 = lookup(each.value, "slot_gpu7state", local.defaults.intersight.policies.bios.slot_gpu7state)
  slot_gpu8state                 = lookup(each.value, "slot_gpu8state", local.defaults.intersight.policies.bios.slot_gpu8state)
  slot_hba_link_speed            = lookup(each.value, "slot_hba_link_speed", local.defaults.intersight.policies.bios.slot_hba_link_speed)
  slot_hba_state                 = lookup(each.value, "slot_hba_state", local.defaults.intersight.policies.bios.slot_hba_state)
  slot_lom1link                  = lookup(each.value, "slot_lom1link", local.defaults.intersight.policies.bios.slot_lom1link)
  slot_lom2link                  = lookup(each.value, "slot_lom2link", local.defaults.intersight.policies.bios.slot_lom2link)
  slot_mezz_state                = lookup(each.value, "slot_mezz_state", local.defaults.intersight.policies.bios.slot_mezz_state)
  slot_mlom_link_speed           = lookup(each.value, "slot_mlom_link_speed", local.defaults.intersight.policies.bios.slot_mlom_link_speed)
  slot_mlom_state                = lookup(each.value, "slot_mlom_state", local.defaults.intersight.policies.bios.slot_mlom_state)
  slot_mraid_link_speed          = lookup(each.value, "slot_mraid_link_speed", local.defaults.intersight.policies.bios.slot_mraid_link_speed)
  slot_mraid_state               = lookup(each.value, "slot_mraid_state", local.defaults.intersight.policies.bios.slot_mraid_state)
  slot_n10state                  = lookup(each.value, "slot_n10state", local.defaults.intersight.policies.bios.slot_n10state)
  slot_n11state                  = lookup(each.value, "slot_n11state", local.defaults.intersight.policies.bios.slot_n11state)
  slot_n12state                  = lookup(each.value, "slot_n12state", local.defaults.intersight.policies.bios.slot_n12state)
  slot_n13state                  = lookup(each.value, "slot_n13state", local.defaults.intersight.policies.bios.slot_n13state)
  slot_n14state                  = lookup(each.value, "slot_n14state", local.defaults.intersight.policies.bios.slot_n14state)
  slot_n15state                  = lookup(each.value, "slot_n15state", local.defaults.intersight.policies.bios.slot_n15state)
  slot_n16state                  = lookup(each.value, "slot_n16state", local.defaults.intersight.policies.bios.slot_n16state)
  slot_n17state                  = lookup(each.value, "slot_n17state", local.defaults.intersight.policies.bios.slot_n17state)
  slot_n18state                  = lookup(each.value, "slot_n18state", local.defaults.intersight.policies.bios.slot_n18state)
  slot_n19state                  = lookup(each.value, "slot_n19state", local.defaults.intersight.policies.bios.slot_n19state)
  slot_n1state                   = lookup(each.value, "slot_n1state", local.defaults.intersight.policies.bios.slot_n1state)
  slot_n20state                  = lookup(each.value, "slot_n20state", local.defaults.intersight.policies.bios.slot_n20state)
  slot_n21state                  = lookup(each.value, "slot_n21state", local.defaults.intersight.policies.bios.slot_n21state)
  slot_n22state                  = lookup(each.value, "slot_n22state", local.defaults.intersight.policies.bios.slot_n22state)
  slot_n23state                  = lookup(each.value, "slot_n23state", local.defaults.intersight.policies.bios.slot_n23state)
  slot_n24state                  = lookup(each.value, "slot_n24state", local.defaults.intersight.policies.bios.slot_n24state)
  slot_n2state                   = lookup(each.value, "slot_n2state", local.defaults.intersight.policies.bios.slot_n2state)
  slot_n3state                   = lookup(each.value, "slot_n3state", local.defaults.intersight.policies.bios.slot_n3state)
  slot_n4state                   = lookup(each.value, "slot_n4state", local.defaults.intersight.policies.bios.slot_n4state)
  slot_n5state                   = lookup(each.value, "slot_n5state", local.defaults.intersight.policies.bios.slot_n5state)
  slot_n6state                   = lookup(each.value, "slot_n6state", local.defaults.intersight.policies.bios.slot_n6state)
  slot_n7state                   = lookup(each.value, "slot_n7state", local.defaults.intersight.policies.bios.slot_n7state)
  slot_n8state                   = lookup(each.value, "slot_n8state", local.defaults.intersight.policies.bios.slot_n8state)
  slot_n9state                   = lookup(each.value, "slot_n9state", local.defaults.intersight.policies.bios.slot_n9state)
  slot_raid_link_speed           = lookup(each.value, "slot_raid_link_speed", local.defaults.intersight.policies.bios.slot_raid_link_speed)
  slot_raid_state                = lookup(each.value, "slot_raid_state", local.defaults.intersight.policies.bios.slot_raid_state)
  slot_rear_nvme1link_speed      = lookup(each.value, "slot_rear_nvme1link_speed", local.defaults.intersight.policies.bios.slot_rear_nvme1link_speed)
  slot_rear_nvme1state           = lookup(each.value, "slot_rear_nvme1state", local.defaults.intersight.policies.bios.slot_rear_nvme1state)
  slot_rear_nvme2link_speed      = lookup(each.value, "slot_rear_nvme2link_speed", local.defaults.intersight.policies.bios.slot_rear_nvme2link_speed)
  slot_rear_nvme2state           = lookup(each.value, "slot_rear_nvme2state", local.defaults.intersight.policies.bios.slot_rear_nvme2state)
  slot_rear_nvme3link_speed      = lookup(each.value, "slot_rear_nvme3link_speed", local.defaults.intersight.policies.bios.slot_rear_nvme3link_speed)
  slot_rear_nvme3state           = lookup(each.value, "slot_rear_nvme3state", local.defaults.intersight.policies.bios.slot_rear_nvme3state)
  slot_rear_nvme4link_speed      = lookup(each.value, "slot_rear_nvme4link_speed", local.defaults.intersight.policies.bios.slot_rear_nvme4link_speed)
  slot_rear_nvme4state           = lookup(each.value, "slot_rear_nvme4state", local.defaults.intersight.policies.bios.slot_rear_nvme4state)
  slot_rear_nvme5state           = lookup(each.value, "slot_rear_nvme5state", local.defaults.intersight.policies.bios.slot_rear_nvme5state)
  slot_rear_nvme6state           = lookup(each.value, "slot_rear_nvme6state", local.defaults.intersight.policies.bios.slot_rear_nvme6state)
  slot_rear_nvme7state           = lookup(each.value, "slot_rear_nvme7state", local.defaults.intersight.policies.bios.slot_rear_nvme7state)
  slot_rear_nvme8state           = lookup(each.value, "slot_rear_nvme8state", local.defaults.intersight.policies.bios.slot_rear_nvme8state)
  slot_riser1link_speed          = lookup(each.value, "slot_riser1link_speed", local.defaults.intersight.policies.bios.slot_riser1link_speed)
  slot_riser1slot1link_speed     = lookup(each.value, "slot_riser1slot1link_speed", local.defaults.intersight.policies.bios.slot_riser1slot1link_speed)
  slot_riser1slot2link_speed     = lookup(each.value, "slot_riser1slot2link_speed", local.defaults.intersight.policies.bios.slot_riser1slot2link_speed)
  slot_riser1slot3link_speed     = lookup(each.value, "slot_riser1slot3link_speed", local.defaults.intersight.policies.bios.slot_riser1slot3link_speed)
  slot_riser2link_speed          = lookup(each.value, "slot_riser2link_speed", local.defaults.intersight.policies.bios.slot_riser2link_speed)
  slot_riser2slot4link_speed     = lookup(each.value, "slot_riser2slot4link_speed", local.defaults.intersight.policies.bios.slot_riser2slot4link_speed)
  slot_riser2slot5link_speed     = lookup(each.value, "slot_riser2slot5link_speed", local.defaults.intersight.policies.bios.slot_riser2slot5link_speed)
  slot_riser2slot6link_speed     = lookup(each.value, "slot_riser2slot6link_speed", local.defaults.intersight.policies.bios.slot_riser2slot6link_speed)
  slot_sas_state                 = lookup(each.value, "slot_sas_state", local.defaults.intersight.policies.bios.slot_sas_state)
  slot_ssd_slot1link_speed       = lookup(each.value, "slot_ssd_slot1link_speed", local.defaults.intersight.policies.bios.slot_ssd_slot1link_speed)
  slot_ssd_slot2link_speed       = lookup(each.value, "slot_ssd_slot2link_speed", local.defaults.intersight.policies.bios.slot_ssd_slot2link_speed)
  #+++++++++++++++++++++++++++++++
  # Main Section
  #+++++++++++++++++++++++++++++++
  pcie_slots_cdn_enable = lookup(each.value, "pcie_slots_cdn_enable", local.defaults.intersight.policies.bios.pcie_slots_cdn_enable)
  post_error_pause      = lookup(each.value, "post_error_pause", local.defaults.intersight.policies.bios.post_error_pause)
  tpm_support           = lookup(each.value, "tpm_support", local.defaults.intersight.policies.bios.tpm_support)
  #+++++++++++++++++++++++++++++++
  # Memory Section
  #+++++++++++++++++++++++++++++++
  advanced_mem_test                     = lookup(each.value, "advanced_mem_test", local.defaults.intersight.policies.bios.advanced_mem_test)
  bme_dma_mitigation                    = lookup(each.value, "bme_dma_mitigation", local.defaults.intersight.policies.bios.bme_dma_mitigation)
  burst_and_postponed_refresh           = lookup(each.value, "burst_and_postponed_refresh", local.defaults.intersight.policies.bios.burst_and_postponed_refresh)
  cbs_cmn_cpu_smee                      = lookup(each.value, "cbs_cmn_cpu_smee", local.defaults.intersight.policies.bios.cbs_cmn_cpu_smee)
  cbs_cmn_gnb_nb_iommu                  = lookup(each.value, "cbs_cmn_gnb_nb_iommu", local.defaults.intersight.policies.bios.cbs_cmn_gnb_nb_iommu)
  cbs_cmn_mem_ctrl_bank_group_swap_ddr4 = lookup(each.value, "cbs_cmn_mem_ctrl_bank_group_swap_ddr4", local.defaults.intersight.policies.bios.cbs_cmn_mem_ctrl_bank_group_swap_ddr4)
  cbs_cmn_mem_map_bank_interleave_ddr4  = lookup(each.value, "cbs_cmn_mem_map_bank_interleave_ddr4", local.defaults.intersight.policies.bios.cbs_cmn_mem_map_bank_interleave_ddr4)
  cbs_dbg_cpu_snp_mem_cover             = lookup(each.value, "cbs_dbg_cpu_snp_mem_cover", local.defaults.intersight.policies.bios.cbs_dbg_cpu_snp_mem_cover)
  cbs_dbg_cpu_snp_mem_size_cover        = lookup(each.value, "cbs_dbg_cpu_snp_mem_size_cover", local.defaults.intersight.policies.bios.cbs_dbg_cpu_snp_mem_size_cover)
  cbs_df_cmn_dram_nps                   = lookup(each.value, "cbs_df_cmn_dram_nps", local.defaults.intersight.policies.bios.cbs_df_cmn_dram_nps)
  cbs_df_cmn_mem_intlv                  = lookup(each.value, "cbs_df_cmn_mem_intlv", local.defaults.intersight.policies.bios.cbs_df_cmn_mem_intlv)
  cbs_df_cmn_mem_intlv_size             = lookup(each.value, "cbs_df_cmn_mem_intlv_size", local.defaults.intersight.policies.bios.cbs_df_cmn_mem_intlv_size)
  cbs_sev_snp_support                   = lookup(each.value, "cbs_sev_snp_support", local.defaults.intersight.policies.bios.cbs_sev_snp_support)
  cke_low_policy                        = lookup(each.value, "cke_low_policy", local.defaults.intersight.policies.bios.cke_low_policy)
  cr_qos                                = lookup(each.value, "cr_qos", local.defaults.intersight.policies.bios.cr_qos)
  crfastgo_config                       = lookup(each.value, "crfastgo_config", local.defaults.intersight.policies.bios.crfastgo_config)
  dcpmm_firmware_downgrade              = lookup(each.value, "dcpmm_firmware_downgrade", local.defaults.intersight.policies.bios.dcpmm_firmware_downgrade)
  dram_refresh_rate                     = lookup(each.value, "dram_refresh_rate", local.defaults.intersight.policies.bios.dram_refresh_rate)
  dram_sw_thermal_throttling            = lookup(each.value, "dram_sw_thermal_throttling", local.defaults.intersight.policies.bios.dram_sw_thermal_throttling)
  eadr_support                          = lookup(each.value, "eadr_support", local.defaults.intersight.policies.bios.eadr_support)
  lv_ddr_mode                           = lookup(each.value, "lv_ddr_mode", local.defaults.intersight.policies.bios.lv_ddr_mode)
  memory_bandwidth_boost                = lookup(each.value, "memory_bandwidth_boost", local.defaults.intersight.policies.bios.memory_bandwidth_boost)
  memory_refresh_rate                   = lookup(each.value, "memory_refresh_rate", local.defaults.intersight.policies.bios.memory_refresh_rate)
  memory_size_limit                     = lookup(each.value, "memory_size_limit", local.defaults.intersight.policies.bios.memory_size_limit)
  memory_thermal_throttling             = lookup(each.value, "memory_thermal_throttling", local.defaults.intersight.policies.bios.memory_thermal_throttling)
  mirroring_mode                        = lookup(each.value, "mirroring_mode", local.defaults.intersight.policies.bios.mirroring_mode)
  numa_optimized                        = lookup(each.value, "numa_optimized", local.defaults.intersight.policies.bios.numa_optimized)
  nvmdimm_perform_config                = lookup(each.value, "nvmdimm_perform_config", local.defaults.intersight.policies.bios.nvmdimm_perform_config)
  operation_mode                        = lookup(each.value, "operation_mode", local.defaults.intersight.policies.bios.operation_mode)
  panic_high_watermark                  = lookup(each.value, "panic_high_watermark", local.defaults.intersight.policies.bios.panic_high_watermark)
  partial_cache_line_sparing            = lookup(each.value, "partial_cache_line_sparing", local.defaults.intersight.policies.bios.partial_cache_line_sparing)
  partial_mirror_mode_config            = lookup(each.value, "partial_mirror_mode_config", local.defaults.intersight.policies.bios.partial_mirror_mode_config)
  partial_mirror_percent                = lookup(each.value, "partial_mirror_percent", local.defaults.intersight.policies.bios.partial_mirror_percent)
  partial_mirror_value1                 = lookup(each.value, "partial_mirror_value1", local.defaults.intersight.policies.bios.partial_mirror_value1)
  partial_mirror_value2                 = lookup(each.value, "partial_mirror_value2", local.defaults.intersight.policies.bios.partial_mirror_value2)
  partial_mirror_value3                 = lookup(each.value, "partial_mirror_value3", local.defaults.intersight.policies.bios.partial_mirror_value3)
  partial_mirror_value4                 = lookup(each.value, "partial_mirror_value4", local.defaults.intersight.policies.bios.partial_mirror_value4)
  pc_ie_ras_support                     = lookup(each.value, "pc_ie_ras_support", local.defaults.intersight.policies.bios.pc_ie_ras_support)
  post_package_repair                   = lookup(each.value, "post_package_repair", local.defaults.intersight.policies.bios.post_package_repair)
  select_memory_ras_configuration       = lookup(each.value, "select_memory_ras_configuration", local.defaults.intersight.policies.bios.select_memory_ras_configuration)
  select_ppr_type                       = lookup(each.value, "select_ppr_type", local.defaults.intersight.policies.bios.select_ppr_type)
  sev                                   = lookup(each.value, "sev", local.defaults.intersight.policies.bios.sev)
  smee                                  = lookup(each.value, "smee", local.defaults.intersight.policies.bios.smee)
  snoopy_mode_for2lm                    = lookup(each.value, "snoopy_mode_for2lm", local.defaults.intersight.policies.bios.snoopy_mode_for2lm)
  snoopy_mode_for_ad                    = lookup(each.value, "snoopy_mode_for_ad", local.defaults.intersight.policies.bios.snoopy_mode_for_ad)
  sparing_mode                          = lookup(each.value, "sparing_mode", local.defaults.intersight.policies.bios.sparing_mode)
  tsme                                  = lookup(each.value, "tsme", local.defaults.intersight.policies.bios.tsme)
  uma_based_clustering                  = lookup(each.value, "uma_based_clustering", local.defaults.intersight.policies.bios.uma_based_clustering)
  vol_memory_mode                       = lookup(each.value, "vol_memory_mode", local.defaults.intersight.policies.bios.vol_memory_mode)
  #+++++++++++++++++++++++++++++++
  # PCI Section
  #+++++++++++++++++++++++++++++++
  aspm_support               = lookup(each.value, "aspm_support", local.defaults.intersight.policies.bios.aspm_support)
  ioh_resource               = lookup(each.value, "ioh_resource", local.defaults.intersight.policies.bios.ioh_resource)
  memory_mapped_io_above4gb  = lookup(each.value, "memory_mapped_io_above4gb", local.defaults.intersight.policies.bios.memory_mapped_io_above4gb)
  mmcfg_base                 = lookup(each.value, "mmcfg_base", local.defaults.intersight.policies.bios.mmcfg_base)
  onboard10gbit_lom          = lookup(each.value, "onboard10gbit_lom", local.defaults.intersight.policies.bios.onboard10gbit_lom)
  onboard_gbit_lom           = lookup(each.value, "onboard_gbit_lom", local.defaults.intersight.policies.bios.onboard_gbit_lom)
  pc_ie_ssd_hot_plug_support = lookup(each.value, "pc_ie_ssd_hot_plug_support", local.defaults.intersight.policies.bios.pc_ie_ssd_hot_plug_support)
  sr_iov                     = lookup(each.value, "sr_iov", local.defaults.intersight.policies.bios.sr_iov)
  vga_priority               = lookup(each.value, "vga_priority", local.defaults.intersight.policies.bios.vga_priority)
  #+++++++++++++++++++++++++++++++
  # Power and Performance Section
  #+++++++++++++++++++++++++++++++
  c1auto_demotion                    = lookup(each.value, "c1auto_demotion", local.defaults.intersight.policies.bios.c1auto_demotion)
  c1auto_un_demotion                 = lookup(each.value, "c1auto_un_demotion", local.defaults.intersight.policies.bios.c1auto_un_demotion)
  cbs_cmn_cpu_cpb                    = lookup(each.value, "cbs_cmn_cpu_cpb", local.defaults.intersight.policies.bios.cbs_cmn_cpu_cpb)
  cbs_cmn_cpu_global_cstate_ctrl     = lookup(each.value, "cbs_cmn_cpu_global_cstate_ctrl", local.defaults.intersight.policies.bios.cbs_cmn_cpu_global_cstate_ctrl)
  cbs_cmn_cpu_l1stream_hw_prefetcher = lookup(each.value, "cbs_cmn_cpu_l1stream_hw_prefetcher", local.defaults.intersight.policies.bios.cbs_cmn_cpu_l1stream_hw_prefetcher)
  cbs_cmn_cpu_l2stream_hw_prefetcher = lookup(each.value, "cbs_cmn_cpu_l2stream_hw_prefetcher", local.defaults.intersight.policies.bios.cbs_cmn_cpu_l2stream_hw_prefetcher)
  cbs_cmn_determinism_slider         = lookup(each.value, "cbs_cmn_determinism_slider", local.defaults.intersight.policies.bios.cbs_cmn_determinism_slider)
  cbs_cmn_efficiency_mode_en         = lookup(each.value, "cbs_cmn_efficiency_mode_en", local.defaults.intersight.policies.bios.cbs_cmn_efficiency_mode_en)
  cbs_cmn_gnb_smucppc                = lookup(each.value, "cbs_cmn_gnb_smucppc", local.defaults.intersight.policies.bios.cbs_cmn_gnb_smucppc)
  cbs_cmnc_tdp_ctl                   = lookup(each.value, "cbs_cmnc_tdp_ctl", local.defaults.intersight.policies.bios.cbs_cmnc_tdp_ctl)
  cpu_perf_enhancement               = lookup(each.value, "cpu_perf_enhancement", local.defaults.intersight.policies.bios.cpu_perf_enhancement)
  llc_alloc                          = lookup(each.value, "llc_alloc", local.defaults.intersight.policies.bios.llc_alloc)
  upi_link_enablement                = lookup(each.value, "upi_link_enablement", local.defaults.intersight.policies.bios.upi_link_enablement)
  upi_power_management               = lookup(each.value, "upi_power_management", local.defaults.intersight.policies.bios.upi_power_management)
  virtual_numa                       = lookup(each.value, "virtual_numa", local.defaults.intersight.policies.bios.virtual_numa)
  xpt_remote_prefetch                = lookup(each.value, "xpt_remote_prefetch", local.defaults.intersight.policies.bios.xpt_remote_prefetch)
  #+++++++++++++++++++++++++++++++
  # Processor Section
  #+++++++++++++++++++++++++++++++
  adjacent_cache_line_prefetch      = lookup(each.value, "adjacent_cache_line_prefetch", local.defaults.intersight.policies.bios.adjacent_cache_line_prefetch)
  altitude                          = lookup(each.value, "altitude", local.defaults.intersight.policies.bios.altitude)
  auto_cc_state                     = lookup(each.value, "auto_cc_state", local.defaults.intersight.policies.bios.auto_cc_state)
  autonumous_cstate_enable          = lookup(each.value, "autonumous_cstate_enable", local.defaults.intersight.policies.bios.autonumous_cstate_enable)
  boot_performance_mode             = lookup(each.value, "boot_performance_mode", local.defaults.intersight.policies.bios.boot_performance_mode)
  cbs_cmn_apbdis                    = lookup(each.value, "cbs_cmn_apbdis", local.defaults.intersight.policies.bios.cbs_cmn_apbdis)
  cbs_cmn_cpu_gen_downcore_ctrl     = lookup(each.value, "cbs_cmn_cpu_gen_downcore_ctrl", local.defaults.intersight.policies.bios.cbs_cmn_cpu_gen_downcore_ctrl)
  cbs_cmn_cpu_streaming_stores_ctrl = lookup(each.value, "cbs_cmn_cpu_streaming_stores_ctrl", local.defaults.intersight.policies.bios.cbs_cmn_cpu_streaming_stores_ctrl)
  cbs_cmn_fixed_soc_pstate          = lookup(each.value, "cbs_cmn_fixed_soc_pstate", local.defaults.intersight.policies.bios.cbs_cmn_fixed_soc_pstate)
  cbs_cmn_gnb_smu_df_cstates        = lookup(each.value, "cbs_cmn_gnb_smu_df_cstates", local.defaults.intersight.policies.bios.cbs_cmn_gnb_smu_df_cstates)
  cbs_cpu_ccd_ctrl_ssp              = lookup(each.value, "cbs_cpu_ccd_ctrl_ssp", local.defaults.intersight.policies.bios.cbs_cpu_ccd_ctrl_ssp)
  cbs_cpu_core_ctrl                 = lookup(each.value, "cbs_cpu_core_ctrl", local.defaults.intersight.policies.bios.cbs_cpu_core_ctrl)
  cbs_cpu_smt_ctrl                  = lookup(each.value, "cbs_cpu_smt_ctrl", local.defaults.intersight.policies.bios.cbs_cpu_smt_ctrl)
  cbs_df_cmn_acpi_srat_l3numa       = lookup(each.value, "cbs_df_cmn_acpi_srat_l3numa", local.defaults.intersight.policies.bios.cbs_df_cmn_acpi_srat_l3numa)
  channel_inter_leave               = lookup(each.value, "channel_inter_leave", local.defaults.intersight.policies.bios.channel_inter_leave)
  cisco_xgmi_max_speed              = lookup(each.value, "cisco_xgmi_max_speed", local.defaults.intersight.policies.bios.cisco_xgmi_max_speed)
  closed_loop_therm_throtl          = lookup(each.value, "closed_loop_therm_throtl", local.defaults.intersight.policies.bios.closed_loop_therm_throtl)
  cmci_enable                       = lookup(each.value, "cmci_enable", local.defaults.intersight.policies.bios.cmci_enable)
  config_tdp                        = lookup(each.value, "config_tdp", local.defaults.intersight.policies.bios.config_tdp)
  config_tdp_level                  = lookup(each.value, "config_tdp_level", local.defaults.intersight.policies.bios.config_tdp_level)
  core_multi_processing             = lookup(each.value, "core_multi_processing", local.defaults.intersight.policies.bios.core_multi_processing)
  cpu_energy_performance            = lookup(each.value, "cpu_energy_performance", local.defaults.intersight.policies.bios.cpu_energy_performance)
  cpu_frequency_floor               = lookup(each.value, "cpu_frequency_floor", local.defaults.intersight.policies.bios.cpu_frequency_floor)
  cpu_performance                   = lookup(each.value, "cpu_performance", local.defaults.intersight.policies.bios.cpu_performance)
  cpu_power_management              = lookup(each.value, "cpu_power_management", local.defaults.intersight.policies.bios.cpu_power_management)
  demand_scrub                      = lookup(each.value, "demand_scrub", local.defaults.intersight.policies.bios.demand_scrub)
  direct_cache_access               = lookup(each.value, "direct_cache_access", local.defaults.intersight.policies.bios.direct_cache_access)
  dram_clock_throttling             = lookup(each.value, "dram_clock_throttling", local.defaults.intersight.policies.bios.dram_clock_throttling)
  energy_efficient_turbo            = lookup(each.value, "energy_efficient_turbo", local.defaults.intersight.policies.bios.energy_efficient_turbo)
  eng_perf_tuning                   = lookup(each.value, "eng_perf_tuning", local.defaults.intersight.policies.bios.eng_perf_tuning)
  enhanced_intel_speed_step_tech    = lookup(each.value, "enhanced_intel_speed_step_tech", local.defaults.intersight.policies.bios.enhanced_intel_speed_step_tech)
  epp_enable                        = lookup(each.value, "epp_enable", local.defaults.intersight.policies.bios.epp_enable)
  epp_profile                       = lookup(each.value, "epp_profile", local.defaults.intersight.policies.bios.epp_profile)
  execute_disable_bit               = lookup(each.value, "execute_disable_bit", local.defaults.intersight.policies.bios.execute_disable_bit)
  extended_apic                     = lookup(each.value, "extended_apic", local.defaults.intersight.policies.bios.extended_apic)
  hardware_prefetch                 = lookup(each.value, "hardware_prefetch", local.defaults.intersight.policies.bios.hardware_prefetch)
  hwpm_enable                       = lookup(each.value, "hwpm_enable", local.defaults.intersight.policies.bios.hwpm_enable)
  imc_interleave                    = lookup(each.value, "imc_interleave", local.defaults.intersight.policies.bios.imc_interleave)
  intel_dynamic_speed_select        = lookup(each.value, "intel_dynamic_speed_select", local.defaults.intersight.policies.bios.intel_dynamic_speed_select)
  intel_hyper_threading_tech        = lookup(each.value, "intel_hyper_threading_tech", local.defaults.intersight.policies.bios.intel_hyper_threading_tech)
  intel_speed_select                = lookup(each.value, "intel_speed_select", local.defaults.intersight.policies.bios.intel_speed_select)
  intel_turbo_boost_tech            = lookup(each.value, "intel_turbo_boost_tech", local.defaults.intersight.policies.bios.intel_turbo_boost_tech)
  intel_virtualization_technology   = lookup(each.value, "intel_virtualization_technology", local.defaults.intersight.policies.bios.intel_virtualization_technology)
  ioh_error_enable                  = lookup(each.value, "ioh_error_enable", local.defaults.intersight.policies.bios.ioh_error_enable)
  ip_prefetch                       = lookup(each.value, "ip_prefetch", local.defaults.intersight.policies.bios.ip_prefetch)
  kti_prefetch                      = lookup(each.value, "kti_prefetch", local.defaults.intersight.policies.bios.kti_prefetch)
  llc_prefetch                      = lookup(each.value, "llc_prefetch", local.defaults.intersight.policies.bios.llc_prefetch)
  memory_inter_leave                = lookup(each.value, "memory_inter_leave", local.defaults.intersight.policies.bios.memory_inter_leave)
  package_cstate_limit              = lookup(each.value, "package_cstate_limit", local.defaults.intersight.policies.bios.package_cstate_limit)
  patrol_scrub                      = lookup(each.value, "patrol_scrub", local.defaults.intersight.policies.bios.patrol_scrub)
  patrol_scrub_duration             = lookup(each.value, "patrol_scrub_duration", local.defaults.intersight.policies.bios.patrol_scrub_duration)
  processor_c1e                     = lookup(each.value, "processor_c1e", local.defaults.intersight.policies.bios.processor_c1e)
  processor_c3report                = lookup(each.value, "processor_c3report", local.defaults.intersight.policies.bios.processor_c3report)
  processor_c6report                = lookup(each.value, "processor_c6report", local.defaults.intersight.policies.bios.processor_c6report)
  processor_cstate                  = lookup(each.value, "processor_cstate", local.defaults.intersight.policies.bios.processor_cstate)
  pstate_coord_type                 = lookup(each.value, "pstate_coord_type", local.defaults.intersight.policies.bios.pstate_coord_type)
  pwr_perf_tuning                   = lookup(each.value, "pwr_perf_tuning", local.defaults.intersight.policies.bios.pwr_perf_tuning)
  qpi_link_speed                    = lookup(each.value, "qpi_link_speed", local.defaults.intersight.policies.bios.qpi_link_speed)
  rank_inter_leave                  = lookup(each.value, "rank_inter_leave", local.defaults.intersight.policies.bios.rank_inter_leave)
  single_pctl_enable                = lookup(each.value, "single_pctl_enable", local.defaults.intersight.policies.bios.single_pctl_enable)
  smt_mode                          = lookup(each.value, "smt_mode", local.defaults.intersight.policies.bios.smt_mode)
  snc                               = lookup(each.value, "snc", local.defaults.intersight.policies.bios.snc)
  streamer_prefetch                 = lookup(each.value, "streamer_prefetch", local.defaults.intersight.policies.bios.streamer_prefetch)
  svm_mode                          = lookup(each.value, "svm_mode", local.defaults.intersight.policies.bios.svm_mode)
  ufs_disable                       = lookup(each.value, "ufs_disable", local.defaults.intersight.policies.bios.ufs_disable)
  work_load_config                  = lookup(each.value, "work_load_config", local.defaults.intersight.policies.bios.work_load_config)
  xpt_prefetch                      = lookup(each.value, "xpt_prefetch", local.defaults.intersight.policies.bios.xpt_prefetch)
  #+++++++++++++++++++++++++++++++
  # QPI Section
  #+++++++++++++++++++++++++++++++
  qpi_link_frequency = lookup(each.value, "qpi_link_frequency", local.defaults.intersight.policies.bios.qpi_link_frequency)
  qpi_snoop_mode     = lookup(each.value, "qpi_snoop_mode", local.defaults.intersight.policies.bios.qpi_snoop_mode)
  #+++++++++++++++++++++++++++++++
  # Serial Port Section
  #+++++++++++++++++++++++++++++++
  serial_port_aenable = lookup(each.value, "serial_port_aenable", local.defaults.intersight.policies.bios.serial_port_aenable)
  #+++++++++++++++++++++++++++++++
  # Server Management Section
  #+++++++++++++++++++++++++++++++
  assert_nmi_on_perr              = lookup(each.value, "assert_nmi_on_perr", local.defaults.intersight.policies.bios.assert_nmi_on_perr)
  assert_nmi_on_serr              = lookup(each.value, "assert_nmi_on_serr", local.defaults.intersight.policies.bios.assert_nmi_on_serr)
  baud_rate                       = lookup(each.value, "baud_rate", local.defaults.intersight.policies.bios.baud_rate)
  cdn_enable                      = lookup(each.value, "cdn_enable", local.defaults.intersight.policies.bios.cdn_enable)
  cisco_adaptive_mem_training     = lookup(each.value, "cisco_adaptive_mem_training", local.defaults.intersight.policies.bios.cisco_adaptive_mem_training)
  cisco_debug_level               = lookup(each.value, "cisco_debug_level", local.defaults.intersight.policies.bios.cisco_debug_level)
  cisco_oprom_launch_optimization = lookup(each.value, "cisco_oprom_launch_optimization", local.defaults.intersight.policies.bios.cisco_oprom_launch_optimization)
  console_redirection             = lookup(each.value, "console_redirection", local.defaults.intersight.policies.bios.console_redirection)
  flow_control                    = lookup(each.value, "flow_control", local.defaults.intersight.policies.bios.flow_control)
  frb2enable                      = lookup(each.value, "frb2enable", local.defaults.intersight.policies.bios.frb2enable)
  legacy_os_redirection           = lookup(each.value, "legacy_os_redirection", local.defaults.intersight.policies.bios.legacy_os_redirection)
  os_boot_watchdog_timer          = lookup(each.value, "os_boot_watchdog_timer", local.defaults.intersight.policies.bios.os_boot_watchdog_timer)
  os_boot_watchdog_timer_policy   = lookup(each.value, "os_boot_watchdog_timer_policy", local.defaults.intersight.policies.bios.os_boot_watchdog_timer_policy)
  os_boot_watchdog_timer_timeout  = lookup(each.value, "os_boot_watchdog_timer_timeout", local.defaults.intersight.policies.bios.os_boot_watchdog_timer_timeout)
  out_of_band_mgmt_port           = lookup(each.value, "out_of_band_mgmt_port", local.defaults.intersight.policies.bios.out_of_band_mgmt_port)
  putty_key_pad                   = lookup(each.value, "putty_key_pad", local.defaults.intersight.policies.bios.putty_key_pad)
  redirection_after_post          = lookup(each.value, "redirection_after_post", local.defaults.intersight.policies.bios.redirection_after_post)
  terminal_type                   = lookup(each.value, "terminal_type", local.defaults.intersight.policies.bios.terminal_type)
  ucsm_boot_order_rule            = lookup(each.value, "ucsm_boot_order_rule", local.defaults.intersight.policies.bios.ucsm_boot_order_rule)
  #+++++++++++++++++++++++++++++++
  # Trusted Platform Section
  #+++++++++++++++++++++++++++++++
  cpu_pa_limit                    = lookup(each.value, "cpu_pa_limit", local.defaults.intersight.policies.bios.cpu_pa_limit)
  enable_mktme                    = lookup(each.value, "enable_mktme", local.defaults.intersight.policies.bios.enable_mktme)
  enable_sgx                      = lookup(each.value, "enable_sgx", local.defaults.intersight.policies.bios.enable_sgx)
  enable_tme                      = lookup(each.value, "enable_tme", local.defaults.intersight.policies.bios.enable_tme)
  epoch_update                    = lookup(each.value, "epoch_update", local.defaults.intersight.policies.bios.epoch_update)
  sgx_auto_registration_agent     = lookup(each.value, "sgx_auto_registration_agent", local.defaults.intersight.policies.bios.sgx_auto_registration_agent)
  sgx_epoch0                      = lookup(each.value, "sgx_epoch0", local.defaults.intersight.policies.bios.sgx_epoch0)
  sgx_epoch1                      = lookup(each.value, "sgx_epoch1", local.defaults.intersight.policies.bios.sgx_epoch1)
  sgx_factory_reset               = lookup(each.value, "sgx_factory_reset", local.defaults.intersight.policies.bios.sgx_factory_reset)
  sgx_le_pub_key_hash0            = lookup(each.value, "sgx_le_pub_key_hash0", local.defaults.intersight.policies.bios.sgx_le_pub_key_hash0)
  sgx_le_pub_key_hash1            = lookup(each.value, "sgx_le_pub_key_hash1", local.defaults.intersight.policies.bios.sgx_le_pub_key_hash1)
  sgx_le_pub_key_hash2            = lookup(each.value, "sgx_le_pub_key_hash2", local.defaults.intersight.policies.bios.sgx_le_pub_key_hash2)
  sgx_le_pub_key_hash3            = lookup(each.value, "sgx_le_pub_key_hash3", local.defaults.intersight.policies.bios.sgx_le_pub_key_hash3)
  sgx_le_wr                       = lookup(each.value, "sgx_le_wr", local.defaults.intersight.policies.bios.sgx_le_wr)
  sgx_package_info_in_band_access = lookup(each.value, "sgx_package_info_in_band_access", local.defaults.intersight.policies.bios.sgx_package_info_in_band_access)
  sgx_qos                         = lookup(each.value, "sgx_qos", local.defaults.intersight.policies.bios.sgx_qos)
  sha1pcr_bank                    = lookup(each.value, "sha1pcr_bank", local.defaults.intersight.policies.bios.sha1pcr_bank)
  sha256pcr_bank                  = lookup(each.value, "sha256pcr_bank", local.defaults.intersight.policies.bios.sha256pcr_bank)
  tpm_control                     = lookup(each.value, "tpm_control", local.defaults.intersight.policies.bios.tpm_control)
  tpm_pending_operation           = lookup(each.value, "tpm_pending_operation", local.defaults.intersight.policies.bios.tpm_pending_operation)
  tpm_ppi_required                = lookup(each.value, "tpm_ppi_required", local.defaults.intersight.policies.bios.tpm_ppi_required)
  txt_support                     = lookup(each.value, "txt_support", local.defaults.intersight.policies.bios.txt_support)
  #+++++++++++++++++++++++++++++++
  # USB Section
  #+++++++++++++++++++++++++++++++
  all_usb_devices          = lookup(each.value, "all_usb_devices", local.defaults.intersight.policies.bios.all_usb_devices)
  legacy_usb_support       = lookup(each.value, "legacy_usb_support", local.defaults.intersight.policies.bios.legacy_usb_support)
  make_device_non_bootable = lookup(each.value, "make_device_non_bootable", local.defaults.intersight.policies.bios.make_device_non_bootable)
  pch_usb30mode            = lookup(each.value, "pch_usb30mode", local.defaults.intersight.policies.bios.pch_usb30mode)
  usb_emul6064             = lookup(each.value, "usb_emul6064", local.defaults.intersight.policies.bios.usb_emul6064)
  usb_port_front           = lookup(each.value, "usb_port_front", local.defaults.intersight.policies.bios.usb_port_front)
  usb_port_internal        = lookup(each.value, "usb_port_internal", local.defaults.intersight.policies.bios.usb_port_internal)
  usb_port_kvm             = lookup(each.value, "usb_port_kvm", local.defaults.intersight.policies.bios.usb_port_kvm)
  usb_port_rear            = lookup(each.value, "usb_port_rear", local.defaults.intersight.policies.bios.usb_port_rear)
  usb_port_sd_card         = lookup(each.value, "usb_port_sd_card", local.defaults.intersight.policies.bios.usb_port_sd_card)
  usb_port_vmedia          = lookup(each.value, "usb_port_vmedia", local.defaults.intersight.policies.bios.usb_port_vmedia)
  usb_xhci_support         = lookup(each.value, "usb_xhci_support", local.defaults.intersight.policies.bios.usb_xhci_support)

}



#__________________________________________________________________
#
# Intersight Boot Order Policy
# GUI Location: Policies > Create Policy > Boot Order
#__________________________________________________________________

module "boot_order" {
  source  = "terraform-cisco-modules/policies-boot-order/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "boot_order", []) : v.name => v if lookup(
      local.modules.policies, "boot_order", true
    )
  }
  boot_devices = lookup(each.value, "boot_devices", [])
  boot_mode    = lookup(each.value, "boot_mode", local.defaults.intersight.policies.boot_order.boot_mode)
  description  = lookup(each.value, "description", "")
  enable_secure_boot = lookup(
    each.value, "enable_secure_boot", local.defaults.intersight.policies.boot_order.enable_secure_boot
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.boot_order.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Certificate Management Policy
# GUI Location: Policies > Create Policy > Certificate Management
#__________________________________________________________________

module "certificate_management" {
  source  = "terraform-cisco-modules/policies-certificate-management/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "certificate_management", []) : v.name => v if lookup(
      local.modules.policies, "certificate_management", true
    )
  }
  base64_certificate   = lookup(each.value, "base64_certificate", 1)
  base64_certificate_1 = var.base64_certificate_1
  base64_certificate_2 = var.base64_certificate_2
  base64_certificate_3 = var.base64_certificate_3
  base64_certificate_5 = var.base64_certificate_4
  base64_certificate_4 = var.base64_certificate_5
  base64_private_key   = lookup(each.value, "base64_private_key", 1)
  base64_private_key_1 = var.base64_private_key_1
  base64_private_key_2 = var.base64_private_key_2
  base64_private_key_3 = var.base64_private_key_3
  base64_private_key_4 = var.base64_private_key_4
  base64_private_key_5 = var.base64_private_key_5
  description          = lookup(each.value, "description", "")
  name                 = "${each.value.name}${local.defaults.intersight.policies.certificate_management.name_suffix}"
  organization         = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags                 = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Device Connector Policy
# GUI Location: Policies > Create Policy > Device Connector
#__________________________________________________________________

module "device_connector" {
  source  = "terraform-cisco-modules/policies-device-connector/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "device_connector", []) : v.name => v if lookup(
      local.modules.policies, "device_connector", true
    )
  }
  configuration_lockout = lookup(
    each.value, "configuration_lockout", local.defaults.intersight.policies.device_connector.configuration_lockout
  )
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.device_connector.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Ethernet Adapter Policy
# GUI Location: Policies > Create Policy > Ethernet Adapter
#__________________________________________________________________

module "ethernet_adapter" {
  source  = "terraform-cisco-modules/policies-ethernet-adapter/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_adapter", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_adapter", true
    )
  }
  completion_queue_count                   = lookup(each.value, "completion_queue_count", local.defaults.intersight.policies.ethernet_adapter.completion_queue_count)
  completion_ring_size                     = lookup(each.value, "completion_ring_size", local.defaults.intersight.policies.ethernet_adapter.completion_ring_size)
  description                              = lookup(each.value, "description", "")
  enable_accelerated_receive_flow_steering = lookup(each.value, "enable_accelerated_receive_flow_steering", local.defaults.intersight.policies.ethernet_adapter.enable_accelerated_receive_flow_steering)
  enable_advanced_filter                   = lookup(each.value, "enable_advanced_filter", local.defaults.intersight.policies.ethernet_adapter.enable_advanced_filter)
  enable_geneve_offload                    = lookup(each.value, "enable_geneve_offload", local.defaults.intersight.policies.ethernet_adapter.enable_geneve_offload)
  enable_interrupt_scaling                 = lookup(each.value, "enable_interrupt_scaling", local.defaults.intersight.policies.ethernet_adapter.enable_interrupt_scaling)
  enable_nvgre_offload                     = lookup(each.value, "enable_nvgre_offload", local.defaults.intersight.policies.ethernet_adapter.enable_nvgre_offload)
  enable_vxlan_offload                     = lookup(each.value, "enable_vxlan_offload", local.defaults.intersight.policies.ethernet_adapter.enable_vxlan_offload)
  interrupt_coalescing_type                = lookup(each.value, "interrupt_coalescing_type", local.defaults.intersight.policies.ethernet_adapter.interrupt_coalescing_type)
  interrupt_mode                           = lookup(each.value, "interrupt_mode", local.defaults.intersight.policies.ethernet_adapter.interrupt_mode)
  interrupt_timer                          = lookup(each.value, "interrupt_timer", local.defaults.intersight.policies.ethernet_adapter.interrupt_timer)
  interrupts                               = lookup(each.value, "interrupts", local.defaults.intersight.policies.ethernet_adapter.interrupts)
  name                                     = "${each.value.name}${local.defaults.intersight.policies.ethernet_adapter.name_suffix}"
  organization                             = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  receive_side_scaling_enable              = lookup(each.value, "receive_side_scaling_enable", local.defaults.intersight.policies.ethernet_adapter.receive_side_scaling_enable)
  roce_cos                                 = lookup(each.value, "roce_cos", local.defaults.intersight.policies.ethernet_adapter.roce_cos)
  roce_enable                              = lookup(each.value, "roce_enable", local.defaults.intersight.policies.ethernet_adapter.roce_enable)
  roce_memory_regions                      = lookup(each.value, "roce_memory_regions", local.defaults.intersight.policies.ethernet_adapter.roce_memory_regions)
  roce_queue_pairs                         = lookup(each.value, "roce_queue_pairs", local.defaults.intersight.policies.ethernet_adapter.roce_queue_pairs)
  roce_resource_groups                     = lookup(each.value, "roce_resource_groups", local.defaults.intersight.policies.ethernet_adapter.roce_resource_groups)
  roce_version                             = lookup(each.value, "roce_version", local.defaults.intersight.policies.ethernet_adapter.roce_version)
  rss_enable_ipv4_hash                     = lookup(each.value, "rss_enable_ipv4_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_ipv4_hash)
  rss_enable_ipv6_extensions_hash          = lookup(each.value, "rss_enable_ipv6_extensions_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_ipv6_extensions_hash)
  rss_enable_ipv6_hash                     = lookup(each.value, "rss_enable_ipv6_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_ipv6_hash)
  rss_enable_tcp_and_ipv4_hash             = lookup(each.value, "rss_enable_tcp_and_ipv4_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_tcp_and_ipv4_hash)
  rss_enable_tcp_and_ipv6_extensions_hash  = lookup(each.value, "rss_enable_tcp_and_ipv6_extensions_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_tcp_and_ipv6_extensions_hash)
  rss_enable_tcp_and_ipv6_hash             = lookup(each.value, "rss_enable_tcp_and_ipv6_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_tcp_and_ipv6_hash)
  rss_enable_udp_and_ipv4_hash             = lookup(each.value, "rss_enable_udp_and_ipv4_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_udp_and_ipv4_hash)
  rss_enable_udp_and_ipv6_hash             = lookup(each.value, "rss_enable_udp_and_ipv6_hash", local.defaults.intersight.policies.ethernet_adapter.rss_enable_udp_and_ipv6_hash)
  receive_queue_count                      = lookup(each.value, "receive_queue_count", local.defaults.intersight.policies.ethernet_adapter.receive_queue_count)
  receive_ring_size                        = lookup(each.value, "receive_ring_size", local.defaults.intersight.policies.ethernet_adapter.receive_ring_size)
  tags                                     = lookup(each.value, "tags", local.defaults.intersight.tags)
  tcp_offload_large_recieve                = lookup(each.value, "tcp_offload_large_recieve", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_large_recieve)
  tcp_offload_large_send                   = lookup(each.value, "tcp_offload_large_send", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_large_send)
  tcp_offload_rx_checksum                  = lookup(each.value, "tcp_offload_rx_checksum", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_rx_checksum)
  tcp_offload_tx_checksum                  = lookup(each.value, "tcp_offload_tx_checksum", local.defaults.intersight.policies.ethernet_adapter.tcp_offload_tx_checksum)
  transmit_queue_count                     = lookup(each.value, "transmit_queue_count", local.defaults.intersight.policies.ethernet_adapter.transmit_queue_count)
  transmit_ring_size                       = lookup(each.value, "transmit_ring_size", local.defaults.intersight.policies.ethernet_adapter.transmit_ring_size)
  uplink_failback_timeout                  = lookup(each.value, "uplink_failback_timeout", local.defaults.intersight.policies.ethernet_adapter.uplink_failback_timeout)
}


#__________________________________________________________________
#
# Intersight Ethernet Network Policy
# GUI Location: Policies > Create Policy > Ethernet Network
#__________________________________________________________________

module "ethernet_network" {
  source  = "terraform-cisco-modules/policies-ethernet-network/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "ethernet_network", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_network", true
    )
  }
  default_vlan = lookup(each.value, "default_vlan", local.defaults.intersight.policies.ethernet_network.default_vlan)
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.ethernet_network.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  vlan_mode    = lookup(each.value, "vlan_mode", local.defaults.intersight.policies.ethernet_network.vlan_mode)
}


#__________________________________________________________________
#
# Intersight Ethernet Network Control Policy
# GUI Location: Policies > Create Policy > Ethernet Network Control
#__________________________________________________________________

module "ethernet_network_control" {
  source  = "terraform-cisco-modules/policies-ethernet-network-control/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_network_control", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_network_control", true
    )
  }
  action_on_uplink_fail = lookup(
    each.value, "action_on_uplink_fail", local.defaults.intersight.policies.ethernet_network_control.action_on_uplink_fail
  )
  cdp_enable = lookup(
    each.value, "cdp_enable", local.defaults.intersight.policies.ethernet_network_control.cdp_enable
  )
  description = lookup(each.value, "description", "")
  lldp_enable_receive = lookup(
    each.value, "lldp_enable_receive", local.defaults.intersight.policies.ethernet_network_control.lldp_enable_receive
  )
  lldp_enable_transmit = lookup(
    each.value, "lldp_enable_transmit", local.defaults.intersight.policies.ethernet_network_control.lldp_enable_transmit
  )
  mac_register_mode = lookup(
    each.value, "mac_register_mode", local.defaults.intersight.policies.ethernet_network_control.mac_register_mode
  )
  mac_security_forge = lookup(
    each.value, "mac_security_forge", local.defaults.intersight.policies.ethernet_network_control.mac_security_forge
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.ethernet_network_control.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Ethernet Network Group Policy
# GUI Location: Policies > Create Policy > Ethernet Network Group
#__________________________________________________________________

module "ethernet_network_group" {
  source  = "terraform-cisco-modules/policies-ethernet-network-group/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_network_group", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_network_group", true
    )
  }
  allowed_vlans = each.value.allowed_vlans
  description   = lookup(each.value, "description", "")
  name          = "${each.value.name}${local.defaults.intersight.policies.ethernet_network_group.name_suffix}"
  native_vlan   = lookup(each.value, "native_vlan", null)
  organization  = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags          = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Ethernet QoS Policy
# GUI Location: Policies > Create Policy > Ethernet QoS
#__________________________________________________________________

module "ethernet_qos" {
  source  = "terraform-cisco-modules/policies-ethernet-qos/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ethernet_qos", []) : v.name => v if lookup(
      local.modules.policies, "ethernet_qos", true
    )
  }
  burst                 = lookup(each.value, "burst", local.defaults.intersight.policies.ethernet_qos.burst)
  cos                   = lookup(each.value, "cos", local.defaults.intersight.policies.ethernet_qos.cos)
  description           = lookup(each.value, "description", "")
  enable_trust_host_cos = lookup(each.value, "enable_trust_host_cos", local.defaults.intersight.policies.ethernet_qos.enable_trust_host_cos)
  mtu                   = lookup(each.value, "mtu", local.defaults.intersight.policies.ethernet_qos.mtu)
  name                  = "${each.value.name}${local.defaults.intersight.policies.ethernet_qos.name_suffix}"
  organization          = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  priority              = lookup(each.value, "priority", local.defaults.intersight.policies.ethernet_qos.priority)
  rate_limit            = lookup(each.value, "rate_limit", local.defaults.intersight.policies.ethernet_qos.rate_limit)
  tags                  = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight FC Zone Policies
# GUI Location: Configure > Policies > Create Policy > FC Zone
#__________________________________________________________________

module "fc_zone" {
  source  = "terraform-cisco-modules/policies-fc-zone/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fc_zone", []) : v.name => v if lookup(
      local.modules.policies, "fc_zone", true
    )
  }
  fc_target_zoning_type = lookup(
    each.value, "fc_target_zoning_type", local.defaults.intersight.policies.fc_zone.fc_target_zoning_type
  )
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.fc_zone.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  targets      = lookup(each.value, "targets", [])
}


#__________________________________________________________________
#
# Intersight Fibre Channel Adapter Policy
# GUI Location: Policies > Create Policy > Fibre Channel Adapter
#__________________________________________________________________

module "fibre_channel_adapter" {
  source  = "terraform-cisco-modules/policies-fibre-channel-adapter/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fibre_channel_adapter", []) : v.name => v if lookup(
      local.modules.policies, "fibre_channel_adapter", true
    )
  }
  adapter_template                  = lookup(each.value, "adapter_template", "")
  description                       = lookup(each.value, "description", "")
  error_detection_timeout           = lookup(each.value, "error_detection_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_detection_timeout)
  enable_fcp_error_recovery         = lookup(each.value, "enable_fcp_error_recovery", local.defaults.intersight.policies.fibre_channel_adapter.enable_fcp_error_recovery)
  error_recovery_io_retry_timeout   = lookup(each.value, "error_recovery_io_retry_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_io_retry_timeout)
  error_recovery_link_down_timeout  = lookup(each.value, "error_recovery_link_down_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_link_down_timeout)
  error_recovery_port_down_io_retry = lookup(each.value, "error_recovery_port_down_io_retry", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_port_down_io_retry)
  error_recovery_port_down_timeout  = lookup(each.value, "error_recovery_port_down_timeout", local.defaults.intersight.policies.fibre_channel_adapter.error_recovery_port_down_timeout)
  flogi_retries                     = lookup(each.value, "flogi_retries", local.defaults.intersight.policies.fibre_channel_adapter.flogi_retries)
  flogi_timeout                     = lookup(each.value, "flogi_timeout", local.defaults.intersight.policies.fibre_channel_adapter.flogi_timeout)
  interrupt_mode                    = lookup(each.value, "interrupt_mode", local.defaults.intersight.policies.fibre_channel_adapter.interrupt_mode)
  io_throttle_count                 = lookup(each.value, "io_throttle_count", local.defaults.intersight.policies.fibre_channel_adapter.io_throttle_count)
  lun_queue_depth                   = lookup(each.value, "lun_queue_depth", local.defaults.intersight.policies.fibre_channel_adapter.lun_queue_depth)
  max_luns_per_target               = lookup(each.value, "max_luns_per_target", local.defaults.intersight.policies.fibre_channel_adapter.max_luns_per_target)
  name                              = "${each.value.name}${local.defaults.intersight.policies.fibre_channel_adapter.name_suffix}"
  organization                      = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  plogi_retries                     = lookup(each.value, "plogi_retries", local.defaults.intersight.policies.fibre_channel_adapter.plogi_retries)
  plogi_timeout                     = lookup(each.value, "plogi_timeout", local.defaults.intersight.policies.fibre_channel_adapter.plogi_timeout)
  receive_ring_size                 = lookup(each.value, "receive_ring_size", local.defaults.intersight.policies.fibre_channel_adapter.receive_ring_size)
  resource_allocation_timeout       = lookup(each.value, "resource_allocation_timeout", local.defaults.intersight.policies.fibre_channel_adapter.resource_allocation_timeout)
  scsi_io_queue_count               = lookup(each.value, "scsi_io_queue_count", local.defaults.intersight.policies.fibre_channel_adapter.scsi_io_queue_count)
  scsi_io_ring_size                 = lookup(each.value, "scsi_io_ring_size", local.defaults.intersight.policies.fibre_channel_adapter.scsi_io_ring_size)
  tags                              = lookup(each.value, "tags", local.defaults.intersight.tags)
  transmit_ring_size                = lookup(each.value, "transmit_ring_size", local.defaults.intersight.policies.fibre_channel_adapter.transmit_ring_size)
}


#__________________________________________________________________
#
# Intersight Fibre Channel Network Policy
# GUI Location: Policies > Create Policy > Fibre Channel Network
#__________________________________________________________________

module "fibre_channel_network" {
  source  = "terraform-cisco-modules/policies-fibre-channel-network/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fibre_channel_network", []) : v.name => v if lookup(
      local.modules.policies, "fibre_channel_network", true
    )
  }
  default_vlan_id = lookup(
    each.value, "default_vlan_id", local.defaults.intersight.policies.fibre_channel_network.default_vlan_id
  )
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.fibre_channel_network.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  vsan_id      = each.value.vsan_id
}


#__________________________________________________________________
#
# Intersight Fibre Channel QoS Policy
# GUI Location: Policies > Create Policy > Fibre Channel QoS
#__________________________________________________________________

module "fibre_channel_qos" {
  source  = "terraform-cisco-modules/policies-fibre-channel-qos/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "fibre_channel_qos", []) : v.name => v if lookup(
      local.modules.policies, "fibre_channel_qos", true
    )
  }
  burst       = lookup(each.value, "burst", local.defaults.intersight.policies.fibre_channel_qos.burst)
  cos         = lookup(each.value, "cos", local.defaults.intersight.policies.fibre_channel_qos.cos)
  description = lookup(each.value, "description", "")
  max_data_field_size = lookup(
    each.value, "max_data_field_size", local.defaults.intersight.policies.fibre_channel_qos.max_data_field_size
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.fibre_channel_qos.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  rate_limit   = lookup(each.value, "rate_limit", local.defaults.intersight.policies.fibre_channel_qos.rate_limit)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Flow Control Policy
# GUI Location: Policies > Create Policy > Flow Control
#__________________________________________________________________

module "flow_control" {
  source  = "terraform-cisco-modules/policies-flow-control/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "flow_control", []) : v.name => v if lookup(
      local.modules.policies, "flow_control", true
    )
  }
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.flow_control.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  priority     = lookup(each.value, "priority", local.defaults.intersight.policies.flow_control.priority)
  receive      = lookup(each.value, "receive", local.defaults.intersight.policies.flow_control.receive)
  send         = lookup(each.value, "send", local.defaults.intersight.policies.flow_control.send)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight IMC Access Policy
# GUI Location: Policies > Create Policy > IMC Access
#__________________________________________________________________

module "imc_access" {
  source  = "terraform-cisco-modules/policies-imc-access/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "imc_access", []) : v.name => v if lookup(
      local.modules.policies, "imc_access", true
    )
  }
  description    = lookup(each.value, "description", "")
  inband_ip_pool = lookup(each.value, "inband_ip_pool", "")
  inband_vlan_id = lookup(
  each.value, "inband_vlan_id", local.defaults.intersight.policies.imc_access.inband_vlan_id)
  ipv4_address_configuration = lookup(
  each.value, "ipv4_address_configuration", local.defaults.intersight.policies.imc_access.ipv4_address_configuration)
  ipv6_address_configuration = lookup(
  each.value, "ipv6_address_configuration", local.defaults.intersight.policies.imc_access.ipv6_address_configuration)
  moids               = true
  name                = "${each.value.name}${local.defaults.intersight.policies.imc_access.name_suffix}"
  organization        = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  out_of_band_ip_pool = lookup(each.value, "out_of_band_ip_pool", "")
  pools               = local.pools
  tags                = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#____________________________________________________________________
#
# Intersight IPMI over LAN Policy
# GUI Location: Configure > Policies > Create Policy > IPMI over LAN
#____________________________________________________________________

module "ipmi_over_lan" {
  source  = "terraform-cisco-modules/policies-ipmi-over-lan/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "ipmi_over_lan", []) : v.name => v if lookup(
      local.modules.policies, "ipmi_over_lan", true
    )
  }
  description  = lookup(each.value, "description", "")
  enabled      = lookup(each.value, "enabled", local.defaults.intersight.policies.ipmi_over_lan.enabled)
  ipmi_key     = lookup(each.value, "ipmi_key", null)
  ipmi_key_1   = var.ipmi_key_1
  name         = "${each.value.name}${local.defaults.intersight.policies.ipmi_over_lan.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  privilege    = lookup(each.value, "privilege", local.defaults.intersight.policies.ipmi_over_lan.privilege)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight iSCSI Adapter Policy
# GUI Location: Policies > Create Policy > iSCSI Adapter
#__________________________________________________________________

module "iscsi_adapter" {
  source  = "terraform-cisco-modules/policies-iscsi-adapter/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "iscsi_adapter", []) : v.name => v if lookup(
      local.modules.policies, "iscsi_adapter", true
    )
  }
  description  = lookup(each.value, "description", "")
  dhcp_timeout = lookup(each.value, "dhcp_timeout", local.defaults.intersight.policies.iscsi_adapter.dhcp_timeout)
  lun_busy_retry_count = lookup(
    each.value, "lun_busy_retry_count", local.defaults.intersight.policies.iscsi_adapter.lun_busy_retry_count
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  tcp_connection_timeout = lookup(
    each.value, "tcp_connection_timeout", local.defaults.intersight.policies.iscsi_adapter.tcp_connection_timeout
  )
}


#__________________________________________________________________
#
# Intersight iSCSI Boot QoS Policy
# GUI Location: Policies > Create Policy > iSCSI Boot
#__________________________________________________________________

module "iscsi_boot" {
  depends_on = [
    module.iscsi_adapter,
    module.iscsi_static_target
  ]
  source  = "terraform-cisco-modules/policies-iscsi-boot/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "iscsi_boot", []) : v.name => v if lookup(
      local.modules.policies, "iscsi_boot", true
    )
  }
  authentication = lookup(
    each.value, "authentication", local.defaults.intersight.policies.iscsi_boot.authentication
  )
  description = lookup(each.value, "description", "")
  dhcp_vendor_id_iqn = lookup(
    each.value, "dhcp_vendor_id_iqn", local.defaults.intersight.policies.iscsi_boot.dhcp_vendor_id_iqn
  )
  initiator_ip_pool = length(
    compact([each.value.initiator_ip_pool])
  ) > 0 ? local.pools.ip[each.value.initiator_ip_pool].moid : ""
  initiator_ip_source = lookup(
    each.value, "initiator_ip_source", local.defaults.intersight.policies.iscsi_boot.initiator_ip_source
  )
  initiator_static_ip_v4_config = lookup(
    each.value, "initiator_static_ip_v4_config", []
  )
  iscsi_adapter_policy = length(compact([each.value.iscsi_adapter_policy])
  ) > 0 ? module.iscsi_adapter[each.value.iscsi_adapter_policy].moid : ""
  iscsi_boot_password = var.iscsi_boot_password
  name                = "${each.value.name}${local.defaults.intersight.policies.ethernet_qos.name_suffix}"
  organization        = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  primary_target_policy = length(
    compact([each.value.primary_target_policy])
  ) > 0 ? module.iscsi_static_target[each.value.primary_target_policy].moid : ""
  secondary_target_policy = length(
    compact([each.value.secondary_target_policy])
  ) > 0 ? module.iscsi_static_target[each.value.secondary_target_policy].moid : ""
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_source_type = lookup(
    each.value, "target_source_type", local.defaults.intersight.policies.iscsi_boot.target_source_type
  )
  username = lookup(each.value, "username", "")
}


#__________________________________________________________________
#
# Intersight iSCSI Static Target Policy
# GUI Location: Policies > Create Policy > iSCSI Static Target
#__________________________________________________________________

module "iscsi_static_target" {
  source  = "terraform-cisco-modules/policies-iscsi-static-target/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "iscsi_static_target", []) : v.name => v if lookup(
      local.modules.policies, "iscsi_static_target", true
    )
  }
  description  = lookup(each.value, "description", "")
  ip_address   = each.value.ip_address
  lun          = lookup(each.value, "lun", [])
  name         = "${each.value.name}${local.defaults.intersight.policies.iscsi_static_target.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  port         = each.value.port
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_name  = each.value.target_name
}


#_________________________________________________________________________
#
# Intersight LAN Connectivity
# GUI Location: Configure > Policies > Create Policy > LAN Connectivity
#_________________________________________________________________________

module "lan_connectivity" {
  depends_on = [
    local.pools,
    module.ethernet_adapter,
    module.ethernet_network,
    module.ethernet_network_control,
    module.ethernet_network_group,
    module.ethernet_qos,
    module.iscsi_boot
  ]
  source  = "terraform-cisco-modules/policies-lan-connectivity/intersight"
  version = ">= 1.0.4"

  for_each = {
    for v in lookup(local.policies, "lan_connectivity", []) : v.name => v if lookup(
      local.modules.policies, "lan_connectivity", true
    )
  }
  description = lookup(each.value, "description", "")
  enable_azure_stack_host_qos = lookup(
    each.value, "enable_azure_stack_host_qos", local.defaults.intersight.policies.lan_connectivity.enable_azure_stack_host_qos
  )
  iqn_allocation_type = lookup(
    each.value, "iqn_allocation_type", local.defaults.intersight.policies.lan_connectivity.iqn_allocation_type
  )
  iqn_pool = length(compact([lookup(each.value, "iqn_pool", "")])) > 0 ? local.pools.iqn[each.value.iqn_pool].moid : ""
  iqn_static_identifier = lookup(
    each.value, "iqn_static_identifier", ""
  )
  moids        = true
  name         = "${each.value.name}${local.defaults.intersight.policies.lan_connectivity.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  pools        = local.pools
  policies = {
    ethernet_adapter         = module.ethernet_adapter,
    ethernet_network         = module.ethernet_network,
    ethernet_network_control = module.ethernet_network_control,
    ethernet_network_group   = module.ethernet_network_group,
    ethernet_qos             = module.ethernet_qos,
    iscsi_boot               = module.iscsi_boot,
  }
  tags            = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_platform = lookup(each.value, "target_platform", local.defaults.intersight.policies.lan_connectivity.target_platform)
  vnic_placement_mode = lookup(
    each.value, "vnic_placement_mode", local.defaults.intersight.policies.lan_connectivity.vnic_placement_mode
  )
  vnics = [
    for v in lookup(each.value, "vnics", []) : {
      cdn_source = lookup(v, "cdn_source", local.defaults.intersight.policies.lan_connectivity.vnics.cdn_source)
      cdn_values = lookup(v, "cdn_values", local.defaults.intersight.policies.lan_connectivity.vnics.cdn_values)
      ethernet_adapter_policy = lookup(
        v, "ethernet_adapter_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_adapter_policy
      )
      ethernet_network_control_policy = lookup(
        v, "ethernet_network_control_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_control_policy
      )
      ethernet_network_group_policy = lookup(
        v, "ethernet_network_group_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_group_policy
      )
      ethernet_network_policy = lookup(
        v, "ethernet_network_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_network_policy
      )
      ethernet_qos_policy = lookup(
        v, "ethernet_qos_policy", local.defaults.intersight.policies.lan_connectivity.vnics.ethernet_qos_policy
      )
      iscsi_boot_policy = lookup(
        v, "iscsi_boot_policy", local.defaults.intersight.policies.lan_connectivity.vnics.iscsi_boot_policy
      )
      mac_address_allocation_type = lookup(
        v, "mac_address_allocation_type", local.defaults.intersight.policies.lan_connectivity.vnics.mac_address_allocation_type
      )
      mac_address_pools  = lookup(v, "mac_address_pools", local.defaults.intersight.policies.lan_connectivity.vnics.mac_address_pools)
      mac_address_static = lookup(v, "mac_address_static", [])
      names              = v.names
      placement_pci_link = lookup(
        v, "placement_pci_link", local.defaults.intersight.policies.lan_connectivity.vnics.placement_pci_link
      )
      placement_pci_order = lookup(
        v, "placement_pci_order", local.defaults.intersight.policies.lan_connectivity.vnics.placement_pci_order
      )
      placement_slot_id = lookup(
        v, "placement_slot_id", local.defaults.intersight.policies.lan_connectivity.vnics.placement_slot_id
      )
      placement_switch_id = lookup(
        v, "placement_switch_id", local.defaults.intersight.policies.lan_connectivity.vnics.placement_switch_id
      )
      placement_uplink_port = lookup(
        v, "placement_uplink_port", local.defaults.intersight.policies.lan_connectivity.vnics.placement_uplink_port
      )
      usnic_adapter_policy = lookup(v, "usnic_adapter_policy", local.defaults.intersight.policies.lan_connectivity.vnics.usnic_adapter_policy)
      usnic_number_of_usnics = lookup(
        v, "usnic_number_of_usnics", local.defaults.intersight.policies.lan_connectivity.vnics.usnic_number_of_usnics
      )
      vmq_enable_virtual_machine_multi_queue = lookup(
        v, "vmq_enable_virtual_machine_multi_queue", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_enable_virtual_machine_multi_queue
      )
      vmq_enabled = lookup(
        v, "vmq_enabled", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_enabled
      )
      vmq_number_of_interrupts = lookup(
        v, "vmq_number_of_interrupts", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_number_of_interrupts
      )
      vmq_number_of_sub_vnics = lookup(
        v, "vmq_number_of_sub_vnics", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_number_of_sub_vnics
      )
      vmq_number_of_virtual_machine_queues = lookup(
        v, "vmq_number_of_virtual_machine_queues", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_number_of_virtual_machine_queues
      )
      vmq_vmmq_adapter_policy = lookup(v, "vmq_vmmq_adapter_policy", local.defaults.intersight.policies.lan_connectivity.vnics.vmq_vmmq_adapter_policy)
    }
  ]
}


#__________________________________________________________________
#
# Intersight LDAP Policy
# GUI Location: Policies > Create Policy > LDAP
#__________________________________________________________________

module "ldap" {
  source  = "terraform-cisco-modules/policies-ldap/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ldap", []) : v.name => v if lookup(
      local.modules.policies, "ldap", true
    )
  }
  base_settings = {
    base_dn = each.value.base_settings.base_dn
    domain  = each.value.base_settings.domain
    timeout = lookup(each.value.base_settings, "timeout", local.defaults.intersight.policies.ldap.base_settings.timeout)
  }
  binding_parameters = {
    bind_dn = lookup(
      each.value.binding_parameters, "bind_dn", local.defaults.intersight.policies.ldap.binding_parameters.bind_dn
    )
    bind_method = lookup(
      each.value.binding_parameters, "timeout", local.defaults.intersight.policies.ldap.binding_parameters.bind_method
    )
  }
  binding_parameters_password = var.binding_parameters_password
  description                 = lookup(each.value, "description", "")
  enable_encryption           = lookup(each.value, "enable_encryption", local.defaults.intersight.policies.ldap.enable_encryption)
  enable_group_authorization = lookup(
    each.value, "enable_group_authorization", local.defaults.intersight.policies.ldap.enable_group_authorization
  )
  enable_ldap = lookup(each.value, "enable_ldap", local.defaults.intersight.policies.ldap.enable_ldap)
  ldap_from_dns = {
    enable = lookup(
      each.value.ldap_from_dns, "enable", local.defaults.intersight.policies.ldap.ldap_from_dns.enable
    )
    search_domain = lookup(
      each.value.ldap_from_dns, "search_domain", local.defaults.intersight.policies.ldap.ldap_from_dns.search_domain
    )
    search_forest = lookup(
      each.value.ldap_from_dns, "search_forest", local.defaults.intersight.policies.ldap.ldap_from_dns.search_forest
    )
    source = lookup(
      each.value.ldap_from_dns, "source", local.defaults.intersight.policies.ldap.ldap_from_dns.source
    )
  }
  ldap_groups  = lookup(each.value, "ldap_groups", [])
  ldap_servers = lookup(each.value, "ldap_servers", [])
  name         = "${each.value.name}${local.defaults.intersight.policies.ldap.name_suffix}"
  nested_group_search_depth = lookup(
    each.value, "nested_group_search_depth", local.defaults.intersight.policies.ldap.nested_group_search_depth
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  search_parameters = {
    attribute = lookup(
      each.value.search_parameters, "attribute", local.defaults.intersight.policies.ldap.search_parameters.attribute
    )
    filter = lookup(
      each.value.search_parameters, "filter", local.defaults.intersight.policies.ldap.search_parameters.filter
    )
    group_attribute = lookup(
      each.value.search_parameters, "group_attribute", local.defaults.intersight.policies.ldap.search_parameters.group_attribute
    )
  }
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  user_search_precedence = lookup(
    each.value, "user_search_precedence", local.defaults.intersight.policies.ldap.user_search_precedence
  )
}


#__________________________________________________________________
#
# Intersight Link Aggregation Policy
# GUI Location: Policies > Create Policy > Link Aggregation
#__________________________________________________________________

module "link_aggregation" {
  source  = "terraform-cisco-modules/policies-link-aggregation/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "link_aggregation", []) : v.name => v if lookup(
      local.modules.policies, "link_aggregation", true
    )
  }
  description  = lookup(each.value, "description", "")
  lacp_rate    = lookup(each.value, "lacp_rate", local.defaults.intersight.policies.link_aggregation.lacp_rate)
  name         = "${each.value.name}${local.defaults.intersight.policies.link_aggregation.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  suspend_individual = lookup(
    each.value, "suspend_individual", local.defaults.intersight.policies.link_aggregation.suspend_individual
  )
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Link Control Policy
# GUI Location: Policies > Create Policy > Link Control
#__________________________________________________________________

module "link_control" {
  source  = "terraform-cisco-modules/policies-link-control/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "link_control", []) : v.name => v if lookup(
      local.modules.policies, "link_control", true
    )
  }
  admin_state  = lookup(each.value, "admin_state", local.defaults.intersight.policies.link_control.admin_state)
  description  = lookup(each.value, "description", "")
  mode         = lookup(each.value, "mode", local.defaults.intersight.policies.link_control.mode)
  name         = "${each.value.name}${local.defaults.intersight.policies.link_control.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Local User Policy
# GUI Location: Policies > Create Policy > Local User
#__________________________________________________________________

module "local_user" {
  source  = "terraform-cisco-modules/policies-local-user/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "local_user", []) : v.name => v if lookup(
      local.modules.policies, "local_user", true
    )
  }
  always_send_user_password = lookup(
    each.value, "always_send_user_password", local.defaults.intersight.policies.local_user.always_send_user_password
  )
  description = lookup(each.value, "description", "")
  enable_password_expiry = lookup(
    each.value, "enable_password_expiry", local.defaults.intersight.policies.local_user.enable_password_expiry
  )
  enforce_strong_password = lookup(
    each.value, "enforce_strong_password", local.defaults.intersight.policies.local_user.enforce_strong_password
  )
  grace_period          = lookup(each.value, "grace_period", local.defaults.intersight.policies.local_user.grace_period)
  local_user_password_1 = var.local_user_password_1
  local_user_password_2 = var.local_user_password_2
  local_user_password_3 = var.local_user_password_3
  local_user_password_4 = var.local_user_password_4
  local_user_password_5 = var.local_user_password_5
  name                  = "${each.value.name}${local.defaults.intersight.policies.local_user.name_suffix}"
  notification_period = lookup(
    each.value, "notification_period", local.defaults.intersight.policies.local_user.notification_period
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  password_expiry_duration = lookup(
    each.value, "password_expiry_duration", local.defaults.intersight.policies.local_user.password_expiry_duration
  )
  password_history = lookup(
    each.value, "password_history", local.defaults.intersight.policies.local_user.password_history
  )
  tags  = lookup(each.value, "tags", local.defaults.intersight.tags)
  users = lookup(each.value, "users", [])
}


#__________________________________________________________________
#
# Intersight Multicast Policy
# GUI Location: Policies > Create Policy > Multicast
#__________________________________________________________________

module "multicast" {
  source  = "terraform-cisco-modules/policies-multicast/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "multicast", []) : v.name => v if lookup(
      local.modules.policies, "multicast", true
    )
  }
  description  = lookup(each.value, "description", "")
  name         = "${each.value.name}${local.defaults.intersight.policies.multicast.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  querier_ip_address = lookup(
    each.value, "querier_ip_address", local.defaults.intersight.policies.multicast.querier_ip_address
  )
  querier_ip_address_peer = lookup(
    each.value, "querier_ip_address_peer", local.defaults.intersight.policies.multicast.querier_ip_address_peer
  )
  querier_state  = lookup(each.value, "querier_state", local.defaults.intersight.policies.multicast.querier_state)
  snooping_state = lookup(each.value, "snooping_state", local.defaults.intersight.policies.multicast.snooping_state)
  tags           = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#__________________________________________________________________
#
# Intersight Network Connectivity Policy
# GUI Location: Policies > Create Policy > Network Connectivity
#__________________________________________________________________

module "network_connectivity" {
  source  = "terraform-cisco-modules/policies-network-connectivity/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "network_connectivity", []) : v.name => v if lookup(
      local.modules.policies, "network_connectivity", true
    )
  }
  description     = lookup(each.value, "description", "")
  domain_profiles = local.domains
  dns_servers_v4 = lookup(
    each.value, "dns_servers_v4", local.defaults.intersight.policies.network_connectivity.dns_servers_v4
  )
  dns_servers_v6 = lookup(
    each.value, "dns_servers_v6", local.defaults.intersight.policies.network_connectivity.dns_servers_v6
  )
  enable_dynamic_dns = lookup(
    each.value, "enable_dynamic_dns", local.defaults.intersight.policies.network_connectivity.enable_dynamic_dns
  )
  enable_ipv6 = lookup(
    each.value, "enable_ipv6", local.defaults.intersight.policies.network_connectivity.enable_ipv6
  )
  moids = true
  name  = "${each.value.name}${local.defaults.intersight.policies.network_connectivity.name_suffix}"
  obtain_ipv4_dns_from_dhcp = lookup(
    each.value, "obtain_ipv4_dns_from_dhcp", local.defaults.intersight.policies.network_connectivity.obtain_ipv4_dns_from_dhcp
  )
  obtain_ipv6_dns_from_dhcp = lookup(
    each.value, "obtain_ipv6_dns_from_dhcp", local.defaults.intersight.policies.network_connectivity.obtain_ipv6_dns_from_dhcp
  )
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.name
      object_type = "fabric.SwitchProfile"
      } if length(regexall("^${each.value.name}$", v.network_connectivity_policy)) > 0 || length(regexall(
      "^${each.value.name}${local.defaults.intersight.policies.network_connectivity.name_suffix}$", v.network_connectivity_policy)
    ) > 0
  ]
  tags          = lookup(each.value, "tags", local.defaults.intersight.tags)
  update_domain = lookup(each.value, "update_domain", local.defaults.intersight.policies.network_connectivity.update_domain)
}


#__________________________________________________________________
#
# Intersight NTP Policy
# GUI Location: Policies > Create Policy > NTP
#__________________________________________________________________

module "ntp" {
  source  = "terraform-cisco-modules/policies-ntp/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "ntp", []) : v.name => v if lookup(
      local.modules.policies, "ntp", true
    )
  }
  description     = lookup(each.value, "description", "")
  domain_profiles = local.domains
  enabled         = lookup(each.value, "enabled", local.defaults.intersight.policies.ntp.enabled)
  moids           = true
  name            = "${each.value.name}${local.defaults.intersight.policies.ntp.name_suffix}"
  ntp_servers     = lookup(each.value, "ntp_servers", local.defaults.intersight.policies.ntp.ntp_servers)
  organization    = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.name
      object_type = "fabric.SwitchProfile"
      } if length(regexall("^${each.value.name}$", v.ntp_policy)) > 0 || length(regexall(
      "^${each.value.name}${local.defaults.intersight.policies.ntp.name_suffix}$", v.ntp_policy)
    ) > 0
  ]
  tags     = lookup(each.value, "tags", local.defaults.intersight.tags)
  timezone = lookup(each.value, "timezone", local.defaults.intersight.policies.ntp.timezone)
}


#__________________________________________________________________
#
# Intersight Port Policy
# GUI Location: Policies > Create Policy > Port
#__________________________________________________________________

module "port" {
  depends_on = [
    module.ethernet_network_control,
    module.ethernet_network_group,
    module.flow_control,
    module.link_aggregation,
    module.link_control
  ]
  source  = "terraform-cisco-modules/policies-port/intersight"
  version = ">= 1.0.4"

  for_each        = { for v in local.port : v.name => v }
  description     = each.value.description
  device_model    = each.value.device_model
  domain_profiles = local.domains
  moids           = true
  name            = each.value.name
  organization    = each.value.organization
  policies = {
    ethernet_network_control = module.ethernet_network_control,
    ethernet_network_group   = module.ethernet_network_group,
    flow_control             = module.flow_control,
    link_aggregation         = module.link_aggregation,
    link_control             = module.link_control,
  }
  port_channel_appliances       = each.value.port_channel_appliances
  port_channel_ethernet_uplinks = each.value.port_channel_ethernet_uplinks
  port_channel_fc_uplinks       = each.value.port_channel_fc_uplinks
  port_channel_fcoe_uplinks     = each.value.port_channel_fcoe_uplinks
  port_modes                    = each.value.port_modes
  port_role_appliances          = each.value.port_role_appliances
  port_role_ethernet_uplinks    = each.value.port_role_ethernet_uplinks
  port_role_fc_storage          = each.value.port_role_fc_storage
  port_role_fc_uplinks          = each.value.port_role_fc_uplinks
  port_role_fcoe_uplinks        = each.value.port_role_fcoe_uplinks
  port_role_servers             = each.value.port_role_servers
  profiles                      = each.value.profiles
  tags                          = each.value.tags
}


#__________________________________________________________________
#
# Intersight Power Policy
# GUI Location: Policies > Create Policy > Power
#__________________________________________________________________

module "power" {
  source  = "terraform-cisco-modules/policies-power/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "power", []) : v.name => v if lookup(
      local.modules.policies, "power", true
    )
  }
  description = lookup(each.value, "description", "")
  dynamic_power_rebalancing = lookup(
    each.value, "dynamic_power_rebalancing", local.defaults.intersight.policies.power.dynamic_power_rebalancing
  )
  name             = "${each.value.name}${local.defaults.intersight.policies.power.name_suffix}"
  organization     = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  power_allocation = lookup(each.value, "power_allocation", local.defaults.intersight.policies.power.power_allocation)
  power_priority   = lookup(each.value, "power_priority", local.defaults.intersight.policies.power.power_priority)
  power_profiling  = lookup(each.value, "power_profiling", local.defaults.intersight.policies.power.power_profiling)
  power_redunancy  = lookup(each.value, "power_redunancy", local.defaults.intersight.policies.power.power_redunancy)
  power_restore    = lookup(each.value, "power_restore", local.defaults.intersight.policies.power.power_restore)
  power_save_mode  = lookup(each.value, "power_save_mode", local.defaults.intersight.policies.power.power_save_mode)
  tags             = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight SAN Connectivity
# GUI Location: Configure > Policies > Create Policy > SAN Connectivity
#_________________________________________________________________________

module "san_connectivity" {
  depends_on = [
    module.fc_zone,
    module.fibre_channel_adapter,
    module.fibre_channel_network,
    module.fibre_channel_qos
  ]
  source  = "terraform-cisco-modules/policies-san-connectivity/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "san_connectivity", []) : v.name => v if lookup(
      local.modules.policies, "san_connectivity", true
    )
  }
  description  = lookup(each.value, "description", "")
  moids        = true
  name         = "${each.value.name}${local.defaults.intersight.policies.san_connectivity.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  policies = {
    fc_zone               = module.fc_zone,
    fibre_channel_adapter = module.fibre_channel_adapter,
    fibre_channel_network = module.fibre_channel_network,
    fibre_channel_qos     = module.fibre_channel_qos,
  }
  pools               = local.pools
  tags                = lookup(each.value, "tags", local.defaults.intersight.tags)
  target_platform     = lookup(each.value, "target_platform", local.defaults.intersight.policies.san_connectivity.target_platform)
  vhba_placement_mode = lookup(each.value, "vhba_placement_mode", local.defaults.intersight.policies.san_connectivity.vhba_placement_mode)
  vhbas = [
    for v in lookup(each.value, "vhbas", []) : {
      fc_zone_policies = lookup(
        v, "fc_zone_policies", local.defaults.intersight.policies.san_connectivity.vhbas.fc_zone_policies
      )
      fibre_channel_adapter_policy = lookup(
        v, "fibre_channel_adapter_policy", local.defaults.intersight.policies.san_connectivity.vhbas.fibre_channel_adapter_policy
      )
      fibre_channel_network_policies = lookup(
        v, "fibre_channel_network_policies", local.defaults.intersight.policies.san_connectivity.vhbas.fibre_channel_network_policies
      )
      fibre_channel_qos_policy = lookup(
        v, "fibre_channel_qos_policy", local.defaults.intersight.policies.san_connectivity.vhbas.fibre_channel_qos_policy
      )
      names = v.names
      persistent_lun_bindings = lookup(
        v, "persistent_lun_bindings", local.defaults.intersight.policies.san_connectivity.vhbas.persistent_lun_bindings
      )
      placement_pci_link = lookup(
        v, "placement_pci_link", local.defaults.intersight.policies.san_connectivity.vhbas.placement_pci_link
      )
      placement_pci_order = lookup(
        v, "placement_pci_order", local.defaults.intersight.policies.san_connectivity.vhbas.placement_pci_order
      )
      placement_slot_id = lookup(
        v, "placement_slot_id", local.defaults.intersight.policies.san_connectivity.vhbas.placement_slot_id
      )
      placement_switch_id = lookup(
        v, "placement_switch_id", local.defaults.intersight.policies.san_connectivity.vhbas.placement_switch_id
      )
      placement_uplink_port = lookup(
        v, "placement_uplink_port", local.defaults.intersight.policies.san_connectivity.vhbas.placement_uplink_port
      )
      vhba_type = lookup(
        v, "vhba_type", local.defaults.intersight.policies.san_connectivity.vhbas.vhba_type
      )
      wwpn_allocation_type = lookup(
        v, "wwpn_allocation_type", local.defaults.intersight.policies.san_connectivity.vhbas.wwpn_allocation_type
      )
      wwpn_pools          = lookup(v, "wwpn_pools", local.defaults.intersight.policies.san_connectivity.vhbas.wwpn_pools)
      wwpn_static_address = lookup(v, "wwpn_static_address", [])
    }
  ]
  wwnn_allocation_type = lookup(each.value, "wwnn_allocation_type", local.defaults.intersight.policies.san_connectivity.wwnn_allocation_type)
  wwnn_pool            = lookup(each.value, "wwnn_pool", local.defaults.intersight.policies.san_connectivity.wwnn_pool)
  wwnn_static_address  = lookup(each.value, "wwnn_static_address", "")
}


#__________________________________________________________________
#
# Intersight SD Card Policy
# GUI Location: Policies > Create Policy > SD Card
#__________________________________________________________________

module "sd_card" {
  source  = "terraform-cisco-modules/policies-sd-card/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "sd_card", []) : v.name => v if lookup(
      local.modules.policies, "sd_card", true
    )
  }
  description = lookup(each.value, "description", "")
  enable_diagnostics = lookup(
    each.value, "enable_diagnostics", local.defaults.intersight.policies.sd_card.enable_diagnostics
  )
  enable_drivers = lookup(each.value, "enable_drivers", local.defaults.intersight.policies.sd_card.enable_drivers)
  enable_huu     = lookup(each.value, "enable_huu", local.defaults.intersight.policies.sd_card.enable_huu)
  enable_os      = lookup(each.value, "enable_os", local.defaults.intersight.policies.sd_card.enable_os)
  enable_scu     = lookup(each.value, "enable_scu", local.defaults.intersight.policies.sd_card.enable_scu)
  name           = "${each.value.name}${local.defaults.intersight.policies.sd_card.name_suffix}"
  organization   = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags           = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Serial over LAN Policy
# GUI Location: Configure > Policies > Create Policy > Serial over LAN
#_________________________________________________________________________

module "serial_over_lan" {
  source  = "terraform-cisco-modules/policies-serial-over-lan/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "serial_over_lan", []) : v.name => v if lookup(
      local.modules.policies, "serial_over_lan", true
    )
  }
  baud_rate    = lookup(each.value, "baud_rate", local.defaults.intersight.policies.serial_over_lan.baud_rate)
  com_port     = lookup(each.value, "com_port", local.defaults.intersight.policies.serial_over_lan.com_port)
  description  = lookup(each.value, "description", "")
  enabled      = lookup(each.value, "enabled", local.defaults.intersight.policies.serial_over_lan.enabled)
  name         = "${each.value.name}${local.defaults.intersight.policies.serial_over_lan.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  ssh_port     = lookup(each.value, "ssh_port", local.defaults.intersight.policies.serial_over_lan.ssh_port)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight SMTP Policy
# GUI Location: Configure > Policies > Create Policy > SMTP
#_________________________________________________________________________

module "smtp" {
  source  = "terraform-cisco-modules/policies-smtp/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "smtp", []) : v.name => v if lookup(
      local.modules.policies, "smtp", true
    )
  }
  description = lookup(each.value, "description", "")
  enable_smtp = lookup(each.value, "enable_smtp", local.defaults.intersight.policies.smtp.enable_smtp)
  mail_alert_recipients = lookup(
    each.value, "mail_alert_recipients", local.defaults.intersight.policies.smtp.mail_alert_recipients
  )
  minimum_severity = lookup(each.value, "minimum_severity", local.defaults.intersight.policies.smtp.minimum_severity)
  name             = "${each.value.name}${local.defaults.intersight.policies.smtp.name_suffix}"
  organization     = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  smtp_alert_sender_address = lookup(
    each.value, "smtp_alert_sender_address", local.defaults.intersight.policies.smtp.smtp_alert_sender_address
  )
  smtp_port           = lookup(each.value, "smtp_port", local.defaults.intersight.policies.smtp.smtp_port)
  smtp_server_address = each.value.smtp_server_address
  tags                = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight SNNMP Policy
# GUI Location: Configure > Policies > Create Policy > SNMP
#_________________________________________________________________________

module "snmp" {
  source  = "terraform-cisco-modules/policies-snmp/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "snmp", []) : v.name => v if lookup(
      local.modules.policies, "snmp", true
    )
  }
  access_community_string   = lookup(each.value, "access_community_string", 0)
  access_community_string_1 = var.access_community_string_1
  access_community_string_2 = var.access_community_string_2
  access_community_string_3 = var.access_community_string_3
  access_community_string_4 = var.access_community_string_4
  access_community_string_5 = var.access_community_string_5
  description               = lookup(each.value, "description", "")
  domain_profiles           = local.domains
  enable_snmp               = lookup(each.value, "enable_snmp", local.defaults.intersight.policies.snmp.enable_snmp)
  moids                     = true
  name                      = "${each.value.name}${local.defaults.intersight.policies.snmp.name_suffix}"
  organization              = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.name
      object_type = "fabric.SwitchProfile"
      } if length(regexall("^${each.value.name}$", v.snmp_policy)) > 0 || length(regexall(
      "^${each.value.name}${local.defaults.intersight.policies.snmp.name_suffix}$", v.snmp_policy)
    ) > 0
  ]
  snmp_auth_password_1  = var.snmp_auth_password_1
  snmp_auth_password_2  = var.snmp_auth_password_2
  snmp_auth_password_3  = var.snmp_auth_password_3
  snmp_auth_password_4  = var.snmp_auth_password_4
  snmp_auth_password_5  = var.snmp_auth_password_5
  snmp_community_access = lookup(each.value, "snmp_community_access", local.defaults.intersight.policies.snmp.snmp_community_access)
  snmp_engine_input_id = lookup(
    each.value, "snmp_engine_input_id", local.defaults.intersight.policies.snmp.snmp_engine_input_id
  )
  snmp_port               = lookup(each.value, "snmp_port", local.defaults.intersight.policies.snmp.snmp_port)
  snmp_privacy_password_1 = var.snmp_privacy_password_1
  snmp_privacy_password_2 = var.snmp_privacy_password_2
  snmp_privacy_password_3 = var.snmp_privacy_password_3
  snmp_privacy_password_4 = var.snmp_privacy_password_4
  snmp_privacy_password_5 = var.snmp_privacy_password_5
  snmp_trap_community_1   = var.snmp_trap_community_1
  snmp_trap_community_2   = var.snmp_trap_community_2
  snmp_trap_community_3   = var.snmp_trap_community_3
  snmp_trap_community_4   = var.snmp_trap_community_4
  snmp_trap_community_5   = var.snmp_trap_community_5
  snmp_trap_destinations  = lookup(each.value, "snmp_trap_destinations", [])
  snmp_users              = lookup(each.value, "snmp_users", [])
  system_contact          = lookup(each.value, "system_contact", local.defaults.intersight.policies.snmp.system_contact)
  system_location         = lookup(each.value, "system_location", local.defaults.intersight.policies.snmp.system_location)
  tags                    = lookup(each.value, "tags", local.defaults.intersight.tags)
  trap_community_string   = lookup(each.value, "trap_community_string", 0)
}


#_________________________________________________________________________
#
# Intersight SSH Policy
# GUI Location: Configure > Policies > Create Policy > SSH
#_________________________________________________________________________

module "ssh" {
  source  = "terraform-cisco-modules/policies-ssh/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "ssh", []) : v.name => v if lookup(
      local.modules.policies, "ssh", true
    )
  }
  description  = lookup(each.value, "description", "")
  enable_ssh   = lookup(each.value, "enable_ssh", local.defaults.intersight.policies.ssh.enable_ssh)
  name         = "${each.value.name}${local.defaults.intersight.policies.ssh.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  ssh_port     = lookup(each.value, "ssh_port", local.defaults.intersight.policies.ssh.ssh_port)
  ssh_timeout  = lookup(each.value, "ssh_timeout", local.defaults.intersight.policies.ssh.ssh_timeout)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Storage Policy
# GUI Location: Configure > Policies > Create Policy > Storage
#_________________________________________________________________________

module "storage" {
  source  = "terraform-cisco-modules/policies-storage/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "storage", []) : v.name => v if lookup(
      local.modules.policies, "storage", true
    )
  }
  description       = lookup(each.value, "description", "")
  drive_groups      = lookup(each.value, "drive_groups", [])
  global_hot_spares = lookup(each.value, "global_hot_spares", local.defaults.intersight.policies.storage.global_hot_spares)
  m2_configuration  = lookup(each.value, "m2_configuration", [])
  name              = "${each.value.name}${local.defaults.intersight.policies.storage.name_suffix}"
  organization      = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  single_drive_raid_configuration = lookup(
    each.value, "single_drive_raid_configuration", []
  )
  tags               = lookup(each.value, "tags", local.defaults.intersight.tags)
  unused_disks_state = lookup(each.value, "unused_disks_state", local.defaults.intersight.policies.storage.unused_disks_state)
  use_jbod_for_vd_creation = lookup(
    each.value, "use_jbod_for_vd_creation", local.defaults.intersight.policies.storage.use_jbod_for_vd_creation
  )
}


#_________________________________________________________________________
#
# Intersight Switch Control Policy
# GUI Location: Configure > Policies > Create Policy > Switch Control
#_________________________________________________________________________

module "switch_control" {
  source  = "terraform-cisco-modules/policies-switch-control/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "switch_control", []) : v.name => v if lookup(
      local.modules.policies, "switch_control", true
    )
  }
  description     = lookup(each.value, "description", "")
  domain_profiles = local.domains
  ethernet_switching_mode = lookup(
    each.value, "ethernet_switching_mode", local.defaults.intersight.policies.switch_control.ethernet_switching_mode
  )
  fc_switching_mode = lookup(
    each.value, "fc_switching_mode", local.defaults.intersight.policies.switch_control.fc_switching_mode
  )
  mac_address_table_aging = lookup(
    each.value, "mac_address_table_aging", local.defaults.intersight.policies.switch_control.mac_address_table_aging
  )
  mac_aging_time = lookup(each.value, "mac_aging_time", local.defaults.intersight.policies.switch_control.mac_aging_time)
  moids          = true
  name           = "${each.value.name}${local.defaults.intersight.policies.switch_control.name_suffix}"
  organization   = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : v.name if length(regexall(
      "^${each.value.name}$", v.switch_control_policy)) > 0 || length(regexall(
      "^${each.value.name}${local.defaults.intersight.policies.switch_control.name_suffix}$", v.switch_control_policy)
    ) > 0
  ]
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  udld_message_interval = lookup(
    each.value, "udld_message_interval", local.defaults.intersight.policies.switch_control.udld_message_interval
  )
  udld_recovery_action = lookup(
    each.value, "udld_recovery_action", local.defaults.intersight.policies.switch_control.udld_recovery_action
  )
  vlan_port_count_optimization = lookup(
    each.value, "vlan_port_count_optimization", local.defaults.intersight.policies.switch_control.vlan_port_count_optimization
  )
}


#_________________________________________________________________________
#
# Intersight Syslog Policy
# GUI Location: Configure > Policies > Create Policy > Syslog
#_________________________________________________________________________

module "syslog" {
  source  = "terraform-cisco-modules/policies-syslog/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "syslog", []) : v.name => v if lookup(
      local.modules.policies, "syslog", true
    )
  }
  description     = lookup(each.value, "description", "")
  domain_profiles = local.domains
  local_min_severity = lookup(
    each.value, "local_min_severity", local.defaults.intersight.policies.syslog.local_min_severity
  )
  moids        = true
  name         = "${each.value.name}${local.defaults.intersight.policies.syslog.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : {
      name        = v.name
      object_type = "fabric.SwitchProfile"
      } if length(regexall("^${each.value.name}$", v.syslog_policy)) > 0 || length(regexall(
      "^${each.value.name}${local.defaults.intersight.policies.syslog.name_suffix}$", v.syslog_policy)
    ) > 0
  ]
  remote_clients = lookup(each.value, "remote_clients", [])
  tags           = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight System QoS Policy
# GUI Location: Configure > Policies > Create Policy > System QoS
#_________________________________________________________________________

module "system_qos" {
  source  = "terraform-cisco-modules/policies-system-qos/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "system_qos", []) : v.name => v if lookup(
      local.modules.policies, "system_qos", true
    )
  }
  classes         = lookup(each.value, "classes", [])
  description     = lookup(each.value, "description", "")
  domain_profiles = local.domains
  name            = "${each.value.name}${local.defaults.intersight.policies.system_qos.name_suffix}"
  moids           = true
  organization    = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : v.name if length(regexall("^${each.value.name}$", v.system_qos_policy)
    ) > 0 || length(regexall(
      "${each.value.name}${local.defaults.intersight.policies.system_qos.name_suffix}", "^${v.system_qos_policy}$")
    ) > 0
  ]
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Thermal Policy
# GUI Location: Configure > Policies > Create Policy > Thermal
#_________________________________________________________________________

module "thermal" {
  source  = "terraform-cisco-modules/policies-thermal/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "thermal", []) : v.name => v if lookup(
      local.modules.policies, "thermal", true
    )
  }
  description      = lookup(each.value, "description", "")
  fan_control_mode = lookup(each.value, "fan_control_mode", local.defaults.intersight.policies.thermal.fan_control_mode)
  name             = "${each.value.name}${local.defaults.intersight.policies.thermal.name_suffix}"
  organization     = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags             = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Virtual KVM Policy
# GUI Location: Configure > Policies > Create Policy > Virtual KVM
#_________________________________________________________________________

module "virtual_kvm" {
  source  = "terraform-cisco-modules/policies-virtual-kvm/intersight"
  version = ">= 1.0.1"

  for_each = {
    for v in lookup(local.policies, "virtual_kvm", []) : v.name => v if lookup(
      local.modules.policies, "virtual_kvm", true
    )
  }
  allow_tunneled_vkvm = lookup(
    each.value, "allow_tunneled_vkvm", local.defaults.intersight.policies.virtual_kvm.allow_tunneled_vkvm
  )
  description = lookup(each.value, "description", "")
  enable_local_server_video = lookup(
    each.value, "enable_local_server_video", local.defaults.intersight.policies.virtual_kvm.enable_local_server_video
  )
  enable_video_encryption = lookup(
    each.value, "enable_video_encryption", local.defaults.intersight.policies.virtual_kvm.enable_video_encryption
  )
  enable_virtual_kvm = lookup(
    each.value, "enable_virtual_kvm", local.defaults.intersight.policies.virtual_kvm.enable_virtual_kvm
  )
  maximum_sessions = lookup(
    each.value, "maximum_sessions", local.defaults.intersight.policies.virtual_kvm.maximum_sessions
  )
  name         = "${each.value.name}${local.defaults.intersight.policies.virtual_kvm.name_suffix}"
  organization = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  remote_port  = lookup(each.value, "remote_port", local.defaults.intersight.policies.virtual_kvm.remote_port)
  tags         = lookup(each.value, "tags", local.defaults.intersight.tags)
}


#_________________________________________________________________________
#
# Intersight Virtual Media Policy
# GUI Location: Configure > Policies > Create Policy > Virtual Media
#_________________________________________________________________________

module "virtual_media" {
  source  = "terraform-cisco-modules/policies-virtual-media/intersight"
  version = ">= 1.0.2"

  for_each = {
    for v in lookup(local.policies, "virtual_media", []) : v.name => v if lookup(
      local.modules.policies, "virtual_media", true
    )
  }
  add_virtual_media = lookup(each.value, "add_virtual_media", [])
  description       = lookup(each.value, "description", "")
  enable_low_power_usb = lookup(
    each.value, "enable_low_power_usb", local.defaults.intersight.policies.virtual_media.enable_low_power_usb
  )
  enable_virtual_media = lookup(
    each.value, "enable_virtual_media", local.defaults.intersight.policies.virtual_media.enable_virtual_media
  )
  enable_virtual_media_encryption = lookup(
    each.value, "enable_virtual_media_encryption", local.defaults.intersight.policies.virtual_media.enable_virtual_media_encryption
  )
  name              = "${each.value.name}${local.defaults.intersight.policies.virtual_media.name_suffix}"
  organization      = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  tags              = lookup(each.value, "tags", local.defaults.intersight.tags)
  vmedia_password_1 = var.vmedia_password_1
  vmedia_password_2 = var.vmedia_password_2
  vmedia_password_3 = var.vmedia_password_3
  vmedia_password_4 = var.vmedia_password_4
  vmedia_password_5 = var.vmedia_password_5
}


#_________________________________________________________________________
#
# Intersight VLAN Policy
# GUI Location: Configure > Policies > Create Policy > VLAN
#_________________________________________________________________________

module "vlan" {
  depends_on = [
    module.multicast
  ]
  source  = "terraform-cisco-modules/policies-vlan/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "vlan", []) : v.name => v if lookup(
      local.modules.policies, "vlan", true
    )
  }
  description     = lookup(each.value, "description", "")
  domain_profiles = local.domains
  moids           = true
  name            = "${each.value.name}${local.defaults.intersight.policies.vlan.name_suffix}"
  organization    = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  policies = {
    multicast = module.multicast
  }
  profiles = [
    for v in local.domains : v.name if length(regexall("^${each.value.name}$", v.vlan_policy)) > 0 || length(regexall(
      "^${each.value.name}${local.defaults.intersight.policies.vlan.name_suffix}$", v.vlan_policy)
    ) > 0
  ]
  tags = lookup(each.value, "tags", local.defaults.intersight.tags)
  vlans = [
    for v in lookup(each.value, "vlans", []) : {
      auto_allow_on_uplinks = lookup(
        v, "auto_allow_on_uplinks", local.defaults.intersight.policies.vlan.vlans.auto_allow_on_uplinks
      )
      multicast_policy = v.multicast_policy
      name             = lookup(v, "name", "")
      native_vlan      = lookup(v, "native_vlan", local.defaults.intersight.policies.vlan.vlans.native_vlan)
      vlan_list        = v.vlan_list
    }
  ]
}


#_________________________________________________________________________
#
# Intersight VSAN Policy
# GUI Location: Configure > Policies > Create Policy > VSAN
#_________________________________________________________________________

module "vsan" {
  source  = "terraform-cisco-modules/policies-vsan/intersight"
  version = ">= 1.0.3"

  for_each = {
    for v in lookup(local.policies, "vsan", []) : v.name => v if lookup(
      local.modules.policies, "vsan", true
    )
  }
  description     = lookup(each.value, "description", "")
  domain_profiles = local.domains
  moids           = true
  name            = "${each.value.name}${local.defaults.intersight.policies.vsan.name_suffix}"
  organization    = local.orgs[lookup(each.value, "organization", local.defaults.intersight.organization)]
  profiles = [
    for v in local.domains : v.name if length(regexall("^${each.value.name}$", v.vsan_policy)) > 0 || length(regexall(
      "^${each.value.name}${local.defaults.intersight.policies.vsan.name_suffix}$", v.vsan_policy)
    ) > 0
  ]
  tags            = lookup(each.value, "tags", local.defaults.intersight.tags)
  uplink_trunking = lookup(each.value, "uplink_trunking", local.defaults.intersight.policies.vsan.uplink_trunking)
  vsans           = lookup(each.value, "vsans", [])
}
