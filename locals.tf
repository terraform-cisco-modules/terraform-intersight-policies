locals {
  defaults    = lookup(var.model, "defaults", {})
  intersight  = lookup(var.model, "intersight", {})
  ladapter    = local.defaults.intersight.policies.adapter_configuration
  lancon      = local.defaults.intersight.policies.lan_connectivity
  lbios       = local.defaults.intersight.policies.bios
  lboot       = local.defaults.intersight.policies.boot_order
  ldga        = local.defaults.intersight.policies.storage.drive_groups.automatic_drive_groups
  ldgm        = local.defaults.intersight.policies.storage.drive_groups.manual_drive_groups
  ldgv        = local.defaults.intersight.policies.storage.drive_groups.virtual_drives
  ldns        = local.defaults.intersight.policies.network_connectivity
  leadapter   = local.defaults.intersight.policies.ethernet_adapter
  lfadapter   = local.defaults.intersight.policies.fibre_channel_adapter
  liboot      = local.defaults.intersight.policies.iscsi_boot
  lldap       = local.defaults.intersight.policies.ldap
  lntp        = local.defaults.intersight.policies.ntp
  lport       = local.defaults.intersight.policies.port
  lpmem       = local.defaults.intersight.policies.persistent_memory
  lscp        = local.defaults.intersight.policies.san_connectivity
  lsdcard     = local.defaults.intersight.policies.sd_card
  lsnmp       = local.defaults.intersight.policies.snmp
  lstorage    = local.defaults.intersight.policies.storage
  lsyslog     = local.defaults.intersight.policies.syslog
  lsystem_qos = local.defaults.intersight.policies.system_qos
  luser       = local.defaults.intersight.policies.local_user
  lvlan       = local.defaults.intersight.policies.vlan
  lvsan       = local.defaults.intersight.policies.vsan
  name_prefix = local.defaults.intersight.policies.name_prefix
  orgs        = var.pools.orgs
  policies    = lookup(local.intersight, "policies", {})
  swctrl      = local.defaults.intersight.policies.switch_control
  vmedia      = local.defaults.intersight.policies.virtual_media
  #_________________________________________________________________
  #
  # Intersight Adapter Configuration Policy
  # GUI Location: Policies > Create Policy > Adapter Configuration
  #_________________________________________________________________
  adapter_configuration = {
    for v in lookup(local.policies, "adapter_configuration", []) : v.name => {
      dce_interface_settings = [for i in range(lookup(v, "adapter_ports", local.ladapter.adapter_ports)) :
        {
          additional_properties = ""
          class_id              = "adapter.DceInterfaceSettings"
          fec_mode = length(
            lookup(v, "fec_modes", ["cl91"])) == 1 ? element(lookup(v, "fec_modes", ["cl91"]), 0
            ) : element(lookup(v, "fec_modes", ["cl91"]), i
          )
          interface_id = i
          object_type  = "adapter.DceInterfaceSettings"
        }
      ]
      description         = lookup(v, "description", "")
      enable_fip          = lookup(v, "enable_fip", local.ladapter.enable_fip)
      enable_lldp         = lookup(v, "enable_lldp", local.ladapter.enable_lldp)
      enable_port_channel = lookup(v, "enable_port_channel", local.ladapter.enable_port_channel)
      fec_modes           = lookup(v, "fec_modes", local.ladapter.fec_modes)
      name                = "${local.name_prefix}${v.name}${local.ladapter.name_suffix}"
      pci_slot            = lookup(v, "pci_slot", local.ladapter.pci_slot)
      organization        = lookup(v, "organization", var.organization)
      tags                = lookup(v, "tags", var.tags)
    }
  }

  #__________________________________________________________________
  #
  # Intersight BIOS Policy
  # GUI Location: Policies > Create Policy > BIOS
  #__________________________________________________________________
  bios = {
    for v in lookup(local.policies, "bios", []) : v.name => {
      bios_template = lookup(v, "bios_template", "")
      description   = lookup(v, "description", "")
      name          = "${local.name_prefix}${v.name}${local.lbios.name_suffix}"
      organization  = lookup(v, "organization", var.organization)
      tags          = lookup(v, "tags", var.tags)
      #+++++++++++++++++++++++++++++++
      # Boot Options Section
      #+++++++++++++++++++++++++++++++
      boot_option_num_retry        = lookup(v, "boot_option_num_retry", local.lbios.boot_option_num_retry)
      boot_option_re_cool_down     = lookup(v, "boot_option_re_cool_down", local.lbios.boot_option_re_cool_down)
      boot_option_retry            = lookup(v, "boot_option_retry", local.lbios.boot_option_retry)
      ipv4http                     = lookup(v, "ipv4http", local.lbios.ipv4http)
      ipv4pxe                      = lookup(v, "ipv4pxe", local.lbios.ipv4pxe)
      ipv6http                     = lookup(v, "ipv6http", local.lbios.ipv6http)
      ipv6pxe                      = lookup(v, "ipv6pxe", local.lbios.ipv6pxe)
      network_stack                = lookup(v, "network_stack", local.lbios.network_stack)
      onboard_scu_storage_support  = lookup(v, "onboard_scu_storage_support", local.lbios.onboard_scu_storage_support)
      onboard_scu_storage_sw_stack = lookup(v, "onboard_scu_storage_sw_stack", local.lbios.onboard_scu_storage_sw_stack)
      pop_support                  = lookup(v, "pop_support", local.lbios.pop_support)
      psata                        = lookup(v, "psata", local.lbios.psata)
      sata_mode_select             = lookup(v, "sata_mode_select", local.lbios.sata_mode_select)
      vmd_enable                   = lookup(v, "vmd_enable", local.lbios.vmd_enable)
      #+++++++++++++++++++++++++++++++
      # Intel Directed IO Section
      #+++++++++++++++++++++++++++++++
      intel_vt_for_directed_io           = lookup(v, "intel_vt_for_directed_io", local.lbios.intel_vt_for_directed_io)
      intel_vtd_coherency_support        = lookup(v, "intel_vtd_coherency_support", local.lbios.intel_vtd_coherency_support)
      intel_vtd_interrupt_remapping      = lookup(v, "intel_vtd_interrupt_remapping", local.lbios.intel_vtd_interrupt_remapping)
      intel_vtd_pass_through_dma_support = lookup(v, "intel_vtd_pass_through_dma_support", local.lbios.intel_vtd_pass_through_dma_support)
      intel_vtdats_support               = lookup(v, "intel_vtdats_support", local.lbios.intel_vtdats_support)
      #+++++++++++++++++++++++++++++++
      # LOM and PCIe Slots Section
      #+++++++++++++++++++++++++++++++
      acs_control_gpu1state          = lookup(v, "acs_control_gpu1state", local.lbios.acs_control_gpu1state)
      acs_control_gpu2state          = lookup(v, "acs_control_gpu2state", local.lbios.acs_control_gpu2state)
      acs_control_gpu3state          = lookup(v, "acs_control_gpu3state", local.lbios.acs_control_gpu3state)
      acs_control_gpu4state          = lookup(v, "acs_control_gpu4state", local.lbios.acs_control_gpu4state)
      acs_control_gpu5state          = lookup(v, "acs_control_gpu5state", local.lbios.acs_control_gpu5state)
      acs_control_gpu6state          = lookup(v, "acs_control_gpu6state", local.lbios.acs_control_gpu6state)
      acs_control_gpu7state          = lookup(v, "acs_control_gpu7state", local.lbios.acs_control_gpu7state)
      acs_control_gpu8state          = lookup(v, "acs_control_gpu8state", local.lbios.acs_control_gpu8state)
      acs_control_slot11state        = lookup(v, "acs_control_slot11state", local.lbios.acs_control_slot11state)
      acs_control_slot12state        = lookup(v, "acs_control_slot12state", local.lbios.acs_control_slot12state)
      acs_control_slot13state        = lookup(v, "acs_control_slot13state", local.lbios.acs_control_slot13state)
      acs_control_slot14state        = lookup(v, "acs_control_slot14state", local.lbios.acs_control_slot14state)
      cdn_support                    = lookup(v, "cdn_support", local.lbios.cdn_support)
      edpc_en                        = lookup(v, "edpc_en", local.lbios.edpc_en)
      enable_clock_spread_spec       = lookup(v, "enable_clock_spread_spec", local.lbios.enable_clock_spread_spec)
      lom_port0state                 = lookup(v, "lom_port0state", local.lbios.lom_port0state)
      lom_port1state                 = lookup(v, "lom_port1state", local.lbios.lom_port1state)
      lom_port2state                 = lookup(v, "lom_port2state", local.lbios.lom_port2state)
      lom_port3state                 = lookup(v, "lom_port3state", local.lbios.lom_port3state)
      lom_ports_all_state            = lookup(v, "lom_ports_all_state", local.lbios.lom_ports_all_state)
      pci_option_ro_ms               = lookup(v, "pci_option_ro_ms", local.lbios.pci_option_ro_ms)
      pci_rom_clp                    = lookup(v, "pci_rom_clp", local.lbios.pci_rom_clp)
      pcie_ari_support               = lookup(v, "pcie_ari_support", local.lbios.pcie_ari_support)
      pcie_pll_ssc                   = lookup(v, "pcie_pll_ssc", local.lbios.pcie_pll_ssc)
      pcie_slot_mraid1link_speed     = lookup(v, "pcie_slot_mraid1link_speed", local.lbios.pcie_slot_mraid1link_speed)
      pcie_slot_mraid1option_rom     = lookup(v, "pcie_slot_mraid1option_rom", local.lbios.pcie_slot_mraid1option_rom)
      pcie_slot_mraid2link_speed     = lookup(v, "pcie_slot_mraid2link_speed", local.lbios.pcie_slot_mraid2link_speed)
      pcie_slot_mraid2option_rom     = lookup(v, "pcie_slot_mraid2option_rom", local.lbios.pcie_slot_mraid2option_rom)
      pcie_slot_mstorraid_link_speed = lookup(v, "pcie_slot_mstorraid_link_speed", local.lbios.pcie_slot_mstorraid_link_speed)
      pcie_slot_mstorraid_option_rom = lookup(v, "pcie_slot_mstorraid_option_rom", local.lbios.pcie_slot_mstorraid_option_rom)
      pcie_slot_nvme1link_speed      = lookup(v, "pcie_slot_nvme1link_speed", local.lbios.pcie_slot_nvme1link_speed)
      pcie_slot_nvme1option_rom      = lookup(v, "pcie_slot_nvme1option_rom", local.lbios.pcie_slot_nvme1option_rom)
      pcie_slot_nvme2link_speed      = lookup(v, "pcie_slot_nvme2link_speed", local.lbios.pcie_slot_nvme2link_speed)
      pcie_slot_nvme2option_rom      = lookup(v, "pcie_slot_nvme2option_rom", local.lbios.pcie_slot_nvme2option_rom)
      pcie_slot_nvme3link_speed      = lookup(v, "pcie_slot_nvme3link_speed", local.lbios.pcie_slot_nvme3link_speed)
      pcie_slot_nvme3option_rom      = lookup(v, "pcie_slot_nvme3option_rom", local.lbios.pcie_slot_nvme3option_rom)
      pcie_slot_nvme4link_speed      = lookup(v, "pcie_slot_nvme4link_speed", local.lbios.pcie_slot_nvme4link_speed)
      pcie_slot_nvme4option_rom      = lookup(v, "pcie_slot_nvme4option_rom", local.lbios.pcie_slot_nvme4option_rom)
      pcie_slot_nvme5link_speed      = lookup(v, "pcie_slot_nvme5link_speed", local.lbios.pcie_slot_nvme5link_speed)
      pcie_slot_nvme5option_rom      = lookup(v, "pcie_slot_nvme5option_rom", local.lbios.pcie_slot_nvme5option_rom)
      pcie_slot_nvme6link_speed      = lookup(v, "pcie_slot_nvme6link_speed", local.lbios.pcie_slot_nvme6link_speed)
      pcie_slot_nvme6option_rom      = lookup(v, "pcie_slot_nvme6option_rom", local.lbios.pcie_slot_nvme6option_rom)
      slot10link_speed               = lookup(v, "slot10link_speed", local.lbios.slot10link_speed)
      slot10state                    = lookup(v, "slot10state", local.lbios.slot10state)
      slot11link_speed               = lookup(v, "slot11link_speed", local.lbios.slot11link_speed)
      slot11state                    = lookup(v, "slot11state", local.lbios.slot11state)
      slot12link_speed               = lookup(v, "slot12link_speed", local.lbios.slot12link_speed)
      slot12state                    = lookup(v, "slot12state", local.lbios.slot12state)
      slot13state                    = lookup(v, "slot13state", local.lbios.slot13state)
      slot14state                    = lookup(v, "slot14state", local.lbios.slot14state)
      slot1link_speed                = lookup(v, "slot1link_speed", local.lbios.slot1link_speed)
      slot1state                     = lookup(v, "slot1state", local.lbios.slot1state)
      slot2link_speed                = lookup(v, "slot2link_speed", local.lbios.slot2link_speed)
      slot2state                     = lookup(v, "slot2state", local.lbios.slot2state)
      slot3link_speed                = lookup(v, "slot3link_speed", local.lbios.slot3link_speed)
      slot3state                     = lookup(v, "slot3state", local.lbios.slot3state)
      slot4link_speed                = lookup(v, "slot4link_speed", local.lbios.slot4link_speed)
      slot4state                     = lookup(v, "slot4state", local.lbios.slot4state)
      slot5link_speed                = lookup(v, "slot5link_speed", local.lbios.slot5link_speed)
      slot5state                     = lookup(v, "slot5state", local.lbios.slot5state)
      slot6link_speed                = lookup(v, "slot6link_speed", local.lbios.slot6link_speed)
      slot6state                     = lookup(v, "slot6state", local.lbios.slot6state)
      slot7link_speed                = lookup(v, "slot7link_speed", local.lbios.slot7link_speed)
      slot7state                     = lookup(v, "slot7state", local.lbios.slot7state)
      slot8link_speed                = lookup(v, "slot8link_speed", local.lbios.slot8link_speed)
      slot8state                     = lookup(v, "slot8state", local.lbios.slot8state)
      slot9link_speed                = lookup(v, "slot9link_speed", local.lbios.slot9link_speed)
      slot9state                     = lookup(v, "slot9state", local.lbios.slot9state)
      slot_flom_link_speed           = lookup(v, "slot_flom_link_speed", local.lbios.slot_flom_link_speed)
      slot_front_nvme10link_speed    = lookup(v, "slot_front_nvme10link_speed", local.lbios.slot_front_nvme10link_speed)
      slot_front_nvme10option_rom    = lookup(v, "slot_front_nvme10option_rom", local.lbios.slot_front_nvme10option_rom)
      slot_front_nvme11link_speed    = lookup(v, "slot_front_nvme11link_speed", local.lbios.slot_front_nvme11link_speed)
      slot_front_nvme11option_rom    = lookup(v, "slot_front_nvme11option_rom", local.lbios.slot_front_nvme11option_rom)
      slot_front_nvme12link_speed    = lookup(v, "slot_front_nvme12link_speed", local.lbios.slot_front_nvme12link_speed)
      slot_front_nvme12option_rom    = lookup(v, "slot_front_nvme12option_rom", local.lbios.slot_front_nvme12option_rom)
      slot_front_nvme13option_rom    = lookup(v, "slot_front_nvme13option_rom", local.lbios.slot_front_nvme13option_rom)
      slot_front_nvme14option_rom    = lookup(v, "slot_front_nvme14option_rom", local.lbios.slot_front_nvme14option_rom)
      slot_front_nvme15option_rom    = lookup(v, "slot_front_nvme15option_rom", local.lbios.slot_front_nvme15option_rom)
      slot_front_nvme16option_rom    = lookup(v, "slot_front_nvme16option_rom", local.lbios.slot_front_nvme16option_rom)
      slot_front_nvme17option_rom    = lookup(v, "slot_front_nvme17option_rom", local.lbios.slot_front_nvme17option_rom)
      slot_front_nvme18option_rom    = lookup(v, "slot_front_nvme18option_rom", local.lbios.slot_front_nvme18option_rom)
      slot_front_nvme19option_rom    = lookup(v, "slot_front_nvme19option_rom", local.lbios.slot_front_nvme19option_rom)
      slot_front_nvme1link_speed     = lookup(v, "slot_front_nvme1link_speed", local.lbios.slot_front_nvme1link_speed)
      slot_front_nvme1option_rom     = lookup(v, "slot_front_nvme1option_rom", local.lbios.slot_front_nvme1option_rom)
      slot_front_nvme20option_rom    = lookup(v, "slot_front_nvme20option_rom", local.lbios.slot_front_nvme20option_rom)
      slot_front_nvme21option_rom    = lookup(v, "slot_front_nvme21option_rom", local.lbios.slot_front_nvme21option_rom)
      slot_front_nvme22option_rom    = lookup(v, "slot_front_nvme22option_rom", local.lbios.slot_front_nvme22option_rom)
      slot_front_nvme23option_rom    = lookup(v, "slot_front_nvme23option_rom", local.lbios.slot_front_nvme23option_rom)
      slot_front_nvme24option_rom    = lookup(v, "slot_front_nvme24option_rom", local.lbios.slot_front_nvme24option_rom)
      slot_front_nvme2link_speed     = lookup(v, "slot_front_nvme2link_speed", local.lbios.slot_front_nvme2link_speed)
      slot_front_nvme2option_rom     = lookup(v, "slot_front_nvme2option_rom", local.lbios.slot_front_nvme2option_rom)
      slot_front_nvme3link_speed     = lookup(v, "slot_front_nvme3link_speed", local.lbios.slot_front_nvme3link_speed)
      slot_front_nvme3option_rom     = lookup(v, "slot_front_nvme3option_rom", local.lbios.slot_front_nvme3option_rom)
      slot_front_nvme4link_speed     = lookup(v, "slot_front_nvme4link_speed", local.lbios.slot_front_nvme4link_speed)
      slot_front_nvme4option_rom     = lookup(v, "slot_front_nvme4option_rom", local.lbios.slot_front_nvme4option_rom)
      slot_front_nvme5link_speed     = lookup(v, "slot_front_nvme5link_speed", local.lbios.slot_front_nvme5link_speed)
      slot_front_nvme5option_rom     = lookup(v, "slot_front_nvme5option_rom", local.lbios.slot_front_nvme5option_rom)
      slot_front_nvme6link_speed     = lookup(v, "slot_front_nvme6link_speed", local.lbios.slot_front_nvme6link_speed)
      slot_front_nvme6option_rom     = lookup(v, "slot_front_nvme6option_rom", local.lbios.slot_front_nvme6option_rom)
      slot_front_nvme7link_speed     = lookup(v, "slot_front_nvme7link_speed", local.lbios.slot_front_nvme7link_speed)
      slot_front_nvme7option_rom     = lookup(v, "slot_front_nvme7option_rom", local.lbios.slot_front_nvme7option_rom)
      slot_front_nvme8link_speed     = lookup(v, "slot_front_nvme8link_speed", local.lbios.slot_front_nvme8link_speed)
      slot_front_nvme8option_rom     = lookup(v, "slot_front_nvme8option_rom", local.lbios.slot_front_nvme8option_rom)
      slot_front_nvme9link_speed     = lookup(v, "slot_front_nvme9link_speed", local.lbios.slot_front_nvme9link_speed)
      slot_front_nvme9option_rom     = lookup(v, "slot_front_nvme9option_rom", local.lbios.slot_front_nvme9option_rom)
      slot_front_slot5link_speed     = lookup(v, "slot_front_slot5link_speed", local.lbios.slot_front_slot5link_speed)
      slot_front_slot6link_speed     = lookup(v, "slot_front_slot6link_speed", local.lbios.slot_front_slot6link_speed)
      slot_gpu1state                 = lookup(v, "slot_gpu1state", local.lbios.slot_gpu1state)
      slot_gpu2state                 = lookup(v, "slot_gpu2state", local.lbios.slot_gpu2state)
      slot_gpu3state                 = lookup(v, "slot_gpu3state", local.lbios.slot_gpu3state)
      slot_gpu4state                 = lookup(v, "slot_gpu4state", local.lbios.slot_gpu4state)
      slot_gpu5state                 = lookup(v, "slot_gpu5state", local.lbios.slot_gpu5state)
      slot_gpu6state                 = lookup(v, "slot_gpu6state", local.lbios.slot_gpu6state)
      slot_gpu7state                 = lookup(v, "slot_gpu7state", local.lbios.slot_gpu7state)
      slot_gpu8state                 = lookup(v, "slot_gpu8state", local.lbios.slot_gpu8state)
      slot_hba_link_speed            = lookup(v, "slot_hba_link_speed", local.lbios.slot_hba_link_speed)
      slot_hba_state                 = lookup(v, "slot_hba_state", local.lbios.slot_hba_state)
      slot_lom1link                  = lookup(v, "slot_lom1link", local.lbios.slot_lom1link)
      slot_lom2link                  = lookup(v, "slot_lom2link", local.lbios.slot_lom2link)
      slot_mezz_state                = lookup(v, "slot_mezz_state", local.lbios.slot_mezz_state)
      slot_mlom_link_speed           = lookup(v, "slot_mlom_link_speed", local.lbios.slot_mlom_link_speed)
      slot_mlom_state                = lookup(v, "slot_mlom_state", local.lbios.slot_mlom_state)
      slot_mraid_link_speed          = lookup(v, "slot_mraid_link_speed", local.lbios.slot_mraid_link_speed)
      slot_mraid_state               = lookup(v, "slot_mraid_state", local.lbios.slot_mraid_state)
      slot_n10state                  = lookup(v, "slot_n10state", local.lbios.slot_n10state)
      slot_n11state                  = lookup(v, "slot_n11state", local.lbios.slot_n11state)
      slot_n12state                  = lookup(v, "slot_n12state", local.lbios.slot_n12state)
      slot_n13state                  = lookup(v, "slot_n13state", local.lbios.slot_n13state)
      slot_n14state                  = lookup(v, "slot_n14state", local.lbios.slot_n14state)
      slot_n15state                  = lookup(v, "slot_n15state", local.lbios.slot_n15state)
      slot_n16state                  = lookup(v, "slot_n16state", local.lbios.slot_n16state)
      slot_n17state                  = lookup(v, "slot_n17state", local.lbios.slot_n17state)
      slot_n18state                  = lookup(v, "slot_n18state", local.lbios.slot_n18state)
      slot_n19state                  = lookup(v, "slot_n19state", local.lbios.slot_n19state)
      slot_n1state                   = lookup(v, "slot_n1state", local.lbios.slot_n1state)
      slot_n20state                  = lookup(v, "slot_n20state", local.lbios.slot_n20state)
      slot_n21state                  = lookup(v, "slot_n21state", local.lbios.slot_n21state)
      slot_n22state                  = lookup(v, "slot_n22state", local.lbios.slot_n22state)
      slot_n23state                  = lookup(v, "slot_n23state", local.lbios.slot_n23state)
      slot_n24state                  = lookup(v, "slot_n24state", local.lbios.slot_n24state)
      slot_n2state                   = lookup(v, "slot_n2state", local.lbios.slot_n2state)
      slot_n3state                   = lookup(v, "slot_n3state", local.lbios.slot_n3state)
      slot_n4state                   = lookup(v, "slot_n4state", local.lbios.slot_n4state)
      slot_n5state                   = lookup(v, "slot_n5state", local.lbios.slot_n5state)
      slot_n6state                   = lookup(v, "slot_n6state", local.lbios.slot_n6state)
      slot_n7state                   = lookup(v, "slot_n7state", local.lbios.slot_n7state)
      slot_n8state                   = lookup(v, "slot_n8state", local.lbios.slot_n8state)
      slot_n9state                   = lookup(v, "slot_n9state", local.lbios.slot_n9state)
      slot_raid_link_speed           = lookup(v, "slot_raid_link_speed", local.lbios.slot_raid_link_speed)
      slot_raid_state                = lookup(v, "slot_raid_state", local.lbios.slot_raid_state)
      slot_rear_nvme1link_speed      = lookup(v, "slot_rear_nvme1link_speed", local.lbios.slot_rear_nvme1link_speed)
      slot_rear_nvme1state           = lookup(v, "slot_rear_nvme1state", local.lbios.slot_rear_nvme1state)
      slot_rear_nvme2link_speed      = lookup(v, "slot_rear_nvme2link_speed", local.lbios.slot_rear_nvme2link_speed)
      slot_rear_nvme2state           = lookup(v, "slot_rear_nvme2state", local.lbios.slot_rear_nvme2state)
      slot_rear_nvme3link_speed      = lookup(v, "slot_rear_nvme3link_speed", local.lbios.slot_rear_nvme3link_speed)
      slot_rear_nvme3state           = lookup(v, "slot_rear_nvme3state", local.lbios.slot_rear_nvme3state)
      slot_rear_nvme4link_speed      = lookup(v, "slot_rear_nvme4link_speed", local.lbios.slot_rear_nvme4link_speed)
      slot_rear_nvme4state           = lookup(v, "slot_rear_nvme4state", local.lbios.slot_rear_nvme4state)
      slot_rear_nvme5state           = lookup(v, "slot_rear_nvme5state", local.lbios.slot_rear_nvme5state)
      slot_rear_nvme6state           = lookup(v, "slot_rear_nvme6state", local.lbios.slot_rear_nvme6state)
      slot_rear_nvme7state           = lookup(v, "slot_rear_nvme7state", local.lbios.slot_rear_nvme7state)
      slot_rear_nvme8state           = lookup(v, "slot_rear_nvme8state", local.lbios.slot_rear_nvme8state)
      slot_riser1link_speed          = lookup(v, "slot_riser1link_speed", local.lbios.slot_riser1link_speed)
      slot_riser1slot1link_speed     = lookup(v, "slot_riser1slot1link_speed", local.lbios.slot_riser1slot1link_speed)
      slot_riser1slot2link_speed     = lookup(v, "slot_riser1slot2link_speed", local.lbios.slot_riser1slot2link_speed)
      slot_riser1slot3link_speed     = lookup(v, "slot_riser1slot3link_speed", local.lbios.slot_riser1slot3link_speed)
      slot_riser2link_speed          = lookup(v, "slot_riser2link_speed", local.lbios.slot_riser2link_speed)
      slot_riser2slot4link_speed     = lookup(v, "slot_riser2slot4link_speed", local.lbios.slot_riser2slot4link_speed)
      slot_riser2slot5link_speed     = lookup(v, "slot_riser2slot5link_speed", local.lbios.slot_riser2slot5link_speed)
      slot_riser2slot6link_speed     = lookup(v, "slot_riser2slot6link_speed", local.lbios.slot_riser2slot6link_speed)
      slot_sas_state                 = lookup(v, "slot_sas_state", local.lbios.slot_sas_state)
      slot_ssd_slot1link_speed       = lookup(v, "slot_ssd_slot1link_speed", local.lbios.slot_ssd_slot1link_speed)
      slot_ssd_slot2link_speed       = lookup(v, "slot_ssd_slot2link_speed", local.lbios.slot_ssd_slot2link_speed)
      #+++++++++++++++++++++++++++++++
      # Main Section
      #+++++++++++++++++++++++++++++++
      pcie_slots_cdn_enable = lookup(v, "pcie_slots_cdn_enable", local.lbios.pcie_slots_cdn_enable)
      post_error_pause      = lookup(v, "post_error_pause", local.lbios.post_error_pause)
      tpm_support           = lookup(v, "tpm_support", local.lbios.tpm_support)
      #+++++++++++++++++++++++++++++++
      # Memory Section
      #+++++++++++++++++++++++++++++++
      advanced_mem_test                     = lookup(v, "advanced_mem_test", local.lbios.advanced_mem_test)
      bme_dma_mitigation                    = lookup(v, "bme_dma_mitigation", local.lbios.bme_dma_mitigation)
      burst_and_postponed_refresh           = lookup(v, "burst_and_postponed_refresh", local.lbios.burst_and_postponed_refresh)
      cbs_cmn_cpu_smee                      = lookup(v, "cbs_cmn_cpu_smee", local.lbios.cbs_cmn_cpu_smee)
      cbs_cmn_gnb_nb_iommu                  = lookup(v, "cbs_cmn_gnb_nb_iommu", local.lbios.cbs_cmn_gnb_nb_iommu)
      cbs_cmn_mem_ctrl_bank_group_swap_ddr4 = lookup(v, "cbs_cmn_mem_ctrl_bank_group_swap_ddr4", local.lbios.cbs_cmn_mem_ctrl_bank_group_swap_ddr4)
      cbs_cmn_mem_map_bank_interleave_ddr4  = lookup(v, "cbs_cmn_mem_map_bank_interleave_ddr4", local.lbios.cbs_cmn_mem_map_bank_interleave_ddr4)
      cbs_dbg_cpu_snp_mem_cover             = lookup(v, "cbs_dbg_cpu_snp_mem_cover", local.lbios.cbs_dbg_cpu_snp_mem_cover)
      cbs_dbg_cpu_snp_mem_size_cover        = lookup(v, "cbs_dbg_cpu_snp_mem_size_cover", local.lbios.cbs_dbg_cpu_snp_mem_size_cover)
      cbs_df_cmn_dram_nps                   = lookup(v, "cbs_df_cmn_dram_nps", local.lbios.cbs_df_cmn_dram_nps)
      cbs_df_cmn_mem_intlv                  = lookup(v, "cbs_df_cmn_mem_intlv", local.lbios.cbs_df_cmn_mem_intlv)
      cbs_df_cmn_mem_intlv_size             = lookup(v, "cbs_df_cmn_mem_intlv_size", local.lbios.cbs_df_cmn_mem_intlv_size)
      cbs_sev_snp_support                   = lookup(v, "cbs_sev_snp_support", local.lbios.cbs_sev_snp_support)
      cke_low_policy                        = lookup(v, "cke_low_policy", local.lbios.cke_low_policy)
      cr_qos                                = lookup(v, "cr_qos", local.lbios.cr_qos)
      crfastgo_config                       = lookup(v, "crfastgo_config", local.lbios.crfastgo_config)
      dcpmm_firmware_downgrade              = lookup(v, "dcpmm_firmware_downgrade", local.lbios.dcpmm_firmware_downgrade)
      dram_refresh_rate                     = lookup(v, "dram_refresh_rate", local.lbios.dram_refresh_rate)
      dram_sw_thermal_throttling            = lookup(v, "dram_sw_thermal_throttling", local.lbios.dram_sw_thermal_throttling)
      eadr_support                          = lookup(v, "eadr_support", local.lbios.eadr_support)
      lv_ddr_mode                           = lookup(v, "lv_ddr_mode", local.lbios.lv_ddr_mode)
      memory_bandwidth_boost                = lookup(v, "memory_bandwidth_boost", local.lbios.memory_bandwidth_boost)
      memory_refresh_rate                   = lookup(v, "memory_refresh_rate", local.lbios.memory_refresh_rate)
      memory_size_limit                     = lookup(v, "memory_size_limit", local.lbios.memory_size_limit)
      memory_thermal_throttling             = lookup(v, "memory_thermal_throttling", local.lbios.memory_thermal_throttling)
      mirroring_mode                        = lookup(v, "mirroring_mode", local.lbios.mirroring_mode)
      numa_optimized                        = lookup(v, "numa_optimized", local.lbios.numa_optimized)
      nvmdimm_perform_config                = lookup(v, "nvmdimm_perform_config", local.lbios.nvmdimm_perform_config)
      operation_mode                        = lookup(v, "operation_mode", local.lbios.operation_mode)
      panic_high_watermark                  = lookup(v, "panic_high_watermark", local.lbios.panic_high_watermark)
      partial_cache_line_sparing            = lookup(v, "partial_cache_line_sparing", local.lbios.partial_cache_line_sparing)
      partial_mirror_mode_config            = lookup(v, "partial_mirror_mode_config", local.lbios.partial_mirror_mode_config)
      partial_mirror_percent                = lookup(v, "partial_mirror_percent", local.lbios.partial_mirror_percent)
      partial_mirror_value1                 = lookup(v, "partial_mirror_value1", local.lbios.partial_mirror_value1)
      partial_mirror_value2                 = lookup(v, "partial_mirror_value2", local.lbios.partial_mirror_value2)
      partial_mirror_value3                 = lookup(v, "partial_mirror_value3", local.lbios.partial_mirror_value3)
      partial_mirror_value4                 = lookup(v, "partial_mirror_value4", local.lbios.partial_mirror_value4)
      pc_ie_ras_support                     = lookup(v, "pc_ie_ras_support", local.lbios.pc_ie_ras_support)
      post_package_repair                   = lookup(v, "post_package_repair", local.lbios.post_package_repair)
      select_memory_ras_configuration       = lookup(v, "select_memory_ras_configuration", local.lbios.select_memory_ras_configuration)
      select_ppr_type                       = lookup(v, "select_ppr_type", local.lbios.select_ppr_type)
      sev                                   = lookup(v, "sev", local.lbios.sev)
      smee                                  = lookup(v, "smee", local.lbios.smee)
      snoopy_mode_for2lm                    = lookup(v, "snoopy_mode_for2lm", local.lbios.snoopy_mode_for2lm)
      snoopy_mode_for_ad                    = lookup(v, "snoopy_mode_for_ad", local.lbios.snoopy_mode_for_ad)
      sparing_mode                          = lookup(v, "sparing_mode", local.lbios.sparing_mode)
      tsme                                  = lookup(v, "tsme", local.lbios.tsme)
      uma_based_clustering                  = lookup(v, "uma_based_clustering", local.lbios.uma_based_clustering)
      vol_memory_mode                       = lookup(v, "vol_memory_mode", local.lbios.vol_memory_mode)
      #+++++++++++++++++++++++++++++++
      # PCI Section
      #+++++++++++++++++++++++++++++++
      aspm_support               = lookup(v, "aspm_support", local.lbios.aspm_support)
      ioh_resource               = lookup(v, "ioh_resource", local.lbios.ioh_resource)
      memory_mapped_io_above4gb  = lookup(v, "memory_mapped_io_above4gb", local.lbios.memory_mapped_io_above4gb)
      mmcfg_base                 = lookup(v, "mmcfg_base", local.lbios.mmcfg_base)
      onboard10gbit_lom          = lookup(v, "onboard10gbit_lom", local.lbios.onboard10gbit_lom)
      onboard_gbit_lom           = lookup(v, "onboard_gbit_lom", local.lbios.onboard_gbit_lom)
      pc_ie_ssd_hot_plug_support = lookup(v, "pc_ie_ssd_hot_plug_support", local.lbios.pc_ie_ssd_hot_plug_support)
      sr_iov                     = lookup(v, "sr_iov", local.lbios.sr_iov)
      vga_priority               = lookup(v, "vga_priority", local.lbios.vga_priority)
      #+++++++++++++++++++++++++++++++
      # Power and Performance Section
      #+++++++++++++++++++++++++++++++
      c1auto_demotion                    = lookup(v, "c1auto_demotion", local.lbios.c1auto_demotion)
      c1auto_un_demotion                 = lookup(v, "c1auto_un_demotion", local.lbios.c1auto_un_demotion)
      cbs_cmn_cpu_cpb                    = lookup(v, "cbs_cmn_cpu_cpb", local.lbios.cbs_cmn_cpu_cpb)
      cbs_cmn_cpu_global_cstate_ctrl     = lookup(v, "cbs_cmn_cpu_global_cstate_ctrl", local.lbios.cbs_cmn_cpu_global_cstate_ctrl)
      cbs_cmn_cpu_l1stream_hw_prefetcher = lookup(v, "cbs_cmn_cpu_l1stream_hw_prefetcher", local.lbios.cbs_cmn_cpu_l1stream_hw_prefetcher)
      cbs_cmn_cpu_l2stream_hw_prefetcher = lookup(v, "cbs_cmn_cpu_l2stream_hw_prefetcher", local.lbios.cbs_cmn_cpu_l2stream_hw_prefetcher)
      cbs_cmn_determinism_slider         = lookup(v, "cbs_cmn_determinism_slider", local.lbios.cbs_cmn_determinism_slider)
      cbs_cmn_efficiency_mode_en         = lookup(v, "cbs_cmn_efficiency_mode_en", local.lbios.cbs_cmn_efficiency_mode_en)
      cbs_cmn_gnb_smucppc                = lookup(v, "cbs_cmn_gnb_smucppc", local.lbios.cbs_cmn_gnb_smucppc)
      cbs_cmnc_tdp_ctl                   = lookup(v, "cbs_cmnc_tdp_ctl", local.lbios.cbs_cmnc_tdp_ctl)
      cpu_perf_enhancement               = lookup(v, "cpu_perf_enhancement", local.lbios.cpu_perf_enhancement)
      llc_alloc                          = lookup(v, "llc_alloc", local.lbios.llc_alloc)
      upi_link_enablement                = lookup(v, "upi_link_enablement", local.lbios.upi_link_enablement)
      upi_power_management               = lookup(v, "upi_power_management", local.lbios.upi_power_management)
      virtual_numa                       = lookup(v, "virtual_numa", local.lbios.virtual_numa)
      xpt_remote_prefetch                = lookup(v, "xpt_remote_prefetch", local.lbios.xpt_remote_prefetch)
      #+++++++++++++++++++++++++++++++
      # Processor Section
      #+++++++++++++++++++++++++++++++
      adjacent_cache_line_prefetch      = lookup(v, "adjacent_cache_line_prefetch", local.lbios.adjacent_cache_line_prefetch)
      altitude                          = lookup(v, "altitude", local.lbios.altitude)
      auto_cc_state                     = lookup(v, "auto_cc_state", local.lbios.auto_cc_state)
      autonumous_cstate_enable          = lookup(v, "autonumous_cstate_enable", local.lbios.autonumous_cstate_enable)
      boot_performance_mode             = lookup(v, "boot_performance_mode", local.lbios.boot_performance_mode)
      cbs_cmn_apbdis                    = lookup(v, "cbs_cmn_apbdis", local.lbios.cbs_cmn_apbdis)
      cbs_cmn_cpu_gen_downcore_ctrl     = lookup(v, "cbs_cmn_cpu_gen_downcore_ctrl", local.lbios.cbs_cmn_cpu_gen_downcore_ctrl)
      cbs_cmn_cpu_streaming_stores_ctrl = lookup(v, "cbs_cmn_cpu_streaming_stores_ctrl", local.lbios.cbs_cmn_cpu_streaming_stores_ctrl)
      cbs_cmn_fixed_soc_pstate          = lookup(v, "cbs_cmn_fixed_soc_pstate", local.lbios.cbs_cmn_fixed_soc_pstate)
      cbs_cmn_gnb_smu_df_cstates        = lookup(v, "cbs_cmn_gnb_smu_df_cstates", local.lbios.cbs_cmn_gnb_smu_df_cstates)
      cbs_cpu_ccd_ctrl_ssp              = lookup(v, "cbs_cpu_ccd_ctrl_ssp", local.lbios.cbs_cpu_ccd_ctrl_ssp)
      cbs_cpu_core_ctrl                 = lookup(v, "cbs_cpu_core_ctrl", local.lbios.cbs_cpu_core_ctrl)
      cbs_cpu_smt_ctrl                  = lookup(v, "cbs_cpu_smt_ctrl", local.lbios.cbs_cpu_smt_ctrl)
      cbs_df_cmn_acpi_srat_l3numa       = lookup(v, "cbs_df_cmn_acpi_srat_l3numa", local.lbios.cbs_df_cmn_acpi_srat_l3numa)
      channel_inter_leave               = lookup(v, "channel_inter_leave", local.lbios.channel_inter_leave)
      cisco_xgmi_max_speed              = lookup(v, "cisco_xgmi_max_speed", local.lbios.cisco_xgmi_max_speed)
      closed_loop_therm_throtl          = lookup(v, "closed_loop_therm_throtl", local.lbios.closed_loop_therm_throtl)
      cmci_enable                       = lookup(v, "cmci_enable", local.lbios.cmci_enable)
      config_tdp                        = lookup(v, "config_tdp", local.lbios.config_tdp)
      config_tdp_level                  = lookup(v, "config_tdp_level", local.lbios.config_tdp_level)
      core_multi_processing             = lookup(v, "core_multi_processing", local.lbios.core_multi_processing)
      cpu_energy_performance            = lookup(v, "cpu_energy_performance", local.lbios.cpu_energy_performance)
      cpu_frequency_floor               = lookup(v, "cpu_frequency_floor", local.lbios.cpu_frequency_floor)
      cpu_performance                   = lookup(v, "cpu_performance", local.lbios.cpu_performance)
      cpu_power_management              = lookup(v, "cpu_power_management", local.lbios.cpu_power_management)
      demand_scrub                      = lookup(v, "demand_scrub", local.lbios.demand_scrub)
      direct_cache_access               = lookup(v, "direct_cache_access", local.lbios.direct_cache_access)
      dram_clock_throttling             = lookup(v, "dram_clock_throttling", local.lbios.dram_clock_throttling)
      energy_efficient_turbo            = lookup(v, "energy_efficient_turbo", local.lbios.energy_efficient_turbo)
      eng_perf_tuning                   = lookup(v, "eng_perf_tuning", local.lbios.eng_perf_tuning)
      enhanced_intel_speed_step_tech    = lookup(v, "enhanced_intel_speed_step_tech", local.lbios.enhanced_intel_speed_step_tech)
      epp_enable                        = lookup(v, "epp_enable", local.lbios.epp_enable)
      epp_profile                       = lookup(v, "epp_profile", local.lbios.epp_profile)
      execute_disable_bit               = lookup(v, "execute_disable_bit", local.lbios.execute_disable_bit)
      extended_apic                     = lookup(v, "extended_apic", local.lbios.extended_apic)
      hardware_prefetch                 = lookup(v, "hardware_prefetch", local.lbios.hardware_prefetch)
      hwpm_enable                       = lookup(v, "hwpm_enable", local.lbios.hwpm_enable)
      imc_interleave                    = lookup(v, "imc_interleave", local.lbios.imc_interleave)
      intel_dynamic_speed_select        = lookup(v, "intel_dynamic_speed_select", local.lbios.intel_dynamic_speed_select)
      intel_hyper_threading_tech        = lookup(v, "intel_hyper_threading_tech", local.lbios.intel_hyper_threading_tech)
      intel_speed_select                = lookup(v, "intel_speed_select", local.lbios.intel_speed_select)
      intel_turbo_boost_tech            = lookup(v, "intel_turbo_boost_tech", local.lbios.intel_turbo_boost_tech)
      intel_virtualization_technology   = lookup(v, "intel_virtualization_technology", local.lbios.intel_virtualization_technology)
      ioh_error_enable                  = lookup(v, "ioh_error_enable", local.lbios.ioh_error_enable)
      ip_prefetch                       = lookup(v, "ip_prefetch", local.lbios.ip_prefetch)
      kti_prefetch                      = lookup(v, "kti_prefetch", local.lbios.kti_prefetch)
      llc_prefetch                      = lookup(v, "llc_prefetch", local.lbios.llc_prefetch)
      memory_inter_leave                = lookup(v, "memory_inter_leave", local.lbios.memory_inter_leave)
      package_cstate_limit              = lookup(v, "package_cstate_limit", local.lbios.package_cstate_limit)
      patrol_scrub                      = lookup(v, "patrol_scrub", local.lbios.patrol_scrub)
      patrol_scrub_duration             = lookup(v, "patrol_scrub_duration", local.lbios.patrol_scrub_duration)
      processor_c1e                     = lookup(v, "processor_c1e", local.lbios.processor_c1e)
      processor_c3report                = lookup(v, "processor_c3report", local.lbios.processor_c3report)
      processor_c6report                = lookup(v, "processor_c6report", local.lbios.processor_c6report)
      processor_cstate                  = lookup(v, "processor_cstate", local.lbios.processor_cstate)
      pstate_coord_type                 = lookup(v, "pstate_coord_type", local.lbios.pstate_coord_type)
      pwr_perf_tuning                   = lookup(v, "pwr_perf_tuning", local.lbios.pwr_perf_tuning)
      qpi_link_speed                    = lookup(v, "qpi_link_speed", local.lbios.qpi_link_speed)
      rank_inter_leave                  = lookup(v, "rank_inter_leave", local.lbios.rank_inter_leave)
      single_pctl_enable                = lookup(v, "single_pctl_enable", local.lbios.single_pctl_enable)
      smt_mode                          = lookup(v, "smt_mode", local.lbios.smt_mode)
      snc                               = lookup(v, "snc", local.lbios.snc)
      streamer_prefetch                 = lookup(v, "streamer_prefetch", local.lbios.streamer_prefetch)
      svm_mode                          = lookup(v, "svm_mode", local.lbios.svm_mode)
      ufs_disable                       = lookup(v, "ufs_disable", local.lbios.ufs_disable)
      work_load_config                  = lookup(v, "work_load_config", local.lbios.work_load_config)
      xpt_prefetch                      = lookup(v, "xpt_prefetch", local.lbios.xpt_prefetch)
      #+++++++++++++++++++++++++++++++
      # QPI Section
      #+++++++++++++++++++++++++++++++
      qpi_link_frequency = lookup(v, "qpi_link_frequency", local.lbios.qpi_link_frequency)
      qpi_snoop_mode     = lookup(v, "qpi_snoop_mode", local.lbios.qpi_snoop_mode)
      #+++++++++++++++++++++++++++++++
      # Serial Port Section
      #+++++++++++++++++++++++++++++++
      serial_port_aenable = lookup(v, "serial_port_aenable", local.lbios.serial_port_aenable)
      #+++++++++++++++++++++++++++++++
      # Server Management Section
      #+++++++++++++++++++++++++++++++
      assert_nmi_on_perr              = lookup(v, "assert_nmi_on_perr", local.lbios.assert_nmi_on_perr)
      assert_nmi_on_serr              = lookup(v, "assert_nmi_on_serr", local.lbios.assert_nmi_on_serr)
      baud_rate                       = lookup(v, "baud_rate", local.lbios.baud_rate)
      cdn_enable                      = lookup(v, "cdn_enable", local.lbios.cdn_enable)
      cisco_adaptive_mem_training     = lookup(v, "cisco_adaptive_mem_training", local.lbios.cisco_adaptive_mem_training)
      cisco_debug_level               = lookup(v, "cisco_debug_level", local.lbios.cisco_debug_level)
      cisco_oprom_launch_optimization = lookup(v, "cisco_oprom_launch_optimization", local.lbios.cisco_oprom_launch_optimization)
      console_redirection             = lookup(v, "console_redirection", local.lbios.console_redirection)
      flow_control                    = lookup(v, "flow_control", local.lbios.flow_control)
      frb2enable                      = lookup(v, "frb2enable", local.lbios.frb2enable)
      legacy_os_redirection           = lookup(v, "legacy_os_redirection", local.lbios.legacy_os_redirection)
      os_boot_watchdog_timer          = lookup(v, "os_boot_watchdog_timer", local.lbios.os_boot_watchdog_timer)
      os_boot_watchdog_timer_policy   = lookup(v, "os_boot_watchdog_timer_policy", local.lbios.os_boot_watchdog_timer_policy)
      os_boot_watchdog_timer_timeout  = lookup(v, "os_boot_watchdog_timer_timeout", local.lbios.os_boot_watchdog_timer_timeout)
      out_of_band_mgmt_port           = lookup(v, "out_of_band_mgmt_port", local.lbios.out_of_band_mgmt_port)
      putty_key_pad                   = lookup(v, "putty_key_pad", local.lbios.putty_key_pad)
      redirection_after_post          = lookup(v, "redirection_after_post", local.lbios.redirection_after_post)
      terminal_type                   = lookup(v, "terminal_type", local.lbios.terminal_type)
      ucsm_boot_order_rule            = lookup(v, "ucsm_boot_order_rule", local.lbios.ucsm_boot_order_rule)
      #+++++++++++++++++++++++++++++++
      # Trusted Platform Section
      #+++++++++++++++++++++++++++++++
      cpu_pa_limit                    = lookup(v, "cpu_pa_limit", local.lbios.cpu_pa_limit)
      enable_mktme                    = lookup(v, "enable_mktme", local.lbios.enable_mktme)
      enable_sgx                      = lookup(v, "enable_sgx", local.lbios.enable_sgx)
      enable_tme                      = lookup(v, "enable_tme", local.lbios.enable_tme)
      epoch_update                    = lookup(v, "epoch_update", local.lbios.epoch_update)
      sgx_auto_registration_agent     = lookup(v, "sgx_auto_registration_agent", local.lbios.sgx_auto_registration_agent)
      sgx_epoch0                      = lookup(v, "sgx_epoch0", local.lbios.sgx_epoch0)
      sgx_epoch1                      = lookup(v, "sgx_epoch1", local.lbios.sgx_epoch1)
      sgx_factory_reset               = lookup(v, "sgx_factory_reset", local.lbios.sgx_factory_reset)
      sgx_le_pub_key_hash0            = lookup(v, "sgx_le_pub_key_hash0", local.lbios.sgx_le_pub_key_hash0)
      sgx_le_pub_key_hash1            = lookup(v, "sgx_le_pub_key_hash1", local.lbios.sgx_le_pub_key_hash1)
      sgx_le_pub_key_hash2            = lookup(v, "sgx_le_pub_key_hash2", local.lbios.sgx_le_pub_key_hash2)
      sgx_le_pub_key_hash3            = lookup(v, "sgx_le_pub_key_hash3", local.lbios.sgx_le_pub_key_hash3)
      sgx_le_wr                       = lookup(v, "sgx_le_wr", local.lbios.sgx_le_wr)
      sgx_package_info_in_band_access = lookup(v, "sgx_package_info_in_band_access", local.lbios.sgx_package_info_in_band_access)
      sgx_qos                         = lookup(v, "sgx_qos", local.lbios.sgx_qos)
      sha1pcr_bank                    = lookup(v, "sha1pcr_bank", local.lbios.sha1pcr_bank)
      sha256pcr_bank                  = lookup(v, "sha256pcr_bank", local.lbios.sha256pcr_bank)
      tpm_control                     = lookup(v, "tpm_control", local.lbios.tpm_control)
      tpm_pending_operation           = lookup(v, "tpm_pending_operation", local.lbios.tpm_pending_operation)
      tpm_ppi_required                = lookup(v, "tpm_ppi_required", local.lbios.tpm_ppi_required)
      txt_support                     = lookup(v, "txt_support", local.lbios.txt_support)
      #+++++++++++++++++++++++++++++++
      # USB Section
      #+++++++++++++++++++++++++++++++
      all_usb_devices          = lookup(v, "all_usb_devices", local.lbios.all_usb_devices)
      legacy_usb_support       = lookup(v, "legacy_usb_support", local.lbios.legacy_usb_support)
      make_device_non_bootable = lookup(v, "make_device_non_bootable", local.lbios.make_device_non_bootable)
      pch_usb30mode            = lookup(v, "pch_usb30mode", local.lbios.pch_usb30mode)
      usb_emul6064             = lookup(v, "usb_emul6064", local.lbios.usb_emul6064)
      usb_port_front           = lookup(v, "usb_port_front", local.lbios.usb_port_front)
      usb_port_internal        = lookup(v, "usb_port_internal", local.lbios.usb_port_internal)
      usb_port_kvm             = lookup(v, "usb_port_kvm", local.lbios.usb_port_kvm)
      usb_port_rear            = lookup(v, "usb_port_rear", local.lbios.usb_port_rear)
      usb_port_sd_card         = lookup(v, "usb_port_sd_card", local.lbios.usb_port_sd_card)
      usb_port_vmedia          = lookup(v, "usb_port_vmedia", local.lbios.usb_port_vmedia)
      usb_xhci_support         = lookup(v, "usb_xhci_support", local.lbios.usb_xhci_support)

    }
  }

  #__________________________________________________________________
  #
  # Intersight Boot Order Policy
  # GUI Location: Policies > Create Policy > Boot Order
  #__________________________________________________________________
  boot_order = {
    for i in lookup(local.policies, "boot_order", []) : i.name => {
      boot_devices = [
        for v in lookup(i, "boot_devices", []) : {
          additional_properties = length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.Iscsi", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(v, "bootloader_description", "")
                Name        = lookup(v, "bootloader_name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(v, "bootloader_path", "\\EFI\\BOOT\\")
              },
              InterfaceName = lookup(v, "interface_name", null)
              Port          = lookup(v, "port", 0)
              Slot          = lookup(v, "slot", "MLOM")
            }
            ) : v.object_type == "boot.Iscsi" ? jsonencode(
            {
              InterfaceName = lookup(v, "interface_name", null)
              Port          = lookup(v, "port", 0)
              Slot          = lookup(v, "slot", "MLOM")
            }
            ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.LocalDisk", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(v, "bootloader_description", "")
                Name        = lookup(v, "bootloader_name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(v, "bootloader_path", "\\EFI\\BOOT\\")
              },
              Slot = v.slot
            }
            ) : v.object_type == "boot.LocalDisk" ? jsonencode(
            {
              Slot = v.slot
            }
            ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.Nvme", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(v, "bootloader_description", "")
                Name        = lookup(v, "bootloader_name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(v, "bootloader_path", "\\EFI\\BOOT\\")
              },
            }
            ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.PchStorage", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(v, "bootloader_description", "")
                Name        = lookup(v, "bootloader_name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(v, "bootloader_path", "\\EFI\\BOOT\\")
              },
              Lun = lookup(v, "lun", 0)
            }
            ) : v.object_type == "boot.PchStorage" ? jsonencode(
            {
              Lun = lookup(v, "lun", 0)
            }
            ) : v.object_type == "boot.Pxe" ? jsonencode(
            {
              InterfaceName   = lookup(v, "interface_name", null)
              InterfaceSource = lookup(v, "interface_source", "name")
              IpType          = lookup(v, "ip_type", "IPv4")
              MacAddress      = lookup(v, "mac_ddress", "")
              Port            = lookup(v, "port", -1)
              Slot            = lookup(v, "slot", "MLOM")
            }
            ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.San", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(v, "bootloader_description", "")
                Name        = lookup(v, "bootloader_name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(v, "bootloader_path", "\\EFI\\BOOT\\")
              },
              InterfaceName = lookup(v, "interface_name", null)
              Lun           = lookup(v, "lun", 0)
              Slot          = lookup(v, "slot", "MLOM")
              Wwpn          = lookup(v, "wwpn", "")
            }
            ) : v.object_type == "boot.San" ? jsonencode(
            {
              InterfaceName = lookup(v, "interface_name", null)
              Lun           = lookup(v, "lun", 0)
              Slot          = lookup(v, "slot", "MLOM")
              Wwpn          = lookup(v, "wwpn", "")
            }
            ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.SdCard", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(v, "bootloader_description", "")
                Name        = lookup(v, "bootloader_name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(v, "bootloader_path", "\\EFI\\BOOT\\")
              },
              Lun     = lookup(v, "lun", 0)
              Subtype = lookup(v, "sub_type", "None")
            }
            ) : v.object_type == "boot.SdCard" ? jsonencode(
            {
              Lun     = lookup(v, "lun", 0)
              Subtype = lookup(v, "sub_type", "None")
            }
            ) : v.object_type == "boot.Usb" ? jsonencode(
            {
              Subtype = lookup(v, "sub_type", "None")
            }
            ) : v.object_type == "boot.VirtualMedia" ? jsonencode(
            {
              Subtype = lookup(v, "sub_type", "None")
            }
          ) : ""
          enabled     = lookup(v, "enabled", true)
          name        = v.name
          object_type = v.object_type
        }
      ]
      boot_mode   = lookup(i, "boot_mode", local.lboot.boot_mode)
      description = lookup(i, "description", "")
      enable_secure_boot = lookup(
        i, "enable_secure_boot", local.lboot.enable_secure_boot
      )
      name         = "${local.name_prefix}${i.name}${local.lboot.name_suffix}"
      organization = lookup(i, "organization", var.organization)
      tags         = lookup(i, "tags", var.tags)
    }
  }

  #__________________________________________________________________
  #
  # Intersight Ethernet Adapter Policy
  # GUI Location: Policies > Create Policy > Ethernet Adapter
  #__________________________________________________________________
  ethernet_adapter = {
    for v in lookup(local.policies, "ethernet_adapter", []) : v.name => {
      adapter_template       = lookup(v, "adapter_template", "")
      completion_queue_count = lookup(v, "completion_queue_count", local.leadapter.completion_queue_count)
      completion_ring_size   = lookup(v, "completion_ring_size", local.leadapter.completion_ring_size)
      description            = lookup(v, "description", "")
      enable_accelerated_receive_flow_steering = lookup(
        v, "enable_accelerated_receive_flow_steering", local.leadapter.enable_accelerated_receive_flow_steering
      )
      enable_advanced_filter   = lookup(v, "enable_advanced_filter", local.leadapter.enable_advanced_filter)
      enable_geneve_offload    = lookup(v, "enable_geneve_offload", local.leadapter.enable_geneve_offload)
      enable_interrupt_scaling = lookup(v, "enable_interrupt_scaling", local.leadapter.enable_interrupt_scaling)
      enable_nvgre_offload     = lookup(v, "enable_nvgre_offload", local.leadapter.enable_nvgre_offload)
      enable_vxlan_offload     = lookup(v, "enable_vxlan_offload", local.leadapter.enable_vxlan_offload)
      interrupt_coalescing_type = lookup(
        v, "interrupt_coalescing_type", local.leadapter.interrupt_coalescing_type
      )
      interrupt_mode  = lookup(v, "interrupt_mode", local.leadapter.interrupt_mode)
      interrupt_timer = lookup(v, "interrupt_timer", local.leadapter.interrupt_timer)
      interrupts      = lookup(v, "interrupts", local.leadapter.interrupts)
      name            = "${local.name_prefix}${v.name}${local.leadapter.name_suffix}"
      organization    = lookup(v, "organization", var.organization)
      receive_side_scaling_enable = lookup(
        v, "receive_side_scaling_enable", local.leadapter.receive_side_scaling_enable
      )
      roce_cos             = lookup(v, "roce_cos", local.leadapter.roce_cos)
      roce_enable          = lookup(v, "roce_enable", local.leadapter.roce_enable)
      roce_memory_regions  = lookup(v, "roce_memory_regions", local.leadapter.roce_memory_regions)
      roce_queue_pairs     = lookup(v, "roce_queue_pairs", local.leadapter.roce_queue_pairs)
      roce_resource_groups = lookup(v, "roce_resource_groups", local.leadapter.roce_resource_groups)
      roce_version         = lookup(v, "roce_version", local.leadapter.roce_version)
      rss_enable_ipv4_hash = lookup(v, "rss_enable_ipv4_hash", local.leadapter.rss_enable_ipv4_hash)
      rss_enable_ipv6_extensions_hash = lookup(
        v, "rss_enable_ipv6_extensions_hash", local.leadapter.rss_enable_ipv6_extensions_hash
      )
      rss_enable_ipv6_hash = lookup(v, "rss_enable_ipv6_hash", local.leadapter.rss_enable_ipv6_hash)
      rss_enable_tcp_and_ipv4_hash = lookup(
        v, "rss_enable_tcp_and_ipv4_hash", local.leadapter.rss_enable_tcp_and_ipv4_hash
      )
      rss_enable_tcp_and_ipv6_extensions_hash = lookup(
        v, "rss_enable_tcp_and_ipv6_extensions_hash", local.leadapter.rss_enable_tcp_and_ipv6_extensions_hash
      )
      rss_enable_tcp_and_ipv6_hash = lookup(
        v, "rss_enable_tcp_and_ipv6_hash", local.leadapter.rss_enable_tcp_and_ipv6_hash
      )
      rss_enable_udp_and_ipv4_hash = lookup(
        v, "rss_enable_udp_and_ipv4_hash", local.leadapter.rss_enable_udp_and_ipv4_hash
      )
      rss_enable_udp_and_ipv6_hash = lookup(
        v, "rss_enable_udp_and_ipv6_hash", local.leadapter.rss_enable_udp_and_ipv6_hash
      )
      receive_queue_count       = lookup(v, "receive_queue_count", local.leadapter.receive_queue_count)
      receive_ring_size         = lookup(v, "receive_ring_size", local.leadapter.receive_ring_size)
      tags                      = lookup(v, "tags", var.tags)
      tcp_offload_large_recieve = lookup(v, "tcp_offload_large_recieve", local.leadapter.tcp_offload_large_recieve)
      tcp_offload_large_send    = lookup(v, "tcp_offload_large_send", local.leadapter.tcp_offload_large_send)
      tcp_offload_rx_checksum   = lookup(v, "tcp_offload_rx_checksum", local.leadapter.tcp_offload_rx_checksum)
      tcp_offload_tx_checksum   = lookup(v, "tcp_offload_tx_checksum", local.leadapter.tcp_offload_tx_checksum)
      transmit_queue_count      = lookup(v, "transmit_queue_count", local.leadapter.transmit_queue_count)
      transmit_ring_size        = lookup(v, "transmit_ring_size", local.leadapter.transmit_ring_size)
      uplink_failback_timeout   = lookup(v, "uplink_failback_timeout", local.leadapter.uplink_failback_timeout)
    }
  }

  #__________________________________________________________________
  #
  # Intersight Fibre Channel Adapter Policy
  # GUI Location: Policies > Create Policy > Fibre Channel Adapter
  #__________________________________________________________________
  fibre_channel_adapter = {
    for v in lookup(local.policies, "fibre_channel_adapter", []) : v.name => {
      adapter_template          = lookup(v, "adapter_template", "")
      description               = lookup(v, "description", "")
      error_detection_timeout   = lookup(v, "error_detection_timeout", local.lfadapter.error_detection_timeout)
      enable_fcp_error_recovery = lookup(v, "enable_fcp_error_recovery", local.lfadapter.enable_fcp_error_recovery)
      error_recovery_io_retry_timeout = lookup(
        v, "error_recovery_io_retry_timeout", local.lfadapter.error_recovery_io_retry_timeout
      )
      error_recovery_link_down_timeout = lookup(
        v, "error_recovery_link_down_timeout", local.lfadapter.error_recovery_link_down_timeout
      )
      error_recovery_port_down_io_retry = lookup(
        v, "error_recovery_port_down_io_retry", local.lfadapter.error_recovery_port_down_io_retry
      )
      error_recovery_port_down_timeout = lookup(
        v, "error_recovery_port_down_timeout", local.lfadapter.error_recovery_port_down_timeout
      )
      flogi_retries       = lookup(v, "flogi_retries", local.lfadapter.flogi_retries)
      flogi_timeout       = lookup(v, "flogi_timeout", local.lfadapter.flogi_timeout)
      interrupt_mode      = lookup(v, "interrupt_mode", local.lfadapter.interrupt_mode)
      io_throttle_count   = lookup(v, "io_throttle_count", local.lfadapter.io_throttle_count)
      lun_queue_depth     = lookup(v, "lun_queue_depth", local.lfadapter.lun_queue_depth)
      max_luns_per_target = lookup(v, "max_luns_per_target", local.lfadapter.max_luns_per_target)
      name                = "${local.name_prefix}${v.name}${local.lfadapter.name_suffix}"
      organization        = lookup(v, "organization", var.organization)
      plogi_retries       = lookup(v, "plogi_retries", local.lfadapter.plogi_retries)
      plogi_timeout       = lookup(v, "plogi_timeout", local.lfadapter.plogi_timeout)
      receive_ring_size   = lookup(v, "receive_ring_size", local.lfadapter.receive_ring_size)
      resource_allocation_timeout = lookup(
        v, "resource_allocation_timeout", local.lfadapter.resource_allocation_timeout
      )
      scsi_io_queue_count = lookup(v, "scsi_io_queue_count", local.lfadapter.scsi_io_queue_count)
      scsi_io_ring_size   = lookup(v, "scsi_io_ring_size", local.lfadapter.scsi_io_ring_size)
      tags                = lookup(v, "tags", var.tags)
      transmit_ring_size  = lookup(v, "transmit_ring_size", local.lfadapter.transmit_ring_size)
    }
  }

  #_________________________________________________________________________
  #
  # Intersight LAN Connectivity
  # GUI Location: Configure > Policies > Create Policy > LAN Connectivity
  #_________________________________________________________________________
  lan_connectivity = {
    for v in lookup(local.policies, "lan_connectivity", []) : v.name => {
      description = lookup(v, "description", "")
      enable_azure_stack_host_qos = lookup(
        v, "enable_azure_stack_host_qos", local.lancon.enable_azure_stack_host_qos
      )
      iqn_allocation_type = lookup(
        v, "iqn_allocation_type", local.lancon.iqn_allocation_type
      )
      iqn_pool = length(compact([lookup(v, "iqn_pool", "")])) > 0 ? var.pools.iqn[v.iqn_pool].moid : ""
      iqn_static_identifier = lookup(
        v, "iqn_static_identifier", ""
      )
      name            = "${local.name_prefix}${v.name}${local.lancon.name_suffix}"
      organization    = lookup(v, "organization", var.organization)
      tags            = lookup(v, "tags", var.tags)
      target_platform = lookup(v, "target_platform", local.lancon.target_platform)
      vnic_placement_mode = lookup(
        v, "vnic_placement_mode", local.lancon.vnic_placement_mode
      )
      vnics = [
        for v in lookup(v, "vnics", []) : {
          cdn_source      = lookup(v, "cdn_source", local.lancon.vnics.cdn_source)
          cdn_values      = lookup(v, "cdn_values", local.lancon.vnics.cdn_values)
          enable_failover = lookup(v, "enable_failover", null)
          ethernet_adapter_policy = lookup(
            v, "ethernet_adapter_policy", local.lancon.vnics.ethernet_adapter_policy
          )
          ethernet_network_control_policy = lookup(
            v, "ethernet_network_control_policy", local.lancon.vnics.ethernet_network_control_policy
          )
          ethernet_network_group_policy = lookup(
            v, "ethernet_network_group_policy", local.lancon.vnics.ethernet_network_group_policy
          )
          ethernet_network_policy = lookup(
            v, "ethernet_network_policy", local.lancon.vnics.ethernet_network_policy
          )
          ethernet_qos_policy = lookup(
            v, "ethernet_qos_policy", local.lancon.vnics.ethernet_qos_policy
          )
          iscsi_boot_policy = lookup(
            v, "iscsi_boot_policy", local.lancon.vnics.iscsi_boot_policy
          )
          mac_address_allocation_type = lookup(
            v, "mac_address_allocation_type", local.lancon.vnics.mac_address_allocation_type
          )
          mac_address_pools    = lookup(v, "mac_address_pools", local.lancon.vnics.mac_address_pools)
          mac_addresses_static = lookup(v, "mac_addresses_static", [])
          names                = v.names
          placement_pci_links = lookup(
            v, "placement_pci_links", local.lancon.vnics.placement_pci_links
          )
          placement_pci_order = lookup(
            v, "placement_pci_order", local.lancon.vnics.placement_pci_order
          )
          placement_slot_ids = lookup(
            v, "placement_slot_ids", local.lancon.vnics.placement_slot_ids
          )
          placement_switch_id = lookup(
            v, "placement_switch_id", local.lancon.vnics.placement_switch_id
          )
          placement_uplink_ports = lookup(
            v, "placement_uplink_ports", local.lancon.vnics.placement_uplink_ports
          )
          usnic_adapter_policy = lookup(v, "usnic_adapter_policy", local.lancon.vnics.usnic_adapter_policy)
          usnic_number_of_usnics = lookup(
            v, "usnic_number_of_usnics", local.lancon.vnics.usnic_number_of_usnics
          )
          vmq_enable_virtual_machine_multi_queue = lookup(
            v, "vmq_enable_virtual_machine_multi_queue", local.lancon.vnics.vmq_enable_virtual_machine_multi_queue
          )
          vmq_enabled              = lookup(v, "vmq_enabled", local.lancon.vnics.vmq_enabled)
          vmq_number_of_interrupts = lookup(v, "vmq_number_of_interrupts", local.lancon.vnics.vmq_number_of_interrupts)
          vmq_number_of_sub_vnics  = lookup(v, "vmq_number_of_sub_vnics", local.lancon.vnics.vmq_number_of_sub_vnics)
          vmq_number_of_virtual_machine_queues = lookup(
            v, "vmq_number_of_virtual_machine_queues", local.lancon.vnics.vmq_number_of_virtual_machine_queues
          )
          vmq_vmmq_adapter_policy = lookup(v, "vmq_vmmq_adapter_policy", local.lancon.vnics.vmq_vmmq_adapter_policy)
        }
      ]
    }
  }
  vnics = { for i in flatten([
    for value in local.lan_connectivity : [
      for v in value.vnics : [
        for s in range(length(v.names)) : {
          cdn_source = v.cdn_source
          cdn_value  = length(v.cdn_values) > 0 ? element(v.cdn_values, s) : ""
          enable_failover = length(compact([v.enable_failover])
          ) > 0 ? v.enable_failover : length(v.names) == 1 ? true : local.lancon.vnics.enable_failover
          ethernet_adapter_policy         = v.ethernet_adapter_policy
          ethernet_network_control_policy = v.ethernet_network_control_policy
          ethernet_network_group_policy   = v.ethernet_network_group_policy
          ethernet_network_policy         = v.ethernet_network_policy
          ethernet_qos_policy             = v.ethernet_qos_policy
          iscsi_boot_policy               = v.iscsi_boot_policy
          lan_connectivity                = value.name
          mac_address_allocation_type     = v.mac_address_allocation_type
          mac_address_pool = length(v.mac_address_pools
          ) > 0 ? element(v.mac_address_pools, s) : ""
          mac_address_static = length(lookup(v, "mac_addresses_static", [])
          ) > 0 ? element(v.mac_addresses_static, s) : ""
          name = element(v.names, s)
          placement_pci_link = length(v.placement_pci_links) == 1 ? element(
            v.placement_pci_links, 0) : element(v.placement_pci_links, s
          )
          placement_pci_order = element(v.placement_pci_order, s)
          placement_slot_id = length(v.placement_slot_ids) == 1 ? element(
            v.placement_slot_ids, 0) : element(v.placement_slot_ids, s
          )
          placement_switch_id = length(compact(
            [v.placement_switch_id])
          ) > 0 ? v.placement_switch_id : index(v.names, element(v.names, s)) == 0 ? "A" : "B"
          placement_uplink_port = length(v.placement_uplink_ports) == 1 ? element(
            v.placement_uplink_ports, 0) : element(v.placement_uplink_ports, s
          )
          tags                                   = value.tags
          usnic_adapter_policy                   = v.usnic_adapter_policy
          usnic_class_of_service                 = lookup(v, "usnic_class_of_service", 5)
          usnic_number_of_usnics                 = lookup(v, "usnic_number_of_usnics", 0)
          vmq_enable_virtual_machine_multi_queue = v.vmq_enable_virtual_machine_multi_queue
          vmq_enabled                            = v.vmq_enabled
          vmq_number_of_interrupts               = lookup(v, "vmq_number_of_interrupts", 16)
          vmq_number_of_sub_vnics                = lookup(v, "vmq_number_of_sub_vnics", 64)
          vmq_number_of_virtual_machine_queues   = lookup(v, "vmq_number_of_virtual_machine_queues", 4)
          vmq_vmmq_adapter_policy                = v.vmq_vmmq_adapter_policy
        }
      ]
    ]
  ]) : "${i.lan_connectivity}:${i.name}" => i }

  #__________________________________________________________________
  #
  # Intersight LDAP Policy
  # GUI Location: Policies > Create Policy > LDAP
  #__________________________________________________________________
  ldap = {
    for v in lookup(local.policies, "ldap", []) : v.name => {
      base_settings = {
        base_dn = v.base_settings.base_dn
        domain  = v.base_settings.domain
        timeout = lookup(v.base_settings, "timeout", local.lldap.base_settings.timeout)
      }
      binding_parameters = {
        bind_dn     = lookup(v.binding_parameters, "bind_dn", local.lldap.binding_parameters.bind_dn)
        bind_method = lookup(v.binding_parameters, "timeout", local.lldap.binding_parameters.bind_method)
      }
      binding_parameters_password = var.binding_parameters_password
      description                 = lookup(v, "description", "")
      enable_encryption           = lookup(v, "enable_encryption", local.lldap.enable_encryption)
      enable_group_authorization = lookup(
        v, "enable_group_authorization", local.lldap.enable_group_authorization
      )
      enable_ldap = lookup(v, "enable_ldap", local.lldap.enable_ldap)
      ldap_from_dns = {
        enable = lookup(lookup(
        v, "ldap_from_dns", {}), "enable", local.lldap.ldap_from_dns.enable)
        search_domain = lookup(lookup(
        v, "ldap_from_dns", {}), "search_domain", local.lldap.ldap_from_dns.search_domain)
        search_forest = lookup(lookup(
        v, "ldap_from_dns", {}), "search_forest", local.lldap.ldap_from_dns.search_forest)
        source = lookup(lookup(
        v, "ldap_from_dns", {}), "source", local.lldap.ldap_from_dns.source)
      }
      ldap_groups    = lookup(v, "ldap_groups", [])
      ldap_providers = lookup(v, "ldap_providers", [])
      name           = "${local.name_prefix}${v.name}${local.lldap.name_suffix}"
      nested_group_search_depth = lookup(
      v, "nested_group_search_depth", local.lldap.nested_group_search_depth)
      organization = lookup(v, "organization", var.organization)
      search_parameters = {
        attribute = lookup(
        v.search_parameters, "attribute", local.lldap.search_parameters.attribute)
        filter = lookup(
        v.search_parameters, "filter", local.lldap.search_parameters.filter)
        group_attribute = lookup(
        v.search_parameters, "group_attribute", local.lldap.search_parameters.group_attribute)
      }
      tags = lookup(v, "tags", var.tags)
      user_search_precedence = lookup(
        v, "user_search_precedence", local.lldap.user_search_precedence
      )
    }
  }
  ldap_groups = { for i in flatten([
    for value in local.ldap : [
      for v in value.ldap_groups : {
        domain        = lookup(v, "domain", "")
        base_settings = value.base_settings
        ldap_policy   = value.name
        name          = v.name
        role          = v.role
      }
    ]
  ]) : "${i.ldap_policy}:${i.name}" => i }
  ldap_providers = { for i in flatten([
    for value in local.ldap : [
      for v in value.ldap_providers : {
        ldap_policy = value.name
        port        = lookup(v, "port", local.lldap.ldap_providers.port)
        server      = v.server
      }
    ]
  ]) : "${i.ldap_policy}:${i.server}" => i }
  roles = distinct(concat(
    [for v in local.ldap_groups : v.role],
    [for v in local.users : v.role],
  ))

  #__________________________________________________________________
  #
  # Intersight Local User Policy
  # GUI Location: Policies > Create Policy > Local User
  #__________________________________________________________________
  local_user = {
    for v in lookup(local.policies, "local_user", []) : v.name => {
      always_send_user_password = lookup(
        v, "always_send_user_password", local.luser.always_send_user_password
      )
      description = lookup(v, "description", "")
      enable_password_expiry = lookup(
        v, "enable_password_expiry", local.luser.enable_password_expiry
      )
      enforce_strong_password = lookup(
        v, "enforce_strong_password", local.luser.enforce_strong_password
      )
      grace_period = lookup(v, "grace_period", local.luser.grace_period)
      name         = "${local.name_prefix}${v.name}${local.luser.name_suffix}"
      notification_period = lookup(
        v, "notification_period", local.luser.notification_period
      )
      organization = lookup(v, "organization", var.organization)
      password_expiry_duration = lookup(
        v, "password_expiry_duration", local.luser.password_expiry_duration
      )
      password_history = lookup(
        v, "password_history", local.luser.password_history
      )
      tags  = lookup(v, "tags", var.tags)
      users = lookup(v, "users", [])
    }
  }
  users = { for i in flatten([
    for value in local.local_user : [
      for v in value.users : {
        enabled      = lookup(v, "enabled", true)
        local_user   = value.name
        name         = v.username
        organization = value.organization
        password     = lookup(v, "password", 1)
        role         = lookup(v, "role", "readonly")
        tags         = value.tags
      }
    ]
  ]) : "${i.local_user}:${i.name}" => i }

  #__________________________________________________________________
  #
  # Intersight Network Connectivity Policy
  # GUI Location: Policies > Create Policy > Network Connectivity
  #__________________________________________________________________
  network_connectivity = {
    for v in lookup(local.policies, "network_connectivity", []) : v.name => {
      description        = lookup(v, "description", "")
      dns_servers_v4     = lookup(v, "dns_servers_v4", local.ldns.dns_servers_v4)
      dns_servers_v6     = lookup(v, "dns_servers_v6", local.ldns.dns_servers_v6)
      enable_dynamic_dns = lookup(v, "enable_dynamic_dns", local.ldns.enable_dynamic_dns)
      enable_ipv6        = lookup(v, "enable_ipv6", local.ldns.enable_ipv6)
      name               = "${local.name_prefix}${v.name}${local.ldns.name_suffix}"
      obtain_ipv4_dns_from_dhcp = lookup(
        v, "obtain_ipv4_dns_from_dhcp", local.ldns.obtain_ipv4_dns_from_dhcp
      )
      obtain_ipv6_dns_from_dhcp = lookup(
        v, "obtain_ipv6_dns_from_dhcp", local.ldns.obtain_ipv6_dns_from_dhcp
      )
      organization = lookup(v, "organization", var.organization)
      #profiles     = []
      profiles = [
        for i in var.domains : {
          name        = i.name
          object_type = "fabric.SwitchProfile"
          } if length(regexall(
          "^${local.name_prefix}${v.name}${local.ldns.name_suffix}$", i.network_connectivity)
        ) > 0
      ]
      tags          = lookup(v, "tags", var.tags)
      update_domain = lookup(v, "update_domain", local.ldns.update_domain)
    }
  }

  #__________________________________________________________________
  #
  # Intersight NTP Policy
  # GUI Location: Policies > Create Policy > NTP
  #__________________________________________________________________
  ntp = {
    for v in lookup(local.policies, "ntp", []) : v.name => {
      description  = lookup(v, "description", "")
      enabled      = lookup(v, "enabled", local.lntp.enabled)
      name         = "${local.name_prefix}${v.name}${local.lntp.name_suffix}"
      ntp_servers  = lookup(v, "ntp_servers", local.lntp.ntp_servers)
      organization = lookup(v, "organization", var.organization)
      #profiles     = []
      profiles = [
        for i in var.domains : {
          name        = i.name
          object_type = "fabric.SwitchProfile"
          } if length(regexall(
          "^${local.name_prefix}${v.name}${local.lntp.name_suffix}$", i.ntp)
        ) > 0
      ]
      tags     = lookup(v, "tags", var.tags)
      timezone = lookup(v, "timezone", local.lntp.timezone)
    }
  }

  #__________________________________________________________________
  #
  # Intersight Persistent Memory Policy
  # GUI Location: Policies > Create Policy > Persistent Memory
  #__________________________________________________________________
  persistent_memory = {
    for v in lookup(local.policies, "persistent_memory", []) : v.name => {
      description     = lookup(v, "description", "")
      management_mode = lookup(v, "management_mode", local.lpmem.management_mode)
      memory_mode_percentage = lookup(
        v, "memory_mode_percentage", local.lpmem.memory_mode_percentage
      )
      name = "${local.name_prefix}${v.name}${local.lpmem.name_suffix}"
      namespaces = [for v in lookup(v, "namespaces", []) :
        {
          capacity         = v.capacity
          mode             = lookup(v, "mode", local.lpmem.namespaces.mode)
          name             = v.name
          socket_id        = lookup(v, "socket_id", local.lpmem.namespaces.socket_id)
          socket_memory_id = lookup(v, "socket_memory_id", local.lpmem.namespaces.socket_memory_id)
        }
      ]
      organization = lookup(v, "organization", var.organization)
      persistent_memory_type = lookup(
        v, "persistent_memory_type", local.lpmem.persistent_memory_type
      )
      persistent_passphrase = var.persistent_passphrase
      retain_namespaces     = lookup(v, "retain_namespaces", local.lpmem.retain_namespaces)
      secure_passphrase     = var.persistent_passphrase != "" ? true : false
      tags                  = lookup(v, "tags", var.tags)
    }
  }

  #__________________________________________________________________
  #
  # Intersight Port Policy
  # GUI Location: Policies > Create Policy > Port
  #__________________________________________________________________

  port = { for s in flatten([
    for value in lookup(local.policies, "port", []) : [
      for i in range(length(value.names)) : {
        description  = lookup(value, "description", "")
        device_model = lookup(value, "device_model", local.lport.device_model)
        name         = "${element(value.names, i)}${local.lport.name_suffix}"
        organization = lookup(value, "organization", var.organization)
        port_channel_appliances = [
          for v in lookup(value, "port_channel_appliances", []) : {
            admin_speed = lookup(v, "admin_speed", local.lport.port_channel_appliances.admin_speed)
            ethernet_network_control_policy = lookup(
              v, "ethernet_network_control_policy", local.lport.port_channel_appliances.ethernet_network_control_policy
            )
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.lport.port_channel_appliances.ethernet_network_group_policy
            )
            interfaces = lookup(v, "interfaces", [])
            mode       = lookup(v, "mode", local.lport.port_channel_appliances.mode)
            pc_id      = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
            priority   = lookup(v, "priority", local.lport.port_channel_appliances.priority)
          }
        ]
        port_channel_ethernet_uplinks = [
          for v in lookup(value, "port_channel_ethernet_uplinks", []) : {
            admin_speed = lookup(v, "admin_speed", local.lport.port_channel_ethernet_uplinks.admin_speed)
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.lport.port_channel_ethernet_uplinks.ethernet_network_group_policy
            )
            flow_control_policy = lookup(
              v, "flow_control_policy", local.lport.port_channel_ethernet_uplinks.flow_control_policy
            )
            interfaces = lookup(v, "interfaces", [])
            link_aggregation_policy = lookup(
              v, "link_aggregation_policy", local.lport.port_channel_ethernet_uplinks.link_aggregation_policy
            )
            link_control_policy = lookup(
              v, "link_control_policy", local.lport.port_channel_ethernet_uplinks.link_control_policy
            )
            pc_id = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
          }
        ]
        port_channel_fc_uplinks = [
          for v in lookup(value, "port_channel_fc_uplinks", []) : {
            admin_speed  = lookup(v, "admin_speed", local.lport.port_channel_fc_uplinks.admin_speed)
            fill_pattern = lookup(v, "fill_pattern", local.lport.port_channel_fc_uplinks.fill_pattern)
            interfaces   = lookup(v, "interfaces", [])
            pc_id        = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
            vsan_id      = length(v.vsan_ids) == 1 ? element(v.vsan_ids, 0) : element(v.vsan_ids, i)
          }
        ]
        port_channel_fcoe_uplinks = [
          for v in lookup(value, "port_channel_fcoe_uplinks", []) : {
            admin_speed = lookup(v, "admin_speed", local.lport.port_channel_fcoe_uplinks.admin_speed)
            interfaces  = lookup(v, "interfaces", [])
            link_aggregation_policy = lookup(
              v, "link_aggregation_policy", local.lport.port_channel_fcoe_uplinks.link_aggregation_policy
            )
            link_control_policy = lookup(
              v, "link_control_policy", local.lport.port_channel_fcoe_uplinks.link_control_policy
            )
            pc_id = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
          }
        ]
        port_modes = [
          for v in lookup(value, "port_modes", []) : {
            custom_mode = lookup(v, "custom_mode", local.lport.port_modes.custom_mode)
            port_list   = v.port_list
            slot_id     = lookup(v, "slot_id", 1)
          }
        ]
        port_role_appliances = [
          for v in lookup(value, "port_role_appliances", []) : {
            admin_speed      = lookup(v, "admin_speed", local.lport.port_role_appliances.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            ethernet_network_control_policy = lookup(
              v, "ethernet_network_control_policy", local.lport.port_role_appliances.ethernet_network_control_policy
            )
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.lport.port_role_appliances.ethernet_network_group_policy
            )
            fec       = lookup(v, "fec", local.lport.port_role_appliances.fec)
            mode      = lookup(v, "mode", local.lport.port_role_appliances.mode)
            port_list = v.port_list
            priority  = lookup(v, "priority", local.lport.port_role_appliances.priority)
            slot_id   = lookup(v, "slot_id", 1)
          }
        ]
        port_role_ethernet_uplinks = [
          for v in lookup(value, "port_role_ethernet_uplinks", []) : {
            admin_speed      = lookup(v, "admin_speed", local.lport.port_role_ethernet_uplinks.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            ethernet_network_group_policy = lookup(
              v, "ethernet_network_group_policy", local.lport.port_role_ethernet_uplinks.ethernet_network_group_policy
            )
            fec = lookup(v, "fec", local.lport.port_role_ethernet_uplinks.fec)
            flow_control_policy = lookup(
              v, "flow_control_policy", local.lport.port_role_ethernet_uplinks.flow_control_policy
            )
            link_control_policy = lookup(
              v, "link_control_policy", local.lport.port_role_ethernet_uplinks.link_control_policy
            )
            port_list = v.port_list
            slot_id   = lookup(v, "slot_id", 1)
          }
        ]
        port_role_fc_storage = [
          for v in lookup(value, "port_role_fc_storage", []) : {
            admin_speed      = lookup(v, "admin_speed", local.lport.port_role_fc_storage.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            port_list        = v.port_list
            slot_id          = lookup(v, "slot_id", 1)
            vsan_id          = v.vsan_id
          }
        ]
        port_role_fc_uplinks = [
          for v in lookup(value, "port_role_fc_uplinks", []) : {
            admin_speed      = lookup(v, "admin_speed", local.lport.port_role_fc_uplinks.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            fill_pattern     = lookup(v, "fill_pattern", local.lport.port_role_fc_uplinks.fill_pattern)
            port_list        = v.port_list
            slot_id          = lookup(v, "slot_id", 1)
            vsan_id          = v.vsan_id
          }
        ]
        port_role_fcoe_uplinks = [
          for v in lookup(value, "port_role_fcoe_uplinks", []) : {
            admin_speed      = lookup(v, "admin_speed", local.lport.port_role_fcoe_uplinks.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            interfaces       = lookup(v, "interfaces", [])
            fec              = lookup(v, "fec", local.lport.port_role_fcoe_uplinks.fec)
            link_control_policy = lookup(
              v, "link_control_policy", local.lport.port_role_fcoe_uplinks.link_control_policy
            )
            port_list = v.port_list
            slot_id   = lookup(v, "slot_id", 1)
          }
        ]
        port_role_servers = [
          for v in lookup(value, "port_role_servers", []) : {
            auto_negotiation      = lookup(v, "auto_negotiation", local.lport.port_role_servers.auto_negotiation)
            breakout_port_id      = lookup(v, "breakout_port_id", local.lport.port_role_servers.breakout_port_id)
            connected_device_type = lookup(v, "connected_device_type", local.lport.port_role_servers.connected_device_type)
            device_number         = lookup(v, "device_number", local.lport.port_role_servers.device_number)
            fec                   = lookup(v, "fec", local.lport.port_role_servers.fec)
            port_list             = v.port_list
            slot_id               = lookup(v, "slot_id", 1)
          }
        ]
        #profiles = []
        profiles = [
          for v in var.domains : v.name if length(regexall(
            "^${local.name_prefix}${element(value.names, i)}${local.lport.name_suffix}$", v.port)
          ) > 0
        ]
        tags = lookup(value, "tags", var.tags)

      }
    ]
  ]) : "${s.name}" => s }
  port_channel_appliances = { for i in flatten([
    for value in local.port : [
      for v in value.port_channel_appliances : {
        admin_speed                     = v.admin_speed
        ethernet_network_control_policy = v.ethernet_network_control_policy
        ethernet_network_group_policy   = v.ethernet_network_group_policy
        interfaces                      = v.interfaces
        mode                            = v.mode
        pc_id                           = v.pc_id
        port_policy                     = value.name
        priority                        = v.priority
        tags                            = value.tags
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_ethernet_uplinks = { for i in flatten([
    for value in local.port : [
      for v in value.port_channel_ethernet_uplinks : {
        admin_speed                   = v.admin_speed
        ethernet_network_group_policy = v.ethernet_network_group_policy
        flow_control_policy           = v.flow_control_policy
        interfaces                    = v.interfaces
        link_aggregation_policy       = v.link_aggregation_policy
        link_control_policy           = v.link_control_policy
        pc_id                         = v.pc_id
        port_policy                   = value.name
        tags                          = value.tags
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_fc_uplinks = { for i in flatten([
    for value in local.port : [
      for v in value.port_channel_fc_uplinks : {
        admin_speed  = v.admin_speed
        fill_pattern = v.fill_pattern
        interfaces   = v.interfaces
        pc_id        = v.pc_id
        port_policy  = value.name
        tags         = value.tags
        vsan_id      = v.vsan_id
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_fcoe_uplinks = { for i in flatten([
    for value in local.port : [
      for v in value.port_channel_fcoe_uplinks : {
        admin_speed             = v.admin_speed
        interfaces              = v.interfaces
        link_aggregation_policy = v.link_aggregation_policy
        link_control_policy     = v.link_control_policy
        pc_id                   = v.pc_id
        port_policy             = value.name
        tags                    = value.tags
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_modes = { for i in flatten([
    for value in local.port : [
      for v in value.port_modes : {
        custom_mode = v.custom_mode
        port_list   = v.port_list
        port_policy = value.name
        slot_id     = v.slot_id
        tags        = value.tags
      }
    ]
  ]) : "${i.port_policy}:${i.slot_id}-${element(i.port_list, 0)}" => i }
  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_appliances_loop = flatten([
    for value in local.port : [
      for v in value.port_role_appliances : {
        admin_speed                     = v.admin_speed
        breakout_port_id                = v.breakout_port_id
        ethernet_network_control_policy = v.ethernet_network_control_policy
        ethernet_network_group_policy   = v.ethernet_network_group_policy
        fec                             = v.fec
        mode                            = v.mode
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = value.name
        priority    = v.priority
        slot_id     = v.slot_id
        tags        = value.tags
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_appliances = { for i in flatten([
    for v in local.port_role_appliances_loop : [
      for s in v.port_list : {
        admin_speed                     = v.admin_speed
        breakout_port_id                = v.breakout_port_id
        ethernet_network_control_policy = v.ethernet_network_control_policy
        ethernet_network_group_policy   = v.ethernet_network_group_policy
        fec                             = v.fec
        mode                            = v.mode
        port_id                         = s
        port_policy                     = v.port_policy
        priority                        = v.priority
        slot_id                         = v.slot_id
        tags                            = v.tags
      }
    ]
  ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #_________________________________________________________________
  #
  # Port Policy > Port Roles > Ethernet Uplinks Section - Locals
  #_________________________________________________________________
  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_ethernet_uplinks_loop = flatten([
    for value in local.port : [
      for v in value.port_role_ethernet_uplinks : {
        admin_speed                   = v.admin_speed
        breakout_port_id              = v.breakout_port_id
        ethernet_network_group_policy = v.ethernet_network_group_policy
        fec                           = v.fec
        flow_control_policy           = v.flow_control_policy
        link_control_policy           = v.link_control_policy
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = value.name
        slot_id     = v.slot_id
        tags        = value.tags
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_ethernet_uplinks = { for i in flatten([
    for v in local.port_role_ethernet_uplinks_loop : [
      for s in v.port_list : {
        admin_speed                   = v.admin_speed
        breakout_port_id              = v.breakout_port_id
        ethernet_network_group_policy = v.ethernet_network_group_policy
        fec                           = v.fec
        flow_control_policy           = v.flow_control_policy
        link_control_policy           = v.link_control_policy
        port_id                       = s
        port_policy                   = v.port_policy
        slot_id                       = v.slot_id
        tags                          = v.tags
      }
    ]
  ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #______________________________________________________________________
  #
  # Port Policy > Port Roles > Fibre-Channel Storage Section - Locals
  #______________________________________________________________________
  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_fc_storage_loop = flatten([
    for value in local.port : [
      for v in value.port_role_fc_storage : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = value.name
        slot_id     = v.slot_id
        tags        = value.tags
        vsan_id     = v.vsan_id
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fc_storage = { for i in flatten([
    for v in local.port_role_fc_storage_loop : [
      for s in v.port_list : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_id          = s
        port_policy      = v.port_policy
        slot_id          = v.slot_id
        tags             = v.tags
        vsan_id          = v.vsan_id
      }
    ]
  ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #______________________________________________________________________
  #
  # Port Policy > Port Roles > Fibre-Channel Uplinks Section - Locals
  #______________________________________________________________________
  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_fc_uplinks_loop = flatten([
    for value in local.port : [
      for v in value.port_role_fc_uplinks : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = value.name
        slot_id     = v.slot_id
        tags        = value.tags
        vsan_id     = v.vsan_id
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fc_uplinks = { for i in flatten([
    for v in local.port_role_fc_uplinks_loop : [
      for s in v.port_list : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_id          = s
        port_policy      = v.port_policy
        slot_id          = v.slot_id
        tags             = v.tags
        vsan_id          = v.vsan_id
      }
    ]
    ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i
  }
  #_________________________________________________________________
  #
  # Port Policy > Port Roles > FCoE Uplinks Section - Locals
  #_________________________________________________________________
  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_fcoe_uplinks_loop = flatten([
    for value in local.port : [
      for v in value.port_role_fcoe_uplinks : {
        admin_speed         = v.admin_speed
        breakout_port_id    = v.breakout_port_id
        fec                 = v.fec
        link_control_policy = v.link_control_policy
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = value.name
        slot_id     = v.slot_id
        tags        = value.tags
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fcoe_uplinks = { for i in flatten([
    for v in local.port_role_fcoe_uplinks_loop : [
      for s in v.port_list : {
        admin_speed         = v.admin_speed
        breakout_port_id    = v.breakout_port_id
        fec                 = v.fec
        link_control_policy = v.link_control_policy
        port_id             = s
        port_policy         = v.port_policy
        slot_id             = v.slot_id
        tags                = v.tags
      }
    ]
  ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #_________________________________________________________________
  #
  # Port Policy > Port Roles > FCoE Uplinks Section - Locals
  #_________________________________________________________________

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_servers_loop = flatten([
    for value in local.port : [
      for v in value.port_role_servers : {
        auto_negotiation      = v.auto_negotiation
        breakout_port_id      = v.breakout_port_id
        connected_device_type = v.connected_device_type
        device_number         = v.device_number
        fec                   = v.fec
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = value.name
        slot_id     = v.slot_id
        tags        = value.tags
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_servers = { for i in flatten([
    for v in local.port_role_servers_loop : [
      for s in v.port_list : {
        auto_negotiation      = v.auto_negotiation
        breakout_port_id      = v.breakout_port_id
        connected_device_type = v.connected_device_type
        device_number         = v.device_number
        fec                   = v.fec
        port_id               = s
        port_policy           = v.port_policy
        slot_id               = v.slot_id
        tags                  = v.tags
      }
    ]
  ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }

  #_________________________________________________________________________
  #
  # Intersight SAN Connectivity
  # GUI Location: Configure > Policies > Create Policy > SAN Connectivity
  #_________________________________________________________________________
  san_connectivity = { for v in lookup(local.policies, "san_connectivity", []) : v.name => {
    description         = lookup(v, "description", "")
    name                = "${local.name_prefix}${v.name}${local.lscp.name_suffix}"
    organization        = lookup(v, "organization", var.organization)
    tags                = lookup(v, "tags", var.tags)
    target_platform     = lookup(v, "target_platform", local.lscp.target_platform)
    vhba_placement_mode = lookup(v, "vhba_placement_mode", local.lscp.vhba_placement_mode)
    vhbas = [
      for v in lookup(v, "vhbas", []) : {
        fc_zone_policies = lookup(v, "fc_zone_policies", local.lscp.vhbas.fc_zone_policies)
        fibre_channel_adapter_policy = lookup(
        v, "fibre_channel_adapter_policy", local.lscp.vhbas.fibre_channel_adapter_policy)
        fibre_channel_network_policies = lookup(
        v, "fibre_channel_network_policies", local.lscp.vhbas.fibre_channel_network_policies)
        fibre_channel_qos_policy = lookup(
        v, "fibre_channel_qos_policy", local.lscp.vhbas.fibre_channel_qos_policy)
        names = v.names
        persistent_lun_bindings = lookup(
        v, "persistent_lun_bindings", local.lscp.vhbas.persistent_lun_bindings)
        placement_pci_link    = lookup(v, "placement_pci_link", local.lscp.vhbas.placement_pci_link)
        placement_pci_order   = lookup(v, "placement_pci_order", local.lscp.vhbas.placement_pci_order)
        placement_slot_id     = lookup(v, "placement_slot_id", local.lscp.vhbas.placement_slot_id)
        placement_switch_id   = lookup(v, "placement_switch_id", local.lscp.vhbas.placement_switch_id)
        placement_uplink_port = lookup(v, "placement_uplink_port", local.lscp.vhbas.placement_uplink_port)
        vhba_type             = lookup(v, "vhba_type", local.lscp.vhbas.vhba_type)
        wwpn_allocation_type  = lookup(v, "wwpn_allocation_type", local.lscp.vhbas.wwpn_allocation_type)
        wwpn_pools            = lookup(v, "wwpn_pools", local.lscp.vhbas.wwpn_pools)
        wwpn_static_address   = lookup(v, "wwpn_static_address", [])
      }
    ]
    wwnn_allocation_type = lookup(v, "wwnn_allocation_type", local.lscp.wwnn_allocation_type)
    wwnn_pool            = lookup(v, "wwnn_pool", local.lscp.wwnn_pool)
    wwnn_static_address  = lookup(v, "wwnn_static_address", "")
    }
  }
  vhbas = { for i in flatten([
    for value in local.san_connectivity : [
      for v in value.vhbas : [
        for s in range(length(v.names)) : {
          fc_zone_policies = length(
          v.fc_zone_policies) > 0 ? element(chunklist(v.fc_zone_policies, 2), s) : []
          fibre_channel_adapter_policy = v.fibre_channel_adapter_policy
          fibre_channel_network_policy = element(v.fibre_channel_network_policies, s)
          fibre_channel_qos_policy     = v.fibre_channel_qos_policy
          name                         = element(v.names, s)
          persistent_lun_bindings      = v.persistent_lun_bindings
          placement_pci_link = length(v.placement_pci_link) == 1 ? element(
            v.placement_pci_link, 0) : element(v.placement_pci_link, s
          )
          placement_pci_order = element(v.placement_pci_order, s)
          placement_slot_id = length(v.placement_slot_id) == 1 ? element(
            v.placement_slot_id, 0) : element(v.placement_slot_id, s
          )
          placement_switch_id = length(compact(
            [v.placement_switch_id])
          ) > 0 ? v.placement_switch_id : index(v.names, element(v.names, s)) == 0 ? "A" : "B"
          placement_uplink_port = length(v.placement_uplink_port) == 1 ? element(
            v.placement_uplink_port, 0) : element(v.placement_uplink_port, s
          )
          san_connectivity     = value.name
          vhba_type            = v.vhba_type
          wwpn_allocation_type = v.wwpn_allocation_type
          wwpn_pool            = length(v.wwpn_pools) > 0 ? element(v.wwpn_pools, s) : ""
          wwpn_static_address  = length(v.wwpn_static_address) > 0 ? element(v.wwpn_static_address, s) : ""
        }
      ]
    ]
  ]) : "${i.san_connectivity}:${i.name}" => i }

  #_________________________________________________________________________
  #
  # Intersight SNNMP Policy
  # GUI Location: Configure > Policies > Create Policy > SNMP
  #_________________________________________________________________________
  snmp = {
    for v in lookup(local.policies, "snmp", []) : v.name => {
      access_community_string = lookup(v, "access_community_string", 0)
      description             = lookup(v, "description", "")
      enable_snmp             = lookup(v, "enable_snmp", local.lsnmp.enable_snmp)
      name                    = "${local.name_prefix}${v.name}${local.lsnmp.name_suffix}"
      organization            = lookup(v, "organization", var.organization)
      #profiles                = []
      profiles = [
        for i in var.domains : {
          name        = i.name
          object_type = "fabric.SwitchProfile"
          } if length(regexall("^${v.name}$", i.snmp)) > 0 || length(regexall(
          "^${v.name}${local.lsnmp.name_suffix}$", i.snmp)
        ) > 0
      ]
      snmp_community_access  = lookup(v, "snmp_community_access", local.lsnmp.snmp_community_access)
      snmp_engine_input_id   = lookup(v, "snmp_engine_input_id", local.lsnmp.snmp_engine_input_id)
      snmp_port              = lookup(v, "snmp_port", local.lsnmp.snmp_port)
      snmp_trap_destinations = lookup(v, "snmp_trap_destinations", [])
      snmp_users             = lookup(v, "snmp_users", [])
      system_contact         = lookup(v, "system_contact", local.lsnmp.system_contact)
      system_location        = lookup(v, "system_location", local.lsnmp.system_location)
      tags                   = lookup(v, "tags", var.tags)
      trap_community_string  = lookup(v, "trap_community_string", 0)
    }
  }

  #_________________________________________________________________________
  #
  # Intersight Storage Policy
  # GUI Location: Configure > Policies > Create Policy > Storage
  #_________________________________________________________________________
  storage = {
    for v in lookup(local.policies, "storage", []) : v.name => {
      description       = lookup(v, "description", "")
      drive_groups      = lookup(v, "drive_groups", [])
      global_hot_spares = lookup(v, "global_hot_spares", local.lstorage.global_hot_spares)
      m2_configuration  = lookup(v, "m2_configuration", [])
      name              = "${local.name_prefix}${v.name}${local.lstorage.name_suffix}"
      organization      = lookup(v, "organization", var.organization)
      single_drive_raid_configuration = lookup(
        v, "single_drive_raid_configuration", []
      )
      tags               = lookup(v, "tags", var.tags)
      unused_disks_state = lookup(v, "unused_disks_state", local.lstorage.unused_disks_state)
      use_jbod_for_vd_creation = lookup(
        v, "use_jbod_for_vd_creation", local.lstorage.use_jbod_for_vd_creation
      )
    }
  }
  drive_groups = { for i in flatten([
    for value in local.storage : [
      for v in value.drive_groups : {
        automatic_drive_groups = lookup(v, "automatic_drive_groups", [])
        manual_drive_groups    = lookup(v, "manual_drive_groups", [])
        name                   = v.name
        raid_level             = lookup(v, "raid_level", "Raid1")
        storage_policy         = value.name
        tags                   = value.tags
        virtual_drives         = lookup(v, "virtual_drives", [])
      }
    ]
    ]) : "${i.storage_policy}:${i.name}" => i
  }

  #_________________________________________________________________________
  #
  # Intersight Switch Control Policy
  # GUI Location: Configure > Policies > Create Policy > Switch Control
  #_________________________________________________________________________
  switch_control = {
    for v in lookup(local.policies, "switch_control", []) : v.name => {
      description = lookup(v, "description", "")
      ethernet_switching_mode = lookup(
        v, "ethernet_switching_mode", local.swctrl.ethernet_switching_mode
      )
      fc_switching_mode = lookup(v, "fc_switching_mode", local.swctrl.fc_switching_mode)
      mac_address_table_aging = lookup(
        v, "mac_address_table_aging", local.swctrl.mac_address_table_aging
      )
      mac_aging_time = lookup(v, "mac_aging_time", local.swctrl.mac_aging_time)
      name           = "${local.name_prefix}${v.name}${local.swctrl.name_suffix}"
      organization   = lookup(v, "organization", var.organization)
      #profiles       = []
      profiles = [
        for i in var.domains : i.name if length(regexall(
          "^${local.name_prefix}${v.name}${local.swctrl.name_suffix}$", i.switch_control)
        ) > 0
      ]
      tags                  = lookup(v, "tags", var.tags)
      udld_message_interval = lookup(v, "udld_message_interval", local.swctrl.udld_message_interval)
      udld_recovery_action  = lookup(v, "udld_recovery_action", local.swctrl.udld_recovery_action)
      vlan_port_count_optimization = lookup(
        v, "vlan_port_count_optimization", local.swctrl.vlan_port_count_optimization
      )
    }
  }

  #_________________________________________________________________________
  #
  # Intersight Syslog Policy
  # GUI Location: Configure > Policies > Create Policy > Syslog
  #_________________________________________________________________________
  syslog = {
    for v in lookup(local.policies, "syslog", []) : v.name => {
      description        = lookup(v, "description", "")
      local_min_severity = lookup(v, "local_min_severity", local.lsyslog.local_min_severity)
      name               = "${local.name_prefix}${v.name}${local.lsyslog.name_suffix}"
      organization       = lookup(v, "organization", var.organization)
      #profiles     = []
      profiles = [
        for i in var.domains : {
          name        = i.name
          object_type = "fabric.SwitchProfile"
        } if length(regexall("^${local.name_prefix}${v.name}${local.lsyslog.name_suffix}$", i.syslog)) > 0
      ]
      remote_clients = lookup(v, "remote_clients", [])
      tags           = lookup(v, "tags", var.tags)
    }
  }

  #_________________________________________________________________________
  #
  # Intersight System QoS Policy
  # GUI Location: Configure > Policies > Create Policy > System QoS
  #_________________________________________________________________________
  system_qos = {
    for v in lookup(local.policies, "system_qos", []) : v.name => {
      classes      = lookup(v, "classes", [])
      description  = lookup(v, "description", "")
      name         = "${local.name_prefix}${v.name}${local.lsystem_qos.name_suffix}"
      organization = lookup(v, "organization", var.organization)
      #profiles     = []
      profiles = [
        for i in var.domains : i.name if length(regexall(
          "${local.name_prefix}${v.name}${local.lsystem_qos.name_suffix}", i.system_qos)
        ) > 0
      ]
      tags = lookup(v, "tags", var.tags)
    }
  }

  #_________________________________________________________________________
  #
  # Intersight Virtual Media Policy
  # GUI Location: Configure > Policies > Create Policy > Virtual Media
  #_________________________________________________________________________
  virtual_media = {
    for v in lookup(local.policies, "virtual_media", []) : v.name => {
      add_virtual_media    = lookup(v, "add_virtual_media", [])
      description          = lookup(v, "description", "")
      enable_low_power_usb = lookup(v, "enable_low_power_usb", local.vmedia.enable_low_power_usb)
      enable_virtual_media = lookup(v, "enable_virtual_media", local.vmedia.enable_virtual_media)
      enable_virtual_media_encryption = lookup(
        v, "enable_virtual_media_encryption", local.vmedia.enable_virtual_media_encryption
      )
      name         = "${local.name_prefix}${v.name}${local.vmedia.name_suffix}"
      organization = lookup(v, "organization", var.organization)
      tags         = lookup(v, "tags", var.tags)
    }
  }

  #_________________________________________________________________________
  #
  # Intersight VLAN Policy
  # GUI Location: Configure > Policies > Create Policy > VLAN
  #_________________________________________________________________________
  vlan = {
    for v in lookup(local.policies, "vlan", []) : v.name => {
      description  = lookup(v, "description", "")
      name         = "${local.name_prefix}${v.name}${local.lvlan.name_suffix}"
      organization = lookup(v, "organization", var.organization)
      #profiles     = []
      profiles = [
        for i in var.domains : i.name if length(regexall(
          "^${local.name_prefix}${v.name}${local.lvlan.name_suffix}$", i.vlan)
        ) > 0
      ]
      tags = lookup(v, "tags", var.tags)
      vlans = [
        for v in lookup(v, "vlans", []) : {
          auto_allow_on_uplinks = lookup(v, "auto_allow_on_uplinks", local.lvlan.vlans.auto_allow_on_uplinks)
          multicast_policy      = v.multicast_policy
          name                  = lookup(v, "name", "")
          native_vlan           = lookup(v, "native_vlan", local.lvlan.vlans.native_vlan)
          vlan_list             = v.vlan_list
        }
      ]
    }
  }
  vlans_loop = flatten([
    for value in local.vlan : [
      for v in value.vlans : {
        auto_allow_on_uplinks = v.auto_allow_on_uplinks
        multicast_policy      = v.multicast_policy
        name                  = v.name
        name_prefix           = length(regexall("(,|-)", jsonencode(v.vlan_list))) > 0 ? true : false
        native_vlan           = v.native_vlan
        vlan_list = flatten(
          [for s in compact(length(regexall("-", v.vlan_list)) > 0 ? tolist(split(",", v.vlan_list)
            ) : length(regexall(",", v.vlan_list)) > 0 ? tolist(split(",", v.vlan_list)) : [v.vlan_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
        vlan_policy = value.name
      }
    ]
  ])
  vlans = { for i in flatten([
    for v in local.vlans_loop : [
      for s in v.vlan_list : {
        auto_allow_on_uplinks = v.auto_allow_on_uplinks
        multicast_policy      = v.multicast_policy
        name                  = v.name
        name_prefix           = v.name_prefix
        native_vlan           = v.native_vlan
        vlan_id               = s
        vlan_policy           = v.vlan_policy
      }
    ]
  ]) : "${i.vlan_policy}:${i.vlan_id}" => i }

  #_________________________________________________________________________
  #
  # Intersight VSAN Policy
  # GUI Location: Configure > Policies > Create Policy > VSAN
  #_________________________________________________________________________
  vsan = {
    for v in lookup(local.policies, "vsan", []) : v.name => {
      description  = lookup(v, "description", "")
      name         = "${local.name_prefix}${v.name}${local.lvsan.name_suffix}"
      organization = lookup(v, "organization", var.organization)
      #profiles     = []
      profiles = [
        for i in var.domains : i.name if length(regexall(
          "^${local.name_prefix}${v.name}${local.lvsan.name_suffix}$", i.vsan)
        ) > 0
      ]
      tags            = lookup(v, "tags", var.tags)
      uplink_trunking = lookup(v, "uplink_trunking", local.lvsan.uplink_trunking)
      vsans           = lookup(v, "vsans", [])
    }
  }
  vsans = { for i in flatten([
    for value in local.vsan : [
      for v in value.vsans : {
        default_zoning = lookup(v, "default_zoning", local.lvsan.vsans.default_zoning)
        fcoe_vlan_id   = lookup(v, "fcoe_vlan_id", v.vsan_id)
        name           = v.name
        vsan_id        = v.vsan_id
        vsan_policy    = value.name
        vsan_scope     = lookup(v, "vsan_scope", local.lvsan.vsans.vsan_scope)
      }
    ]
  ]) : "${i.vsan_policy}:${i.vsan_id}" => i }
}
