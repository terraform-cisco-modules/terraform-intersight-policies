locals {
  defaults  = yamldecode(file("${path.module}/defaults.yaml")).policies
  cert_mgmt = local.defaults.certificate_management
  eth_adapt = local.defaults.ethernet_adapter
  eth_ntwk_ctrl = distinct(compact(concat([
    for v in local.port_channel_appliances : v.ethernet_network_control_policy.name if v.ethernet_network_control_policy.name != "UNUSED"], [
    for v in local.port_role_appliances : v.ethernet_network_control_policy.name if v.ethernet_network_control_policy.name != "UNUSED"], [
    for v in local.vnics : v.ethernet_network_control_policy.name if v.ethernet_network_control_policy.name != "UNUSED"]
  )))
  eth_ntwk_grp = distinct(compact(concat([
    for v in local.port_channel_appliances : v.ethernet_network_group_policy.name if v.ethernet_network_group_policy.name != "UNUSED"], [
    for v in local.port_channel_ethernet_uplinks : v.ethernet_network_group_policy.name if v.ethernet_network_group_policy.name != "UNUSED"], [
    for v in local.port_role_appliances : v.ethernet_network_group_policy.name if v.ethernet_network_group_policy.name != "UNUSED"], [
    for v in local.port_role_ethernet_uplinks : v.ethernet_network_group_policy.name if v.ethernet_network_group_policy.name != "UNUSED"], [
    for v in local.vnics : v.ethernet_network_group_policy.name if v.ethernet_network_group_policy.name != "UNUSED"]
  )))
  fc_adapt = local.defaults.fibre_channel_adapter
  flow_ctrl = distinct(compact(concat([
    for v in local.port_channel_ethernet_uplinks : v.flow_control_policy.name if v.flow_control_policy.name != "UNUSED"], [
    for v in local.port_role_ethernet_uplinks : v.flow_control_policy.name if v.flow_control_policy.name != "UNUSED"]
  )))
  fw    = local.defaults.firmware
  iboot = local.defaults.iscsi_boot
  ip_pools = distinct(compact(concat([
    for v in local.imc_access : v.inband_ip_pool.name if v.inband_ip_pool.name != "UNUSED"], [
    for v in local.imc_access : v.out_of_band_ip_pool.name if v.out_of_band_ip_pool.name != "UNUSED"], [
    for v in local.iscsi_boot : v.initiator_ip_pool.name if v.initiator_ip_pool.name != "UNUSED"]
  )))
  iadapter = distinct(compact([
    for v in local.iscsi_boot : v.iscsi_adapter_policy.name if v.iscsi_adapter_policy.name != "UNUSED"]
  ))
  iqn_pools = distinct(compact([
    for v in local.lan_connectivity : v.iqn_pool.name if v.iqn_pool.name != "UNUSED"]
  ))
  itarget = distinct(compact(concat([
    for v in local.iscsi_boot : v.primary_target_policy.name if v.primary_target_policy.name != "UNUSED"], [
    for v in local.iscsi_boot : v.secondary_target_policy.name if v.secondary_target_policy.name != "UNUSED"]
  )))
  ladapter = local.defaults.adapter_configuration
  ladd_vic = local.ladapter.add_vic_adapter_configuration
  lbios    = local.defaults.bios
  lboot    = local.defaults.boot_order
  lcp      = local.defaults.lan_connectivity
  lcp_eth_adtr = distinct(compact(concat([
    for v in local.vnics : v.ethernet_adapter_policy.name if v.ethernet_adapter_policy.name != "UNUSED"
    ], distinct(compact(concat([
      for v in local.vnics : [for e in [v.usnic_settings] : e.usnic_adapter_policy.name][0]], [
      for v in local.vnics : [for e in [v.vmq_settings] : e.vmmq_adapter_policy.name][0]
    ])))
  )))
  lcp_eth_ntwk = distinct(compact([
    for v in local.vnics : v.ethernet_network_policy.name if v.ethernet_network_policy.name != "UNUSED"]
  ))
  lcp_eth_qos = distinct(compact([
    for v in local.vnics : v.ethernet_qos_policy.name if v.ethernet_qos_policy.name != "UNUSED"]
  ))
  lcp_iboot = distinct(compact([
    for v in local.vnics : v.iscsi_boot_policy.name if v.iscsi_boot_policy.name != "UNUSED"]
  ))
  ldga = local.defaults.storage.drive_groups.automatic_drive_group
  ldgm = local.defaults.storage.drive_groups.manual_drive_group
  ldgv = local.defaults.storage.drive_groups.virtual_drives
  lds  = local.defaults.drive_security
  ldns = local.defaults.network_connectivity
  limc = local.defaults.imc_access
  link_agg = distinct(compact(concat([
    for v in local.port_channel_appliances : v.link_aggregation_policy.name if v.link_aggregation_policy.name != "UNUSED"], [
    for v in local.port_channel_ethernet_uplinks : v.link_aggregation_policy.name if v.link_aggregation_policy.name != "UNUSED"], [
    for v in local.port_channel_fcoe_uplinks : v.link_aggregation_policy.name if v.link_aggregation_policy.name != "UNUSED"]
  )))
  link_ctrl = distinct(compact(concat([
    for v in local.port_channel_ethernet_uplinks : v.link_control_policy.name if v.link_control_policy.name != "UNUSED"], [
    for v in local.port_channel_fcoe_uplinks : v.link_control_policy.name if v.link_control_policy.name != "UNUSED"], [
    for v in local.port_role_ethernet_uplinks : v.link_control_policy.name if v.link_control_policy.name != "UNUSED"], [
    for v in local.port_role_fcoe_uplinks : v.link_control_policy.name if v.link_control_policy.name != "UNUSED"]
  )))
  lldap       = local.defaults.ldap
  lntp        = local.defaults.ntp
  lport       = local.defaults.port
  lpmem       = local.defaults.persistent_memory
  lscp        = local.defaults.san_connectivity
  lsnmp       = local.defaults.snmp
  lstorage    = local.defaults.storage
  lstsdr      = local.lstorage.single_drive_raid0_configuration
  lsyslog     = local.defaults.syslog
  lsystem_qos = local.defaults.system_qos
  luser       = local.defaults.local_user
  lvlan       = local.defaults.vlan
  lvsan       = local.defaults.vsan
  lvm_add     = local.lvmedia.add_virtual_media
  lvmedia     = local.defaults.virtual_media
  mac_pools = distinct(compact([
    for v in local.vnics : v.mac_address_pool.name if v.mac_address_pool.name != "UNUSED"]
  ))
  mcast = distinct(compact([
    for v in local.vlans : v.multicast_policy.name if v.multicast_policy.name != "UNUSED"]
  ))
  name_prefix = [for v in [merge(lookup(local.policies, "name_prefix", {}), local.defaults.name_prefix)] : {
    adapter_configuration    = v.adapter_configuration != "" ? v.adapter_configuration : v.default
    bios                     = v.bios != "" ? v.bios : v.default
    boot_order               = v.boot_order != "" ? v.boot_order : v.default
    certificate_management   = v.certificate_management != "" ? v.certificate_management : v.default
    device_connector         = v.device_connector != "" ? v.device_connector : v.default
    ethernet_adapter         = v.ethernet_adapter != "" ? v.ethernet_adapter : v.default
    ethernet_network         = v.ethernet_network != "" ? v.ethernet_network : v.default
    ethernet_network_control = v.ethernet_network_control != "" ? v.ethernet_network_control : v.default
    ethernet_network_group   = v.ethernet_network_group != "" ? v.ethernet_network_group : v.default
    ethernet_qos             = v.ethernet_qos != "" ? v.ethernet_qos : v.default
    fc_zone                  = v.fc_zone != "" ? v.fc_zone : v.default
    fibre_channel_adapter    = v.fibre_channel_adapter != "" ? v.fibre_channel_adapter : v.default
    fibre_channel_network    = v.fibre_channel_network != "" ? v.fibre_channel_network : v.default
    fibre_channel_qos        = v.fibre_channel_qos != "" ? v.fibre_channel_qos : v.default
    firmware                 = v.firmware != "" ? v.firmware : v.default
    flow_control             = v.flow_control != "" ? v.flow_control : v.default
    imc_access               = v.imc_access != "" ? v.imc_access : v.default
    ipmi_over_lan            = v.ipmi_over_lan != "" ? v.ipmi_over_lan : v.default
    iscsi_adapter            = v.iscsi_adapter != "" ? v.iscsi_adapter : v.default
    iscsi_boot               = v.iscsi_boot != "" ? v.iscsi_boot : v.default
    iscsi_static_target      = v.iscsi_static_target != "" ? v.iscsi_static_target : v.default
    lan_connectivity         = v.lan_connectivity != "" ? v.lan_connectivity : v.default
    ldap                     = v.ldap != "" ? v.ldap : v.default
    link_aggregation         = v.link_aggregation != "" ? v.link_aggregation : v.default
    link_control             = v.link_control != "" ? v.link_control : v.default
    local_user               = v.local_user != "" ? v.local_user : v.default
    multicast                = v.multicast != "" ? v.multicast : v.default
    network_connectivity     = v.network_connectivity != "" ? v.network_connectivity : v.default
    ntp                      = v.ntp != "" ? v.ntp : v.default
    persistent_memory        = v.persistent_memory != "" ? v.persistent_memory : v.default
    port                     = v.port != "" ? v.port : v.default
    power                    = v.power != "" ? v.power : v.default
    san_connectivity         = v.san_connectivity != "" ? v.san_connectivity : v.default
    sd_card                  = v.sd_card != "" ? v.sd_card : v.default
    serial_over_lan          = v.serial_over_lan != "" ? v.serial_over_lan : v.default
    smtp                     = v.smtp != "" ? v.smtp : v.default
    snmp                     = v.snmp != "" ? v.snmp : v.default
    ssh                      = v.ssh != "" ? v.ssh : v.default
    storage                  = v.storage != "" ? v.storage : v.default
    switch_control           = v.switch_control != "" ? v.switch_control : v.default
    syslog                   = v.syslog != "" ? v.syslog : v.default
    system_qos               = v.system_qos != "" ? v.system_qos : v.default
    thermal                  = v.thermal != "" ? v.thermal : v.default
    virtual_kvm              = v.virtual_kvm != "" ? v.virtual_kvm : v.default
    virtual_media            = v.virtual_media != "" ? v.virtual_media : v.default
    vlan                     = v.vlan != "" ? v.vlan : v.default
    vsan                     = v.vsan != "" ? v.vsan : v.default
  }][0]
  name_suffix = [for v in [merge(lookup(local.policies, "name_suffix", {}), local.defaults.name_suffix)] : {
    adapter_configuration    = v.adapter_configuration != "" ? v.adapter_configuration : v.default
    bios                     = v.bios != "" ? v.bios : v.default
    boot_order               = v.boot_order != "" ? v.boot_order : v.default
    certificate_management   = v.certificate_management != "" ? v.certificate_management : v.default
    device_connector         = v.device_connector != "" ? v.device_connector : v.default
    ethernet_adapter         = v.ethernet_adapter != "" ? v.ethernet_adapter : v.default
    ethernet_network         = v.ethernet_network != "" ? v.ethernet_network : v.default
    ethernet_network_control = v.ethernet_network_control != "" ? v.ethernet_network_control : v.default
    ethernet_network_group   = v.ethernet_network_group != "" ? v.ethernet_network_group : v.default
    ethernet_qos             = v.ethernet_qos != "" ? v.ethernet_qos : v.default
    fc_zone                  = v.fc_zone != "" ? v.fc_zone : v.default
    fibre_channel_adapter    = v.fibre_channel_adapter != "" ? v.fibre_channel_adapter : v.default
    fibre_channel_network    = v.fibre_channel_network != "" ? v.fibre_channel_network : v.default
    fibre_channel_qos        = v.fibre_channel_qos != "" ? v.fibre_channel_qos : v.default
    firmware                 = v.firmware != "" ? v.firmware : v.default
    flow_control             = v.flow_control != "" ? v.flow_control : v.default
    imc_access               = v.imc_access != "" ? v.imc_access : v.default
    ipmi_over_lan            = v.ipmi_over_lan != "" ? v.ipmi_over_lan : v.default
    iscsi_adapter            = v.iscsi_adapter != "" ? v.iscsi_adapter : v.default
    iscsi_boot               = v.iscsi_boot != "" ? v.iscsi_boot : v.default
    iscsi_static_target      = v.iscsi_static_target != "" ? v.iscsi_static_target : v.default
    lan_connectivity         = v.lan_connectivity != "" ? v.lan_connectivity : v.default
    ldap                     = v.ldap != "" ? v.ldap : v.default
    link_aggregation         = v.link_aggregation != "" ? v.link_aggregation : v.default
    link_control             = v.link_control != "" ? v.link_control : v.default
    local_user               = v.local_user != "" ? v.local_user : v.default
    multicast                = v.multicast != "" ? v.multicast : v.default
    network_connectivity     = v.network_connectivity != "" ? v.network_connectivity : v.default
    ntp                      = v.ntp != "" ? v.ntp : v.default
    persistent_memory        = v.persistent_memory != "" ? v.persistent_memory : v.default
    port                     = v.port != "" ? v.port : v.default
    power                    = v.power != "" ? v.power : v.default
    san_connectivity         = v.san_connectivity != "" ? v.san_connectivity : v.default
    sd_card                  = v.sd_card != "" ? v.sd_card : v.default
    serial_over_lan          = v.serial_over_lan != "" ? v.serial_over_lan : v.default
    smtp                     = v.smtp != "" ? v.smtp : v.default
    snmp                     = v.snmp != "" ? v.snmp : v.default
    ssh                      = v.ssh != "" ? v.ssh : v.default
    storage                  = v.storage != "" ? v.storage : v.default
    switch_control           = v.switch_control != "" ? v.switch_control : v.default
    syslog                   = v.syslog != "" ? v.syslog : v.default
    system_qos               = v.system_qos != "" ? v.system_qos : v.default
    thermal                  = v.thermal != "" ? v.thermal : v.default
    virtual_kvm              = v.virtual_kvm != "" ? v.virtual_kvm : v.default
    virtual_media            = v.virtual_media != "" ? v.virtual_media : v.default
    vlan                     = v.vlan != "" ? v.vlan : v.default
    vsan                     = v.vsan != "" ? v.vsan : v.default
  }][0]
  orgs     = var.orgs
  policies = var.policies
  scp_fc_adtr = distinct(compact(concat([
    for v in local.vhbas : v.fibre_channel_adapter_policy.name if v.fibre_channel_adapter_policy.name != "UNUSED"]
  )))
  scp_fc_ntwk = distinct(compact([
    for v in local.vhbas : v.fibre_channel_network_policy.name if v.fibre_channel_network_policy.name != "UNUSED"]
  ))
  scp_fc_qos = distinct(compact([
    for v in local.vhbas : v.fibre_channel_qos_policy.name if v.fibre_channel_qos_policy.name != "UNUSED"]
  ))
  scp_fc_zone = distinct(compact(flatten([for v in local.vhbas : v.fc_zone_policies])))
  swctrl      = local.defaults.switch_control
  vmedia      = local.defaults.virtual_media
  wwnn_pools = distinct(compact([
    for v in local.san_connectivity : v.wwnn_pool.name if v.wwnn_pool.name != "UNUSED"]
  ))
  wwpn_pools = distinct(compact([
    for v in local.vhbas : v.wwpn_pool.name if v.wwpn_pool.name != "UNUSED"]
  ))
  #_________________________________________________________________
  #
  # Intersight Adapter Configuration Policy
  # GUI Location: Policies > Create Policy > Adapter Configuration
  #_________________________________________________________________
  adapter_configuration = {
    for value in lookup(local.policies, "adapter_configuration", {}) : value.name => {
      add_vic_adapter_configuration = [
        for v in value.add_vic_adapter_configuration : {
          dce_interface_settings = [for i in range(4) :
            {
              additional_properties = ""
              class_id              = "adapter.DceInterfaceSettings"
              fec_mode = length(
                lookup(lookup(
                  v, "dce_interface_settings", {}
                ), "dce_interface_fec_modes", local.ladd_vic.dce_interface_settings.dce_interface_fec_modes)
                ) == 4 ? element(lookup(lookup(
                  v, "dce_interface_settings", {}
                ), "dce_interface_fec_modes", local.ladd_vic.dce_interface_settings.dce_interface_fec_modes), i
                ) : element(lookup(lookup(
                  v, "dce_interface_settings", {}
                ), "dce_interface_fec_modes", local.ladd_vic.dce_interface_settings.dce_interface_fec_modes), 0
              )
              interface_id = i
              object_type  = "adapter.DceInterfaceSettings"
            }
          ]
          enable_fip          = lookup(v, "enable_fip", local.ladd_vic.enable_fip)
          enable_lldp         = lookup(v, "enable_lldp", local.ladd_vic.enable_lldp)
          enable_port_channel = lookup(v, "enable_port_channel", local.ladd_vic.enable_port_channel)
          pci_slot            = lookup(v, "pci_slot", local.ladd_vic.pci_slot)
        }
      ]
      description  = lookup(value, "description", "")
      name         = "${local.name_prefix.adapter_configuration}${value.name}${local.name_suffix.adapter_configuration}"
      organization = var.organization
      tags         = lookup(value, "tags", var.tags)
    }
  }

  #__________________________________________________________________
  #
  # Intersight BIOS Policy
  # GUI Location: Policies > Create Policy > BIOS
  #__________________________________________________________________
  bios = {
    for v in lookup(local.policies, "bios", []) : v.name => merge(local.lbios, v, {
      name         = "${local.name_prefix.bios}${v.name}${local.name_suffix.bios}"
      organization = var.organization
      tags         = lookup(v, "tags", var.tags)
    })
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
                Description = lookup(lookup(v, "bootloader", {}), "description", "")
                Name        = lookup(lookup(v, "bootloader", {}), "name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(lookup(v, "bootloader", {}), "path", "\\EFI\\BOOT\\")
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
                Description = lookup(lookup(v, "bootloader", {}), "description", "")
                Name        = lookup(lookup(v, "bootloader", {}), "name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(lookup(v, "bootloader", {}), "path", "\\EFI\\BOOT\\")
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
                Description = lookup(lookup(v, "bootloader", {}), "description", "")
                Name        = lookup(lookup(v, "bootloader", {}), "name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(lookup(v, "bootloader", {}), "path", "\\EFI\\BOOT\\")
              },
            }
            ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.PchStorage", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(lookup(v, "bootloader", {}), "description", "")
                Name        = lookup(lookup(v, "bootloader", {}), "name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(lookup(v, "bootloader", {}), "path", "\\EFI\\BOOT\\")
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
              MacAddress      = lookup(v, "mac_address", "")
              Port            = lookup(v, "port", -1)
              Slot            = lookup(v, "slot", "MLOM")
            }
            ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
            regexall("boot.San", v.object_type)) > 0 ? jsonencode(
            {
              Bootloader = {
                ClassId     = "boot.Bootloader"
                Description = lookup(lookup(v, "bootloader", {}), "description", "")
                Name        = lookup(lookup(v, "bootloader", {}), "name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(lookup(v, "bootloader", {}), "path", "\\EFI\\BOOT\\")
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
                Description = lookup(lookup(v, "bootloader", {}), "description", "")
                Name        = lookup(lookup(v, "bootloader", {}), "name", "BOOTx64.EFI")
                ObjectType  = "boot.Bootloader"
                Path        = lookup(lookup(v, "bootloader", {}), "path", "\\EFI\\BOOT\\")
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
      boot_mode          = lookup(i, "boot_mode", local.lboot.boot_mode)
      description        = lookup(i, "description", "")
      enable_secure_boot = lookup(i, "enable_secure_boot", local.lboot.enable_secure_boot)
      name               = "${local.name_prefix.boot_order}${i.name}${local.name_suffix.boot_order}"
      organization       = lookup(i, "organization", var.organization)
      tags               = lookup(i, "tags", var.tags)
    }
  }

  #__________________________________________________________________
  #
  # Intersight Ethernet Adapter Policy
  # GUI Location: Policies > Create Policy > Ethernet Adapter
  #__________________________________________________________________
  certificate_management = {
    for v in lookup(local.policies, "certificate_management", []) : v.name => merge(
      local.cert_mgmt, v, {
        name         = "${local.name_prefix.certificate_management}${v.name}${local.name_suffix.certificate_management}"
        organization = var.organization
        tags         = lookup(v, "tags", var.tags)
    }) if lookup(v, "assigned_sensitive_data", false) == true
  }

  #__________________________________________________________________
  #
  # Intersight Ethernet Adapter Policy
  # GUI Location: Policies > Create Policy > Ethernet Adapter
  #__________________________________________________________________
  drive_security = {
    for v in lookup(local.policies, "drive_security", []) : v.name => {
      description      = lookup(v, "description", "")
      name             = "${local.name_prefix.drive_security}${v.name}${local.name_suffix.drive_security}"
      organization     = var.organization
      primary_server   = merge(local.lds.primary_server, lookup(v, "primary_server", {}))
      secondary_server = merge(local.lds.secondary_server, lookup(v, "secondary_server", {}))
      tags             = lookup(v, "tags", var.tags)
      username         = lookup(v, "username", local.lds.username)
    } if lookup(v, "assigned_sensitive_data", local.lds.assigned_sensitive_data) == true
  }

  #__________________________________________________________________
  #
  # Intersight Ethernet Adapter Policy
  # GUI Location: Policies > Create Policy > Ethernet Adapter
  #__________________________________________________________________
  ethernet_adapter = {
    for v in lookup(local.policies, "ethernet_adapter", []) : v.name => merge(local.eth_adapt, v, {
      interrupt_settings = merge(local.eth_adapt.interrupt_settings,
        lookup(v, "interrupt_settings", {})
      )
      name         = "${local.name_prefix.ethernet_adapter}${v.name}${local.name_suffix.ethernet_adapter}"
      organization = var.organization
      receive      = merge(local.eth_adapt.receive, lookup(v, "receive", {}))
      rss = length(regexall("EMPTY", lookup(v, "adapter_template", "EMPTY"))
      ) == 0 ? false : lookup(v, "receive_side_scaling_enable", local.eth_adapt.receive_side_scaling_enable)
      receive_side_scaling = merge(
        local.eth_adapt.receive_side_scaling, lookup(v, "receive_side_scaling", {})
      )
      receive_side_scaling_enable = length(regexall("EMPTY", lookup(v, "adapter_template", "EMPTY"))
      ) == 0 ? false : lookup(v, "receive_side_scaling_enable", local.eth_adapt.receive_side_scaling_enable)
      roce_settings = merge(local.eth_adapt.roce_settings, lookup(v, "roce_settings", {}))
      tags          = lookup(v, "tags", var.tags)
      tcp_offload   = merge(local.eth_adapt.tcp_offload, lookup(v, "tcp_offload", {}))
      transmit      = merge(local.eth_adapt.transmit, lookup(v, "transmit", {}))
    })
  }

  #__________________________________________________________________
  #
  # Intersight Fibre Channel Adapter Policy
  # GUI Location: Policies > Create Policy > Fibre Channel Adapter
  #__________________________________________________________________

  fibre_channel_adapter = {
    for v in lookup(local.policies, "fibre_channel_adapter", []) : v.name => merge(
      local.fc_adapt, v, {
        error_recovery = merge(local.fc_adapt.error_recovery, lookup(v, "error_recovery", {}))
        flogi          = merge(local.fc_adapt.flogi, lookup(v, "flogi", {}))
        interrupt_settings = merge(
          local.fc_adapt.interrupt_settings, lookup(v, "interrupt_settings", {})
        )
        name         = "${local.name_prefix.fibre_channel_adapter}${v.name}${local.name_suffix.fibre_channel_adapter}"
        organization = var.organization
        plogi        = merge(local.fc_adapt.plogi, lookup(v, "plogi", {}))
        receive      = merge(local.fc_adapt.receive, lookup(v, "receive", {}))
        scsi_io      = merge(local.fc_adapt.scsi_io, lookup(v, "scsi_io", {}))
        tags         = lookup(v, "tags", var.tags)
        transmit     = merge(local.fc_adapt.transmit, lookup(v, "transmit", {}))
      }
    )
  }
  firmware = {
    for v in lookup(local.policies, "firmware", []) : v.name => merge(local.fw, v, {
      advanced_mode = merge(local.fw.advanced_mode, lookup(v, "advanced_mode", {}))
      tags          = lookup(v, "tags", var.tags)
    })
  }
  #__________________________________________________________________
  #
  # Intersight IMC Access Policy
  # GUI Location: Policies > Create Policy > IMC Access
  #__________________________________________________________________
  imc_access = {
    for v in lookup(local.policies, "imc_access", {}) : v.name => {
      description                = lookup(v, "description", "")
      inband_vlan_id             = lookup(v, "inband_vlan_id", local.limc.inband_vlan_id)
      name                       = "${local.name_prefix.imc_access}${v.name}${local.name_suffix.imc_access}"
      ipv4_address_configuration = lookup(v, "ipv4_address_configuration", local.limc.ipv4_address_configuration)
      ipv6_address_configuration = lookup(v, "ipv6_address_configuration", local.limc.ipv6_address_configuration)
      inband_ip_pool = lookup(v, "inband_ip_pool", "") != "" ? {
        name = v.inband_ip_pool, org = var.organization
      } : { name = "UNUSED", org = "UNUSED" }
      organization = var.organization
      out_of_band_ip_pool = lookup(v, "out_of_band_ip_pool", "") != "" ? {
        name = v.out_of_band_ip_pool, org = var.organization
      } : { name = "UNUSED", org = "UNUSED" }
      tags = lookup(v, "tags", var.tags)
    }
  }

  #__________________________________________________________________
  #
  # Intersight IMC Access Policy
  # GUI Location: Policies > Create Policy > IMC Access
  #__________________________________________________________________
  iscsi_boot = {
    for v in lookup(local.policies, "iscsi_boot", {}) : v.name => merge(local.defaults.iscsi_boot, v, {
      initiator_static_ipv4_config = merge(
      local.defaults.iscsi_boot.initiator_static_ipv4_config, lookup(v, "initiator_static_ipv4_config", {}))
      initiator_ip_pool = lookup(v, "initiator_ip_pool", "") != "" ? {
        name = v.initiator_ip_pool, org = var.organization
      } : { name = "UNUSED", org = "UNUSED" }
      iscsi_adapter_policy = lookup(v, "iscsi_adapter_policy", "") != "" ? {
        name = v.iscsi_adapter_policy, org = var.organization
      } : { name = "UNUSED", org = "UNUSED" }
      name         = "${local.name_prefix.iscsi_boot}${v.name}${local.name_suffix.iscsi_boot}"
      organization = var.organization
      primary_target_policy = lookup(v, "primary_target_policy", "") != "" ? {
        name = v.primary_target_policy, org = var.organization
      } : { name = "UNUSED", org = "UNUSED" }
      secondary_target_policy = lookup(v, "secondary_target_policy", "") != "" ? {
        name = v.secondary_target_policy, org = var.organization
      } : { name = "UNUSED", org = "UNUSED" }
      tags = lookup(v, "tags", var.tags)
    })
  }

  #_________________________________________________________________________
  #
  # Intersight LAN Connectivity
  # GUI Location: Configure > Policies > Create Policy > LAN Connectivity
  #_________________________________________________________________________
  vmq = local.lcp.vnics.vmq_settings
  lan_connectivity = {
    for v in lookup(local.policies, "lan_connectivity", {}) : v.name => {
      description = lookup(v, "description", "")
      enable_azure_stack_host_qos = lookup(
        v, "enable_azure_stack_host_qos", local.lcp.enable_azure_stack_host_qos
      )
      iqn_allocation_type = lookup(v, "iqn_allocation_type", local.lcp.iqn_allocation_type)
      iqn_pool = lookup(v, "iqn_pool", "") != "" ? {
        name = v.iqn_pool, organization = var.organization
      } : { name = "UNUSED", organization = "UNUSED" }
      iqn_static_identifier = lookup(v, "iqn_static_identifier", "")
      name                  = "${local.name_prefix.lan_connectivity}${v.name}${local.name_suffix.lan_connectivity}"
      organization          = var.organization
      tags                  = lookup(v, "tags", var.tags)
      target_platform       = lookup(v, "target_platform", local.lcp.target_platform)
      vnic_placement_mode = lookup(
        v, "vnic_placement_mode", local.lcp.vnic_placement_mode
      )
      vnics = [
        for v in lookup(v, "vnics", []) : {
          cdn_source              = lookup(v, "cdn_source", local.lcp.vnics.cdn_source)
          cdn_values              = lookup(v, "cdn_values", local.lcp.vnics.cdn_values)
          enable_failover         = lookup(v, "enable_failover", null)
          ethernet_adapter_policy = lookup(v, "ethernet_adapter_policy", local.lcp.vnics.ethernet_adapter_policy)
          ethernet_network_control_policy = lookup(
            v, "ethernet_network_control_policy", local.lcp.vnics.ethernet_network_control_policy
          )
          ethernet_network_group_policies = lookup(
            v, "ethernet_network_group_policies", local.lcp.vnics.ethernet_network_group_policies
          )
          ethernet_network_policy = lookup(v, "ethernet_network_policy", local.lcp.vnics.ethernet_network_policy)
          ethernet_qos_policy     = lookup(v, "ethernet_qos_policy", local.lcp.vnics.ethernet_qos_policy)
          iscsi_boot_policies     = lookup(v, "iscsi_boot_policies", local.lcp.vnics.iscsi_boot_policies)
          mac_address_allocation_type = lookup(
            v, "mac_address_allocation_type", local.lcp.vnics.mac_address_allocation_type
          )
          mac_address_pools    = lookup(v, "mac_address_pools", local.lcp.vnics.mac_address_pools)
          mac_addresses_static = lookup(v, "mac_addresses_static", [])
          names                = v.names
          placement            = merge(local.lcp.vnics.placement, lookup(v, "placement", {}))
          usnic_settings       = merge(local.lcp.vnics.usnic_settings, lookup(v, "usnic_settings", {}))
          vmq_settings         = merge(local.lcp.vnics.vmq_settings, lookup(v, "vmq_settings", {}))
        }
      ]
    }
  }
  vnics = { for i in flatten([
    for key, value in local.lan_connectivity : [
      for v in value.vnics : [
        for s in range(length(v.names)) : {
          cdn_source = v.cdn_source
          cdn_value  = length(v.cdn_values) > 0 ? element(v.cdn_values, s) : ""
          enable_failover = length(compact([v.enable_failover])
          ) > 0 ? v.enable_failover : length(v.names) == 1 ? true : local.lcp.vnics.enable_failover
          ethernet_adapter_policy = { name = v.ethernet_adapter_policy, org = value.organization }
          ethernet_network_control_policy = v.ethernet_network_control_policy != "" ? {
            name = v.ethernet_network_control_policy, org = value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          ethernet_network_group_policy = length(v.ethernet_network_group_policies) == 2 ? {
            name = element(v.ethernet_network_group_policies, s), org = value.organization
            } : length(v.ethernet_network_group_policies) == 1 ? {
            name = element(v.ethernet_network_group_policies, 0), org = value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          ethernet_network_policy = length(compact([lookup(v, "ethernet_network_policy", "")])) > 0 ? {
            name = v.ethernet_network_policy, org = value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          ethernet_qos_policy = { name = v.ethernet_qos_policy, org = value.organization }
          iscsi_boot_policy = length(v.iscsi_boot_policies) > 0 ? {
            name = element(v.iscsi_boot_policies, s), org = value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          lan_connectivity            = key
          mac_address_allocation_type = v.mac_address_allocation_type
          mac_address_pool = length(v.mac_address_pools) == 2 ? {
            name = element(v.mac_address_pools, s), org = value.organization
            } : length(v.mac_address_pools) == 1 ? {
            name = element(v.mac_address_pools, 0), org = value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          mac_address_static = length(lookup(v, "mac_addresses_static", [])
          ) == length(v.names) ? element(v.mac_addresses_static, s) : ""
          name         = element(v.names, s)
          organization = value.organization
          placement = [for e in [v.placement] : {
            pci_link    = length(e.pci_links) == 1 ? element(e.pci_links, 0) : element(e.pci_links, s)
            pci_order   = length(e.pci_order) == 1 ? element(e.pci_order, 0) : element(e.pci_order, s)
            slot_id     = length(e.slot_ids) == 1 ? element(e.slot_ids, 0) : element(e.slot_ids, s)
            switch_id   = length(e.switch_ids) == 1 ? element(e.switch_ids, 0) : element(e.switch_ids, s)
            uplink_port = length(e.uplink_ports) == 1 ? element(e.uplink_ports, 0) : element(e.uplink_ports, s)
          }][0]
          tags = value.tags
          usnic_settings = [for e in [v.usnic_settings] : {
            class_of_service = e.class_of_service
            number_of_usnics = e.number_of_usnics
            usnic_adapter_policy = length(compact([lookup(e, "usnic_adapter_policy", "")])) > 0 ? {
              name = tostring(v.usnic_adapter_policy), org = value.organization
            } : { name = "UNUSED", org = "UNUSED" }
          }][0]
          vmq_settings = [for e in [lookup(v, "vmq_settings", {})] : {
            enable_virtual_machine_multi_queue = e.enable_virtual_machine_multi_queue
            enabled                            = e.enabled
            number_of_interrupts               = e.number_of_interrupts
            number_of_sub_vnics                = e.number_of_sub_vnics
            number_of_virtual_machine_queues   = e.number_of_virtual_machine_queues
            vmmq_adapter_policy = length(compact([lookup(e, "vmmq_adapter_policy", "")])) > 0 ? {
              name = e.vmmq_adapter_policy, org = value.organization
            } : { name = "UNUSED", org = "UNUSED" }
          }][0]
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
        base_dn = length(compact([lookup(v.base_settings, "base_dn", "")])
        ) == 0 ? "DC=${join(",DC=", split(".", v.base_settings.domain))}" : v.base_settings.base_dn
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
      enable_ldap    = lookup(v, "enable_ldap", local.lldap.enable_ldap)
      ldap_from_dns  = merge(local.lldap.ldap_from_dns, lookup(v, "ldap_from_dns", {}))
      ldap_groups    = lookup(v, "ldap_groups", [])
      ldap_providers = lookup(v, "ldap_providers", [])
      name           = "${local.name_prefix.ldap}${v.name}${local.name_suffix.ldap}"
      nested_group_search_depth = lookup(
        v, "nested_group_search_depth", local.lldap.nested_group_search_depth
      )
      organization      = var.organization
      search_parameters = merge(local.lldap.search_parameters, lookup(v, "search_parameters", {}))
      tags              = lookup(v, "tags", var.tags)
      user_search_precedence = lookup(
        v, "user_search_precedence", local.lldap.user_search_precedence
      )
    }
  }
  ldap_groups = { for i in flatten([
    for key, value in local.ldap : [
      for v in value.ldap_groups : {
        domain        = lookup(v, "domain", "")
        base_settings = value.base_settings
        ldap_policy   = key
        name          = v.name
        role          = v.role
      }
    ]
  ]) : "${i.ldap_policy}:${i.name}" => i }
  ldap_providers = { for i in flatten([
    for key, value in local.ldap : [
      for v in value.ldap_providers : {
        ldap_policy = key
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
      description         = lookup(v, "description", "")
      password_properties = merge(local.luser.password_properties, lookup(v, "password_properties", {}))
      name                = "${local.name_prefix.local_user}${v.name}${local.name_suffix.local_user}"
      organization        = var.organization
      tags                = lookup(v, "tags", var.tags)
      users               = lookup(v, "users", [])
    }
  }
  users = { for i in flatten([
    for key, value in local.local_user : [
      for v in value.users : {
        enabled      = lookup(v, "enabled", true)
        local_user   = key
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
      name               = "${local.name_prefix.network_connectivity}${v.name}${local.name_suffix.network_connectivity}"
      obtain_ipv4_dns_from_dhcp = lookup(
        v, "obtain_ipv4_dns_from_dhcp", local.ldns.obtain_ipv4_dns_from_dhcp
      )
      obtain_ipv6_dns_from_dhcp = lookup(
        v, "obtain_ipv6_dns_from_dhcp", local.ldns.obtain_ipv6_dns_from_dhcp
      )
      organization  = var.organization
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
      name         = "${local.name_prefix.ntp}${v.name}${local.name_suffix.ntp}"
      ntp_servers  = lookup(v, "ntp_servers", local.lntp.ntp_servers)
      organization = var.organization
      tags         = lookup(v, "tags", var.tags)
      timezone     = lookup(v, "timezone", local.lntp.timezone)
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
      name = "${local.name_prefix.persistent_memory}${v.name}${local.name_suffix.persistent_memory}"
      namespaces = [for v in lookup(v, "namespaces", []) :
        {
          capacity         = v.capacity
          mode             = lookup(v, "mode", local.lpmem.namespaces.mode)
          name             = v.name
          socket_id        = lookup(v, "socket_id", local.lpmem.namespaces.socket_id)
          socket_memory_id = lookup(v, "socket_memory_id", local.lpmem.namespaces.socket_memory_id)
        }
      ]
      organization = var.organization
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
        key          = element(value.names, i)
        name         = "${local.name_prefix.port}${element(value.names, i)}${local.name_suffix.port}"
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
            link_aggregation_policy = lookup(
              v, "link_aggregation_policy", local.lport.port_channel_ethernet_uplinks.link_aggregation_policy
            )
            mode     = lookup(v, "mode", local.lport.port_channel_appliances.mode)
            pc_id    = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
            priority = lookup(v, "priority", local.lport.port_channel_appliances.priority)
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
            vsan_id          = length(v.vsan_ids) == 1 ? element(v.vsan_ids, 0) : element(v.vsan_ids, i)
          }
        ]
        port_role_fc_uplinks = [
          for v in lookup(value, "port_role_fc_uplinks", []) : {
            admin_speed      = lookup(v, "admin_speed", local.lport.port_role_fc_uplinks.admin_speed)
            breakout_port_id = lookup(v, "breakout_port_id", 0)
            fill_pattern     = lookup(v, "fill_pattern", local.lport.port_role_fc_uplinks.fill_pattern)
            port_list        = v.port_list
            slot_id          = lookup(v, "slot_id", 1)
            vsan_id          = length(v.vsan_ids) == 1 ? element(v.vsan_ids, 0) : element(v.vsan_ids, i)
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
        tags = lookup(value, "tags", var.tags)

      }
    ]
  ]) : "${s.key}" => s }
  port_channel_appliances = { for i in flatten([
    for key, value in local.port : [
      for v in value.port_channel_appliances : {
        admin_speed = v.admin_speed
        ethernet_network_control_policy = v.ethernet_network_control_policy != "" ? {
          name = v.ethernet_network_control_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        ethernet_network_group_policy = v.ethernet_network_group_policy != "" ? {
          name = v.ethernet_network_group_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        interfaces = v.interfaces
        link_aggregation_policy = v.link_aggregation_policy != "" ? {
          name = v.link_aggregation_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        mode         = v.mode
        organization = value.organization
        pc_id        = v.pc_id
        port_policy  = key
        priority     = v.priority
        tags         = value.tags
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_ethernet_uplinks = { for i in flatten([
    for key, value in local.port : [
      for v in value.port_channel_ethernet_uplinks : {
        admin_speed = v.admin_speed
        ethernet_network_group_policy = v.ethernet_network_group_policy != "" ? {
          name = v.ethernet_network_group_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        flow_control_policy = v.flow_control_policy != "" ? {
          name = v.flow_control_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        interfaces = v.interfaces
        link_aggregation_policy = v.link_aggregation_policy != "" ? {
          name = v.link_aggregation_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        link_control_policy = v.link_control_policy != "" ? {
          name = v.link_control_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        organization = value.organization
        pc_id        = v.pc_id
        port_policy  = key
        tags         = value.tags
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_fc_uplinks = { for i in flatten([
    for key, value in local.port : [
      for v in value.port_channel_fc_uplinks : {
        admin_speed  = v.admin_speed
        fill_pattern = v.fill_pattern
        interfaces   = v.interfaces
        pc_id        = v.pc_id
        port_policy  = key
        tags         = value.tags
        vsan_id      = v.vsan_id
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_fcoe_uplinks = { for i in flatten([
    for key, value in local.port : [
      for v in value.port_channel_fcoe_uplinks : {
        admin_speed = v.admin_speed
        interfaces  = v.interfaces
        link_aggregation_policy = v.link_aggregation_policy != "" ? {
          name = v.link_aggregation_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        link_control_policy = v.link_control_policy != "" ? {
          name = v.link_control_policy, org = value.organization
        } : { name = "UNUSED", org = "UNUSED" }
        organization = value.organization
        pc_id        = v.pc_id
        port_policy  = key
        tags         = value.tags
      }
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_modes = { for i in flatten([
    for key, value in local.port : [
      for v in value.port_modes : {
        custom_mode = v.custom_mode
        port_list   = v.port_list
        port_policy = key
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
    for key, value in local.port : [
      for v in value.port_role_appliances : {
        admin_speed                     = v.admin_speed
        breakout_port_id                = v.breakout_port_id
        ethernet_network_control_policy = v.ethernet_network_control_policy
        ethernet_network_group_policy   = v.ethernet_network_group_policy
        fec                             = v.fec
        mode                            = v.mode
        organization                    = value.organization
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = key
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
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        ethernet_network_control_policy = v.ethernet_network_control_policy != "" ? {
          name = v.ethernet_network_control_policy, org = v.organization
        } : { name = "UNUSED", org = "UNUSED" }
        ethernet_network_group_policy = v.ethernet_network_group_policy != "" ? {
          name = v.ethernet_network_group_policy, org = v.organization
        } : { name = "UNUSED", org = "UNUSED" }
        fec          = v.fec
        mode         = v.mode
        organization = v.organization
        port_id      = s
        port_policy  = v.port_policy
        priority     = v.priority
        slot_id      = v.slot_id
        tags         = v.tags
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
    for key, value in local.port : [
      for v in value.port_role_ethernet_uplinks : {
        admin_speed                   = v.admin_speed
        breakout_port_id              = v.breakout_port_id
        ethernet_network_group_policy = v.ethernet_network_group_policy
        fec                           = v.fec
        flow_control_policy           = v.flow_control_policy
        link_control_policy           = v.link_control_policy
        organization                  = value.organization
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = key
        slot_id     = v.slot_id
        tags        = value.tags
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_ethernet_uplinks = { for i in flatten([
    for v in local.port_role_ethernet_uplinks_loop : [
      for s in v.port_list : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        ethernet_network_group_policy = v.ethernet_network_group_policy != "" ? {
          name = v.ethernet_network_group_policy, org = v.organization
        } : { name = "UNUSED", org = "UNUSED" }
        fec = v.fec
        flow_control_policy = v.flow_control_policy != "" ? {
          name = v.flow_control_policy, org = v.organization
        } : { name = "UNUSED", org = "UNUSED" }
        link_control_policy = v.link_control_policy != "" ? {
          name = v.link_control_policy, org = v.organization
        } : { name = "UNUSED", org = "UNUSED" }
        organization = v.organization
        port_id      = s
        port_policy  = v.port_policy
        slot_id      = v.slot_id
        tags         = v.tags
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
    for key, value in local.port : [
      for v in value.port_role_fc_storage : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = key
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
    for key, value in local.port : [
      for v in value.port_role_fc_uplinks : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = key
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
    for key, value in local.port : [
      for v in value.port_role_fcoe_uplinks : {
        admin_speed         = v.admin_speed
        breakout_port_id    = v.breakout_port_id
        fec                 = v.fec
        link_control_policy = v.link_control_policy
        organization        = value.organization
        port_list = flatten(
          [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
            ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
          ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]]
        )
        port_policy = key
        slot_id     = v.slot_id
        tags        = value.tags
      }
    ]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fcoe_uplinks = { for i in flatten([
    for v in local.port_role_fcoe_uplinks_loop : [
      for s in v.port_list : {
        admin_speed      = v.admin_speed
        breakout_port_id = v.breakout_port_id
        fec              = v.fec
        link_control_policy = v.link_control_policy != "" ? {
          name = v.link_control_policy, org = v.organization
        } : { name = "UNUSED", org = "UNUSED" }
        organization = v.organization
        port_id      = s
        port_policy  = v.port_policy
        slot_id      = v.slot_id
        tags         = v.tags
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
    for key, value in local.port : [
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
        port_policy = key
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
    name                = "${local.name_prefix.san_connectivity}${v.name}${local.name_suffix.san_connectivity}"
    organization        = var.organization
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
        placement             = merge(local.lscp.vhbas.placement, lookup(v, "placement", {}))
        vhba_type             = lookup(v, "vhba_type", local.lscp.vhbas.vhba_type)
        wwpn_allocation_type  = lookup(v, "wwpn_allocation_type", local.lscp.vhbas.wwpn_allocation_type)
        wwpn_pools            = lookup(v, "wwpn_pools", local.lscp.vhbas.wwpn_pools)
        wwpn_static_addresses = lookup(v, "wwpn_static_addresses", [])
      }
    ]
    wwnn_allocation_type = lookup(v, "wwnn_allocation_type", local.lscp.wwnn_allocation_type)
    wwnn_pool = lookup(v, "wwnn_pool", "") != "" ? { name = v.wwnn_pool, org = var.organization
    } : { name = "UNUSED", org = "UNUSED" }
    wwnn_static_address = lookup(v, "wwnn_static_address", "")
    }
  }
  vhbas = { for i in flatten([
    for key, value in local.san_connectivity : [
      for v in value.vhbas : [
        for s in range(length(v.names)) : {
          fc_zone_policies = length(v.fc_zone_policies) > 0 ? element(
            chunklist(v.fc_zone_policies, 2), s
          ) : []
          fibre_channel_adapter_policy = v.fibre_channel_adapter_policy != "" ? {
            name = v.fibre_channel_adapter_policy, org = var.organization
          } : { name = "UNUSED", org = "UNUSED" }
          fibre_channel_network_policy = element(v.fibre_channel_network_policies, s) != "" ? {
            name = element(v.fibre_channel_network_policies, s), org = var.organization
          } : { name = "UNUSED", org = "UNUSED" }
          fibre_channel_qos_policy = v.fibre_channel_qos_policy != "" ? {
            name = tostring(v.fibre_channel_qos_policy), org = value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          name                    = element(v.names, s)
          organization            = value.organization
          persistent_lun_bindings = v.persistent_lun_bindings
          placement = [for e in [v.placement] : {
            pci_link    = length(e.pci_links) == 1 ? element(e.pci_links, 0) : element(e.pci_links, s)
            pci_order   = length(e.pci_order) == 1 ? element(e.pci_order, 0) : element(e.pci_order, s)
            slot_id     = length(e.slot_ids) == 1 ? element(e.slot_ids, 0) : element(e.slot_ids, s)
            switch_id   = length(e.switch_ids) == 1 ? element(e.switch_ids, 0) : element(e.switch_ids, s)
            uplink_port = length(e.uplink_ports) == 1 ? element(e.uplink_ports, 0) : element(e.uplink_ports, s)
          }][0]
          san_connectivity     = key
          vhba_type            = v.vhba_type
          wwpn_allocation_type = v.wwpn_allocation_type
          wwpn_pool = length(v.wwpn_pools) > 0 ? { name = element(v.wwpn_pools, s), org = var.organization
          } : { name = "UNUSED", org = "UNUSED" }
          wwpn_static_address = length(v.wwpn_static_addresses) > 0 ? element(v.wwpn_static_addresses, s) : ""
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
      name                    = "${local.name_prefix.snmp}${v.name}${local.name_suffix.snmp}"
      organization            = var.organization
      snmp_community_access   = lookup(v, "snmp_community_access", local.lsnmp.snmp_community_access)
      snmp_engine_input_id    = lookup(v, "snmp_engine_input_id", local.lsnmp.snmp_engine_input_id)
      snmp_port               = lookup(v, "snmp_port", local.lsnmp.snmp_port)
      snmp_trap_destinations  = lookup(v, "snmp_trap_destinations", [])
      snmp_users              = lookup(v, "snmp_users", [])
      system_contact          = lookup(v, "system_contact", local.lsnmp.system_contact)
      system_location         = lookup(v, "system_location", local.lsnmp.system_location)
      tags                    = lookup(v, "tags", var.tags)
      trap_community_string   = lookup(v, "trap_community_string", 0)
    }
  }

  #_________________________________________________________________________
  #
  # Intersight Storage Policy
  # GUI Location: Configure > Policies > Create Policy > Storage
  #_________________________________________________________________________
  storage = {
    for v in lookup(local.policies, "storage", []) : v.name => {
      default_drive_state = lookup(v, "default_drive_state", local.lstorage.default_drive_state)
      description         = lookup(v, "description", "")
      drive_groups        = lookup(v, "drive_groups", [])
      global_hot_spares   = lookup(v, "global_hot_spares", local.lstorage.global_hot_spares)
      m2_raid_configuration = length(lookup(v, "m2_raid_configuration", [])
      ) > 0 ? [v.m2_raid_configuration] : []
      name         = "${local.name_prefix.storage}${v.name}${local.name_suffix.storage}"
      organization = var.organization
      single_drive_raid0_configuration = length(compact([
        lookup(lookup(v, "single_drive_raid0_configuration", {}), "drive_slots", "")])) > 0 ? [
        {
          drive_slots = v.single_drive_raid0_configuration.drive_slots
          virtual_drive_policy = merge(local.lstsdr.virtual_drive_policy, lookup(
            v.single_drive_raid0_configuration, "virtual_drive_policy", {})
          )
        }
      ] : []
      tags               = lookup(v, "tags", var.tags)
      unused_disks_state = lookup(v, "unused_disks_state", local.lstorage.unused_disks_state)
      use_jbod_for_vd_creation = lookup(
        v, "use_jbod_for_vd_creation", local.lstorage.use_jbod_for_vd_creation
      )
    }
  }
  drive_groups = { for i in flatten([
    for key, value in local.storage : [
      for v in value.drive_groups : {
        automatic_drive_group = length(lookup(v, "automatic_drive_group", [])
        ) > 0 ? [v.automatic_drive_group] : []
        manual_drive_group = length(lookup(v, "manual_drive_group", [])
        ) > 0 ? [v.manual_drive_group] : []
        name           = v.name
        raid_level     = lookup(v, "raid_level", "Raid1")
        storage_policy = key
        tags           = value.tags
        virtual_drives = lookup(v, "virtual_drives", [])
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
      mac_aging_time         = lookup(v, "mac_aging_time", local.swctrl.mac_aging_time)
      name                   = "${local.name_prefix.switch_control}${v.name}${local.name_suffix.switch_control}"
      organization           = var.organization
      reserved_vlan_start_id = lookup(v, "reserved_vlan_start_id", local.swctrl.reserved_vlan_start_id)
      tags                   = lookup(v, "tags", var.tags)
      udld_global_settings   = merge(local.swctrl.udld_global_settings, lookup(v, "udld_global_settings", {}))
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
      description = lookup(v, "description", "")
      local_min_severity = lookup(lookup(
        v, "local_logging", {}), "minimum_severity", local.lsyslog.local_logging.minimum_severity
      )
      name           = "${local.name_prefix.syslog}${v.name}${local.name_suffix.syslog}"
      organization   = var.organization
      remote_logging = lookup(v, "remote_logging", [])
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
      classes = length(regexall(true, lookup(v, "use_recommendations", local.lsystem_qos.use_recommendations))
        ) > 0 ? local.lsystem_qos.recommended_classes : length(compact(lookup(v, "classes", []))
      ) == 0 ? local.lsystem_qos.classes : { for v in v.classes : v.priority => v }
      description  = lookup(v, "description", "")
      jumbo_mtu    = lookup(v, "jumbo_mtu", local.lsystem_qos.jumbo_mtu)
      name         = "${local.name_prefix.system_qos}${v.name}${local.name_suffix.system_qos}"
      organization = var.organization
      tags         = lookup(v, "tags", var.tags)
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
      name         = "${local.name_prefix.virtual_media}${v.name}${local.name_suffix.virtual_media}"
      organization = var.organization
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
      name         = "${local.name_prefix.vlan}${v.name}${local.name_suffix.vlan}"
      organization = var.organization
      tags         = lookup(v, "tags", var.tags)
      vlans = [
        for v in lookup(v, "vlans", []) : {
          auto_allow_on_uplinks = lookup(v, "auto_allow_on_uplinks", local.lvlan.vlans.auto_allow_on_uplinks)
          multicast_policy      = v.multicast_policy
          name                  = lookup(v, "name", "")
          native_vlan           = lookup(v, "native_vlan", local.lvlan.vlans.native_vlan)
          primary_vlan_id       = lookup(v, "primary_vlan_id", 0)
          sharing_type          = lookup(v, "sharing_type", "None")
          vlan_list             = v.vlan_list
        }
      ]
    }
  }
  vlans_loop = flatten([
    for key, value in local.vlan : [
      for v in value.vlans : {
        auto_allow_on_uplinks = v.auto_allow_on_uplinks
        multicast_policy      = v.multicast_policy
        name                  = v.name
        name_prefix           = length(regexall("(,|-)", jsonencode(v.vlan_list))) > 0 ? true : false
        native_vlan           = v.native_vlan
        organization          = value.organization
        primary_vlan_id       = v.primary_vlan_id
        sharing_type          = v.sharing_type
        vlan_list = flatten(
          [for s in compact(length(regexall("-", v.vlan_list)) > 0 ? tolist(split(",", v.vlan_list)
            ) : length(regexall(",", v.vlan_list)) > 0 ? tolist(split(",", v.vlan_list)) : [v.vlan_list]
            ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
        ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
        vlan_policy = key
      }
    ]
  ])
  vlans = { for i in flatten([
    for v in local.vlans_loop : [
      for s in v.vlan_list : {
        auto_allow_on_uplinks = v.auto_allow_on_uplinks
        multicast_policy      = { name = v.multicast_policy, org = var.organization }
        name                  = v.name
        name_prefix           = v.name_prefix
        native_vlan           = v.native_vlan
        organization          = v.organization
        primary_vlan_id       = v.primary_vlan_id
        sharing_type          = v.sharing_type
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
      description     = lookup(v, "description", "")
      name            = "${local.name_prefix.vsan}${v.name}${local.name_suffix.vsan}"
      organization    = var.organization
      tags            = lookup(v, "tags", var.tags)
      uplink_trunking = lookup(v, "uplink_trunking", local.lvsan.uplink_trunking)
      vsans           = lookup(v, "vsans", [])
    }
  }
  vsans = { for i in flatten([
    for key, value in local.vsan : [
      for v in value.vsans : {
        default_zoning = lookup(v, "default_zoning", local.lvsan.vsans.default_zoning)
        fcoe_vlan_id   = lookup(v, "fcoe_vlan_id", v.vsan_id)
        name           = v.name
        organization   = value.organization
        vsan_id        = v.vsan_id
        vsan_policy    = key
        vsan_scope     = lookup(v, "vsan_scope", local.lvsan.vsans.vsan_scope)
      }
    ]
  ]) : "${i.vsan_policy}:${i.vsan_id}" => i }
}
