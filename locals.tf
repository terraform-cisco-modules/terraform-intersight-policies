locals {
  defaults = yamldecode(file("${path.module}/defaults.yaml")).policies
  network_policies = [
    "ethernet_network_control", "ethernet_network_group",
    "flow_control", "link_aggregation", "link_control"
  ]
  policy_names = [
    "adapter_configuration", "bios", "boot_order", "certificate_management", "device_connector", "ethernet_adapter",
    "ethernet_network", "ethernet_network_control", "ethernet_network_group", "ethernet_qos", "fc_zone",
    "fibre_channel_adapter", "fibre_channel_network", "fibre_channel_qos", "firmware", "flow_control", "imc_access",
    "ipmi_over_lan", "iscsi_adapter", "iscsi_boot", "iscsi_static_target", "lan_connectivity", "ldap", "link_aggregation",
    "link_control", "local_user", "multicast", "network_connectivity", "ntp", "persistent_memory", "port",
    "power", "san_connectivity", "sd_card", "serial_over_lan", "smtp", "snmp", "ssh", "storage",
    "switch_control", "syslog", "system_qos", "thermal", "virtual_kvm", "virtual_media", "vlan", "vsan"
  ]
  pp = merge({ for i in local.network_policies : i => setsubtract(distinct(compact(concat(
    [for v in local.port_channel_appliances : lookup(lookup(v, "${i}_policy", {}), "name", "")],
    [for v in local.port_channel_ethernet_uplinks : lookup(lookup(v, "${i}_policy", {}), "name", "")],
    [for v in local.port_channel_fcoe_uplinks : lookup(lookup(v, "${i}_policy", {}), "name", "")],
    [for v in local.port_role_appliances : lookup(lookup(v, "${i}_policy", {}), "name", "")],
    [for v in local.port_role_ethernet_uplinks : lookup(lookup(v, "${i}_policy", {}), "name", "")],
    [for v in local.port_role_fcoe_uplinks : lookup(lookup(v, "${i}_policy", {}), "name", "")],
    [for v in local.vnics : lookup(lookup(v, "${i}_policy", {}), "name", "")]
    ))), ["UNUSED"]) },
    {
      ethernet_adapter = setsubtract(distinct(compact(concat(
        [for v in local.vnics : v.ethernet_adapter_policy.name],
        [for v in local.vnics : [for e in [v.usnic_settings] : e.usnic_adapter_policy.name][0]],
        [for v in local.vnics : [for e in [v.vmq_settings] : e.vmmq_adapter_policy.name][0]]
      ))), ["UNUSED"])
      ethernet_network = setsubtract(
        distinct(compact([for v in local.vnics : v.ethernet_network_policy.name])), ["UNUSED"]
      )
      ethernet_qos = setsubtract(distinct(compact([for v in local.vnics : v.ethernet_qos_policy.name])), ["UNUSED"])
      fc_adapter   = setsubtract(distinct(compact([for v in local.vhbas : v.fibre_channel_adapter_policy.name])), ["UNUSED"])
      fc_network   = setsubtract(distinct(compact([for v in local.vhbas : v.fibre_channel_network_policy.name])), ["UNUSED"])
      fc_qos       = setsubtract(distinct(compact([for v in local.vhbas : v.fibre_channel_qos_policy.name])), ["UNUSED"])
      fc_zone      = setsubtract(distinct(compact(flatten([for v in local.vhbas : v.fc_zone_policies]))), ["UNUSED"])
      ip_pool = setsubtract(distinct(compact(concat(
        [for v in local.imc_access : v.inband_ip_pool.name], [for v in local.imc_access : v.out_of_band_ip_pool.name],
        [for v in local.iscsi_boot : v.initiator_ip_pool.name]
      ))), ["UNUSED"])
      iqn_pool      = setsubtract(distinct(compact([for v in local.lan_connectivity : v.iqn_pool.name])), ["UNUSED"])
      iscsi_adapter = setsubtract(distinct(compact([for v in local.iscsi_boot : v.iscsi_adapter_policy.name])), ["UNUSED"])
      iscsi_boot    = setsubtract(distinct(compact([for v in local.vnics : v.iscsi_boot_policy.name])), ["UNUSED"])
      iscsi_static_target = setsubtract(distinct(compact(flatten([[for e in ["primary", "secondary"] : [
        for k, v in local.iscsi_boot : lookup(lookup(v, "${e}_target_policy", {}), "name", "")]]
      ]))), ["UNUSED"])
      mac_pool  = setsubtract(distinct(compact([for v in local.vnics : v.mac_address_pool.name])), ["UNUSED"])
      multicast = setsubtract(distinct(compact([for v in local.vlans : v.multicast_policy.name])), ["UNUSED"])
      wwnn_pool = setsubtract(distinct(compact([for v in local.san_connectivity : v.wwnn_pool.name])), ["UNUSED"])
      wwpn_pool = setsubtract(distinct(compact([for v in local.vhbas : v.wwpn_pool.name])), ["UNUSED"])
  })
  #
  # Local Defaults, no local loop
  cert_mgmt = local.defaults.certificate_management
  eng       = local.defaults.ethernet_network_group
  fcn       = local.defaults.fibre_channel_network
  fw        = local.defaults.firmware
  ipmi      = local.defaults.ipmi_over_lan
  lds       = local.defaults.drive_security
  vmedia    = local.defaults.virtual_media
  #
  # Global Settings
  moids_policies = var.policies.global_settings.moids_policies
  moids_pools    = var.policies.global_settings.moids_pools
  organization   = var.policies.organization
  orgs           = var.policies.orgs
  policies       = var.policies
  pools          = var.policies.pools
  ps             = var.policies_sensitive
  #
  # Naming Prefixes and Suffixes
  name_prefix = merge(local.defaults.name_prefix, lookup(local.defaults, "name_prefix", {}))
  name_suffix = merge(local.defaults.name_suffix, lookup(local.defaults, "name_suffix", {}))
  npfx = { for e in local.policy_names : e => length(local.name_prefix[e]
  ) > 0 ? local.name_prefix[e] : local.name_prefix.default }
  nsfx = { for e in local.policy_names : e => length(local.name_suffix[e]
  ) > 0 ? local.name_suffix[e] : local.name_suffix.default }

  #_________________________________________________________________
  #
  # Intersight Adapter Configuration Policy
  # GUI Location: Policies > Create Policy > Adapter Configuration
  #_________________________________________________________________
  ladapter = local.defaults.adapter_configuration
  laddvic  = local.ladapter.add_vic_adapter_configuration
  fecmode  = local.laddvic.dce_interface_settings.dce_interface_fec_modes
  adapter_configuration = {
    for value in lookup(local.policies, "adapter_configuration", {}) : value.name => {
      add_vic_adapter_configuration = [for v in value.add_vic_adapter_configuration : merge(local.laddvic, v, {
        dce_interface_settings = [
          for i in range(4) : {
            additional_properties = "", class_id = "adapter.DceInterfaceSettings"
            fec_mode = length(lookup(lookup(v, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode)
              ) == 4 ? element(lookup(lookup(v, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode), i
            ) : element(lookup(lookup(v, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode), 0)
            interface_id = i, object_type = "adapter.DceInterfaceSettings"
          }
        ]
      })]
      description  = lookup(value, "description", "")
      name         = "${local.npfx.adapter_configuration}${value.name}${local.nsfx.adapter_configuration}"
      organization = local.organization
      tags         = lookup(value, "tags", var.policies.global_settings.tags)
    }
  }

  #__________________________________________________________________
  #
  # Intersight Boot Order Policy
  # GUI Location: Policies > Create Policy > Boot Order
  #__________________________________________________________________
  lboot = local.defaults.boot_order
  bd    = local.lboot.boot_devices
  boot_loader = {
    ClassId     = "boot.Bootloader"
    Description = ""
    Name        = "BOOTx64.EFI"
    ObjectType  = "boot.Bootloader"
    Path        = "\\EFI\\BOOT\\"
  }
  boot_type = {
    Iscsi      = ["InterfaceName:interface_name:", "Port:port:0", "Slot:slot:MLOM"]
    LocalDisk  = ["Slot:slot:MSTOR-RAID"]
    Nvme       = []
    PchStorage = ["Lun:lun:0"]
    Pxe = ["InterfaceName:interface_name:", "InterfaceSource:interface_source:name", "IpType:ip_type:IPv4",
      "MacAddress:mac_address:", "Port:port:-1", "Slot:slot:MLOM"
    ]
    San          = ["InterfaceName:interface_name:", "Lun:lun:0", "Slot:slot:MLOM", "Wwpn:wwpn:"]
    VirtualMedia = ["Subtype:sub_type:None"]
  }
  boot_order = {
    for i in lookup(local.policies, "boot_order", []) : i.name => merge(local.lboot, i, {
      boot_devices = [for v in lookup(i, "boot_devices", []) : {
        additional_properties = length(regexall("Uefi", i.boot_mode)) > 0 && length(
          regexall("boot.Iscsi", v.object_type)) > 0 ? jsonencode(
          {
            Bootloader    = merge(local.boot_loader, lookup(v, "bootloader", {}))
            InterfaceName = lookup(v, "interface_name", null)
            Port          = lookup(v, "port", 0)
            Slot          = lookup(v, "slot", "MLOM")
          }) : v.object_type == "boot.Iscsi" ? jsonencode(
          {
            InterfaceName = lookup(v, "interface_name", null)
            Port          = lookup(v, "port", 0)
            Slot          = lookup(v, "slot", "MLOM")
          }) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
          regexall("boot.LocalDisk", v.object_type)) > 0 ? jsonencode(
          {
            Bootloader = merge(local.boot_loader, lookup(v, "bootloader", {}))
            Slot       = v.slot
          }) : v.object_type == "boot.LocalDisk" ? jsonencode(
          { Slot = v.slot }) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
          regexall("boot.Nvme", v.object_type)) > 0 ? jsonencode(
          { Bootloader = merge(local.boot_loader, lookup(v, "bootloader", {})) }
          ) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
          regexall("boot.PchStorage", v.object_type)) > 0 ? jsonencode(
          {
            Bootloader = merge(local.boot_loader, lookup(v, "bootloader", {}))
            Lun        = lookup(v, "lun", 0)
          }) : v.object_type == "boot.PchStorage" ? jsonencode(
          { Lun = lookup(v, "lun", 0) }) : v.object_type == "boot.Pxe" ? jsonencode(
          {
            InterfaceName   = lookup(v, "interface_name", null)
            InterfaceSource = lookup(v, "interface_source", "name")
            IpType          = lookup(v, "ip_type", "IPv4")
            MacAddress      = lookup(v, "mac_address", "")
            Port            = lookup(v, "port", -1)
            Slot            = lookup(v, "slot", "MLOM")
          }) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
          regexall("boot.San", v.object_type)) > 0 ? jsonencode(
          {
            Bootloader    = merge(local.boot_loader, lookup(v, "bootloader", {}))
            InterfaceName = lookup(v, "interface_name", null)
            Lun           = lookup(v, "lun", 0)
            Slot          = lookup(v, "slot", "MLOM")
            Wwpn          = lookup(v, "wwpn", "")
          }) : v.object_type == "boot.San" ? jsonencode(
          {
            InterfaceName = lookup(v, "interface_name", null)
            Lun           = lookup(v, "lun", 0)
            Slot          = lookup(v, "slot", "MLOM")
            Wwpn          = lookup(v, "wwpn", "")
          }) : length(regexall("Uefi", i.boot_mode)) > 0 && length(
          regexall("boot.SdCard", v.object_type)) > 0 ? jsonencode(
          {
            Bootloader = merge(local.boot_loader, lookup(v, "bootloader", {}))
            Lun        = lookup(v, "lun", 0)
            Subtype    = lookup(v, "sub_type", "None")
          }) : v.object_type == "boot.SdCard" ? jsonencode(
          {
            Lun     = lookup(v, "lun", 0)
            Subtype = lookup(v, "sub_type", "None")
          }) : v.object_type == "boot.Usb" ? jsonencode(
          { Subtype = lookup(v, "sub_type", "None") }
          ) : v.object_type == "boot.VirtualMedia" ? jsonencode(
          { Subtype = lookup(v, "sub_type", "None") }
        ) : ""
        enabled     = lookup(v, "enabled", true)
        name        = v.name
        object_type = v.object_type
      }]
      name         = "${local.npfx.boot_order}${i.name}${local.nsfx.boot_order}"
      organization = lookup(i, "organization", local.organization)
      tags         = lookup(i, "tags", var.policies.global_settings.tags)
    })
  }
  #boot_order = {
  #  for i in lookup(local.policies, "boot_order", []) : i.name => merge(local.defaults.boot_order, i, {
  #    boot_devices = [
  #      for v in lookup(i, "boot_devices", []) : {
  #        additional_properties = i.boot_mode == "Uefi" && length(regexall("^boot.(Pxe|Usb|VirtualMedia)", v.object_type)
  #          ) == 0 ? jsonencode(merge(
  #            { Bootloader = merge(local.boot_loader, lookup(v, "boot_loader", {})) },
  #            { for e in local.boot_type[element(split(".", v.object_type), 1)] : element(split(":", e), 0) => lookup(
  #              v, element(split(":", e), 1), element(split(":", e), 2)) })) : jsonencode({ for e in local.boot_type[
  #              element(split(".", v.object_type), 1)] : element(split(":", e), 0) => lookup(v, element(split(":", e), 1
  #        ), element(split(":", e), 2)) })
  #        enabled     = lookup(v, "enabled", true)
  #        name        = v.name
  #        object_type = v.object_type
  #      }
  #    ]
  #    name         = "${local.npfx.boot_order}${i.name}${local.nsfx.boot_order}"
  #    organization = lookup(i, "organization", local.organization)
  #    tags         = lookup(i, "tags", var.policies.global_settings.tags)
  #  })
  #}

  #__________________________________________________________________
  #
  # Intersight Ethernet Adapter Policy
  # GUI Location: Policies > Create Policy > Ethernet Adapter
  #__________________________________________________________________
  eadapt = local.defaults.ethernet_adapter
  earss  = local.eadapt.receive_side_scaling
  earsse = local.eadapt.receive_side_scaling_enable
  ethernet_adapter = {
    for v in lookup(local.policies, "ethernet_adapter", []) : v.name => merge(local.eadapt, v, {
      interrupt_settings = merge(local.eadapt.interrupt_settings,
        lookup(v, "interrupt_settings", {})
      )
      name         = "${local.npfx.ethernet_adapter}${v.name}${local.nsfx.ethernet_adapter}"
      organization = local.organization
      receive      = merge(local.eadapt.receive, lookup(v, "receive", {}))
      rss = length(regexall("EMPTY", lookup(v, "adapter_template", "EMPTY"))
      ) == 0 ? false : lookup(v, "receive_side_scaling_enable", local.earsse)
      receive_side_scaling = merge(local.earss, lookup(v, "receive_side_scaling", {}))
      receive_side_scaling_enable = length(regexall("EMPTY", lookup(v, "adapter_template", "EMPTY"))
      ) == 0 ? false : lookup(v, "receive_side_scaling_enable", local.earsse)
      roce_settings = merge(local.eadapt.roce_settings, lookup(v, "roce_settings", {}))
      tags          = lookup(v, "tags", var.policies.global_settings.tags)
      tcp_offload   = merge(local.eadapt.tcp_offload, lookup(v, "tcp_offload", {}))
      transmit      = merge(local.eadapt.transmit, lookup(v, "transmit", {}))
    })
  }

  #__________________________________________________________________
  #
  # Intersight Fibre Channel Adapter Policy
  # GUI Location: Policies > Create Policy > Fibre Channel Adapter
  #__________________________________________________________________

  fca = local.defaults.fibre_channel_adapter
  fibre_channel_adapter = {
    for v in lookup(local.policies, "fibre_channel_adapter", []) : v.name => merge(local.fca, v, {
      error_recovery     = merge(local.fca.error_recovery, lookup(v, "error_recovery", {}))
      flogi              = merge(local.fca.flogi, lookup(v, "flogi", {}))
      interrupt_settings = merge(local.fca.interrupt_settings, lookup(v, "interrupt_settings", {}))
      name               = "${local.npfx.fibre_channel_adapter}${v.name}${local.nsfx.fibre_channel_adapter}"
      organization       = local.organization
      plogi              = merge(local.fca.plogi, lookup(v, "plogi", {}))
      receive            = merge(local.fca.receive, lookup(v, "receive", {}))
      scsi_io            = merge(local.fca.scsi_io, lookup(v, "scsi_io", {}))
      tags               = lookup(v, "tags", var.policies.global_settings.tags)
      transmit           = merge(local.fca.transmit, lookup(v, "transmit", {}))
    })
  }

  #__________________________________________________________________
  #
  # Intersight IMC Access Policy
  # GUI Location: Policies > Create Policy > IMC Access
  #__________________________________________________________________

  imc_access = {
    for v in lookup(local.policies, "imc_access", {}) : v.name => merge(local.defaults.imc_access, v, {
      name                = "${local.npfx.imc_access}${v.name}${local.nsfx.imc_access}"
      inband_ip_pool      = { name = lookup(v, "inband_ip_pool", "UNUSED"), org = local.organization }
      organization        = local.organization
      out_of_band_ip_pool = { name = lookup(v, "out_of_band_ip_pool", "UNUSED"), org = local.organization }
      tags                = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }

  #__________________________________________________________________
  #
  # Intersight iSCSI Boot Policy
  # GUI Location: Policies > Create Policy > iSCSI Boot
  #__________________________________________________________________
  iboot             = local.defaults.iscsi_boot
  lookup_iscsi_boot = ["initiator_ip_pool", "iscsi_adapter_policy", "primary_target_policy", "secondary_target_policy"]
  iscsi_boot = {
    for v in lookup(local.policies, "iscsi_boot", {}) : v.name => merge(local.iboot, v, {
      initiator_static_ipv4_config = merge(
      local.iboot.initiator_static_ipv4_config, lookup(v, "initiator_static_ipv4_config", {}))
      name         = "${local.npfx.iscsi_boot}${v.name}${local.nsfx.iscsi_boot}"
      organization = local.organization
      tags         = lookup(v, "tags", var.policies.global_settings.tags)
    }, { for e in local.lookup_iscsi_boot : e => { name = lookup(v, e, "UNUSED"), org = local.organization } })
  }

  #_________________________________________________________________________
  #
  # Intersight LAN Connectivity
  # GUI Location: Configure > Policies > Create Policy > LAN Connectivity
  #_________________________________________________________________________
  lcp = local.defaults.lan_connectivity
  lan_connectivity = {
    for v in lookup(local.policies, "lan_connectivity", {}) : v.name => merge(local.lcp, v, {
      iqn_pool              = { name = lookup(v, "iqn_pool", "UNUSED"), organization = local.organization }
      iqn_static_identifier = lookup(v, "iqn_static_identifier", "")
      name                  = "${local.npfx.lan_connectivity}${v.name}${local.nsfx.lan_connectivity}"
      organization          = local.organization
      tags                  = lookup(v, "tags", var.policies.global_settings.tags)
      vnics = [
        for e in lookup(v, "vnics", []) : merge(local.lcp.vnics, e, {
          mac_addresses_static = lookup(e, "mac_addresses_static", [])
          names                = e.names
          placement            = merge(local.lcp.vnics.placement, lookup(e, "placement", {}))
          usnic_settings       = merge(local.lcp.vnics.usnic_settings, lookup(e, "usnic_settings", {}))
          vmq_settings         = merge(local.lcp.vnics.vmq_settings, lookup(e, "vmq_settings", {}))
        })
      ]
    })
  }
  vnics = { for i in flatten([
    for key, value in local.lan_connectivity : [
      for v in value.vnics : [
        for s in range(length(v.names)) : merge(v, {
          cdn_value = length(v.cdn_values) > 0 ? element(v.cdn_values, s) : ""
          enable_failover = length(compact([v.enable_failover])
          ) > 0 ? v.enable_failover : length(v.names) == 1 ? true : false
          ethernet_adapter_policy         = { name = v.ethernet_adapter_policy, org = value.organization }
          ethernet_network_control_policy = { name = v.ethernet_network_control_policy, org = value.organization }
          ethernet_network_group_policy = length(v.ethernet_network_group_policies) == 2 ? {
            name = element(v.ethernet_network_group_policies, s), org = value.organization
            } : length(v.ethernet_network_group_policies) == 1 ? {
            name = element(v.ethernet_network_group_policies, 0), org = value.organization
          } : { name = "UNUSED", org = value.organization }
          ethernet_network_policy = { name = v.ethernet_network_policy, org = value.organization }
          ethernet_qos_policy     = { name = v.ethernet_qos_policy, org = value.organization }
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
          usnic_settings = [for e in [v.usnic_settings] : merge(e, {
            usnic_adapter_policy = length(compact([lookup(e, "usnic_adapter_policy", "")])) > 0 ? {
              name = tostring(v.usnic_adapter_policy), org = value.organization
            } : { name = "UNUSED", org = "UNUSED" }
          })][0]
          vmq_settings = [for e in [lookup(v, "vmq_settings", {})] : merge(e, {
            vmmq_adapter_policy = length(compact([lookup(e, "vmmq_adapter_policy", "")])) > 0 ? {
              name = e.vmmq_adapter_policy, org = value.organization
            } : { name = "UNUSED", org = "UNUSED" }
          })][0]
        })
      ]
    ]
  ]) : "${i.lan_connectivity}:${i.name}" => i }

  #__________________________________________________________________
  #
  # Intersight LDAP Policy
  # GUI Location: Policies > Create Policy > LDAP
  #__________________________________________________________________
  lldap = local.defaults.ldap
  ldap = {
    for v in lookup(local.policies, "ldap", []) : v.name => merge(local.lldap, v, {
      base_settings = merge(local.lldap.base_settings, lookup(v, "base_settings", {}), {
        base_dn = length(compact([lookup(v.base_settings, "base_dn", "")])
        ) == 0 ? "DC=${join(",DC=", split(".", v.base_settings.domain))}" : v.base_settings.base_dn
        domain = v.base_settings.domain
      })
      binding_parameters = merge(local.lldap.binding_parameters, lookup(v, "binding_parameters", {}))
      ldap_from_dns      = merge(local.lldap.ldap_from_dns, lookup(v, "ldap_from_dns", {}))
      ldap_groups        = lookup(v, "ldap_groups", [])
      ldap_providers     = lookup(v, "ldap_providers", [])
      name               = "${local.npfx.ldap}${v.name}${local.nsfx.ldap}"
      organization       = local.organization
      search_parameters  = merge(local.lldap.search_parameters, lookup(v, "search_parameters", {}))
      tags               = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }
  ldap_groups = { for i in flatten([
    for key, value in local.ldap : [
      for v in value.ldap_groups : {
        domain        = value.base_settings.domain
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
    for v in lookup(local.policies, "local_user", []) : v.name => merge(local.defaults.local_user, v, {
      password_properties = merge(local.defaults.local_user.password_properties, lookup(v, "password_properties", {}))
      name                = "${local.npfx.local_user}${v.name}${local.nsfx.local_user}"
      organization        = local.organization
      tags                = lookup(v, "tags", var.policies.global_settings.tags)
      users               = lookup(v, "users", [])
    })
  }
  users = { for i in flatten([
    for key, value in local.local_user : [
      for v in value.users : merge(local.defaults.local_user.users, v, {
        local_user   = key
        name         = v.username
        organization = value.organization
        tags         = value.tags
      })
    ]
  ]) : "${i.local_user}:${i.name}" => i }

  #__________________________________________________________________
  #
  # Intersight Port Policy
  # GUI Location: Policies > Create Policy > Port
  #__________________________________________________________________
  lport = local.defaults.port
  port = { for s in flatten([
    for value in lookup(local.policies, "port", []) : [
      for i in range(length(value.names)) : merge(local.defaults.port, value, {
        key          = element(value.names, i)
        name         = "${local.npfx.port}${element(value.names, i)}${local.nsfx.port}"
        organization = local.organization
        port_channel_appliances = [
          for v in lookup(value, "port_channel_appliances", []) : merge(local.lport.port_channel_appliances, v, {
            interfaces = lookup(v, "interfaces", [])
            pc_id      = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
          })
        ]
        port_channel_ethernet_uplinks = [
          for v in lookup(value, "port_channel_ethernet_uplinks", []) : merge(local.lport.port_channel_ethernet_uplinks, v, {
            interfaces = lookup(v, "interfaces", [])
            pc_id      = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
          })
        ]
        port_channel_fc_uplinks = [
          for v in lookup(value, "port_channel_fc_uplinks", []) : merge(local.lport.port_channel_fc_uplinks, v, {
            interfaces = lookup(v, "interfaces", [])
            pc_id      = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
            vsan_id    = length(v.vsan_ids) == 1 ? element(v.vsan_ids, 0) : element(v.vsan_ids, i)
          })
        ]
        port_channel_fcoe_uplinks = [
          for v in lookup(value, "port_channel_fcoe_uplinks", []) : merge(local.lport.port_channel_fcoe_uplinks, v, {
            interfaces = lookup(v, "interfaces", [])
            pc_id      = length(v.pc_ids) == 1 ? element(v.pc_ids, 0) : element(v.pc_ids, i)
          })
        ]
        port_modes = [
          for v in lookup(value, "port_modes", []) : merge(local.lport.port_channel_ethernet_uplinks, v, {
            port_list = v.port_list
          })
        ]
        port_role_appliances = [
          for v in lookup(value, "port_role_appliances", []) : merge(local.lport.port_role_appliances, v, {
            port_list = v.port_list
          })
        ]
        port_role_ethernet_uplinks = [
          for v in lookup(value, "port_role_ethernet_uplinks", []) : merge(local.lport.port_role_ethernet_uplinks, v, {
            port_list = v.port_list
          })
        ]
        port_role_fc_storage = [
          for v in lookup(value, "port_role_fc_storage", []) : merge(local.lport.port_role_fc_storage, v, {
            port_list = v.port_list
            vsan_id   = length(v.vsan_ids) == 1 ? element(v.vsan_ids, 0) : element(v.vsan_ids, i)
          })
        ]
        port_role_fc_uplinks = [
          for v in lookup(value, "port_role_fc_uplinks", []) : merge(local.lport.port_role_fc_uplinks, v, {
            port_list = v.port_list
            vsan_id   = length(v.vsan_ids) == 1 ? element(v.vsan_ids, 0) : element(v.vsan_ids, i)
          })
        ]
        port_role_fcoe_uplinks = [
          for v in lookup(value, "port_role_fcoe_uplinks", []) : merge(local.lport.port_role_fcoe_uplinks, v, {
            interfaces = lookup(v, "interfaces", [])
            port_list  = v.port_list
          })
        ]
        port_role_servers = [
          for v in lookup(value, "port_role_servers", []) : merge(local.lport.port_role_servers, v, {
            port_list = v.port_list
          })
        ]
        tags = lookup(value, "tags", var.policies.global_settings.tags)
      })
    ]
  ]) : s.key => s }
  port_channel_appliances = { for i in flatten([for key, value in local.port : [
    for v in value.port_channel_appliances : merge(v, {
      ethernet_network_control_policy = {
        name = lookup(v, "ethernet_network_control_policy", "UNUSED"), org = value.organization
      }
      ethernet_network_group_policy = {
        name = lookup(v, "ethernet_network_group_policy", "UNUSED"), org = value.organization
      }
      link_aggregation_policy = { name = lookup(v, "link_aggregation_policy", "UNUSED"), org = value.organization }
      organization            = value.organization,
      port_policy             = key
      tags                    = value.tags
    })]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_ethernet_uplinks = { for i in flatten([for key, value in local.port : [
    for v in value.port_channel_ethernet_uplinks : merge(v, {
      ethernet_network_group_policy = {
        name = lookup(v, "ethernet_network_group_policy", "UNUSED"), org = value.organization
      }
      flow_control_policy     = { name = lookup(v, "flow_control_policy", "UNUSED"), org = value.organization }
      link_aggregation_policy = { name = lookup(v, "link_aggregation_policy", "UNUSED"), org = value.organization }
      link_control_policy     = { name = lookup(v, "link_control_policy", "UNUSED"), org = value.organization }
      organization            = value.organization
      port_policy             = key
      tags                    = value.tags
    })]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_fc_uplinks = { for i in flatten([
    for key, value in local.port : [
      for v in value.port_channel_fc_uplinks : merge(v, { port_policy = key, tags = value.tags })
    ]
  ]) : "${i.port_policy}:${i.pc_id}" => i }
  port_channel_fcoe_uplinks = { for i in flatten([for key, value in local.port : [
    for v in value.port_channel_fcoe_uplinks : merge(v, {
      link_aggregation_policy = { name = lookup(v, "link_aggregation_policy", "UNUSED"), org = value.organization }
      link_control_policy     = { name = lookup(v, "link_control_policy", "UNUSED"), org = value.organization }
      organization            = value.organization
      port_policy             = key
      tags                    = value.tags
    })]
  ]) : "${i.port_policy}:${i.pc_id}" => i }

  port_modes = { for i in flatten([for key, value in local.port : [for v in value.port_modes : merge(local.lport.port_modes, v, {
    port_policy = key
    tags        = value.tags
    })]
  ]) : "${i.port_policy}:${i.slot_id}-${element(i.port_list, 0)}" => i }

  /*
  Loop 1 is to determine if the port_list is:
  * A Single number. i.e. 1
  * A Range of numbers. i.e. 1-5
  * A List of numbers. i.e. 1-5,10-15
  And then to return these values as a list
  */
  port_role_appliances_loop = flatten([for key, value in local.port : [
    for v in value.port_role_appliances : merge(v, {
      organization = value.organization
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
      ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
      port_policy = key
      tags        = value.tags
    })
  ]])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_appliances = { for i in flatten([for v in local.port_role_appliances_loop : [
    for s in v.port_list : merge(v, {
      ethernet_network_control_policy = {
        name = lookup(v, "ethernet_network_control_policy", "UNUSED"), org = v.organization
      }
      ethernet_network_group_policy = {
        name = lookup(v, "ethernet_network_group_policy", "UNUSED"), org = v.organization
      }
      port_id = s
    })]
  ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #_________________________________________________________________
  #
  # Port Policy > Port Roles > Ethernet Uplinks Section - Locals
  #_________________________________________________________________
  port_role_ethernet_uplinks_loop = flatten([for key, value in local.port : [
    for v in value.port_role_ethernet_uplinks : merge(v, {
      organization = value.organization
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
      ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
      port_policy = key
      tags        = value.tags
    })
  ]])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_ethernet_uplinks = { for i in flatten([
    for v in local.port_role_ethernet_uplinks_loop : [
      for s in v.port_list : merge(v, {
        ethernet_network_group_policy = {
          name = lookup(v, "ethernet_network_group_policy", "UNUSED"), org = v.organization
        }
        flow_control_policy = { name = lookup(v, "flow_control_policy", "UNUSED"), org = v.organization }
        link_control_policy = { name = lookup(v, "link_control_policy", "UNUSED"), org = v.organization }
        port_id             = s
      })
    ]
  ]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #______________________________________________________________________
  #
  # Port Policy > Port Roles > Fibre-Channel Storage Section - Locals
  #______________________________________________________________________
  port_role_fc_storage_loop = flatten([for key, value in local.port : [
    for v in value.port_role_fc_storage : merge(v, {
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
      ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
      port_policy = key
      tags        = value.tags
    })]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fc_storage = { for i in flatten([for v in local.port_role_fc_storage_loop : [
    for s in v.port_list : merge(v, { port_id = s })
  ]]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #______________________________________________________________________
  #
  # Port Policy > Port Roles > Fibre-Channel Uplinks Section - Locals
  #______________________________________________________________________
  port_role_fc_uplinks_loop = flatten([for key, value in local.port : [
    for v in value.port_role_fc_uplinks : merge(v, {
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
      ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
      port_policy = key
      tags        = value.tags
    })]
  ])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fc_uplinks = { for i in flatten([for v in local.port_role_fc_uplinks_loop : [
    for s in v.port_list : merge(v, { port_id = s })
  ]]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  #_________________________________________________________________
  #
  # Port Policy > Port Roles > FCoE Uplinks Section - Locals
  #_________________________________________________________________
  port_role_fcoe_uplinks_loop = flatten([for key, value in local.port : [
    for v in value.port_role_fcoe_uplinks : merge(v, {
      organization = value.organization
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
      ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
      port_policy = key
      tags        = value.tags
    })
  ]])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_fcoe_uplinks = { for i in flatten([for v in local.port_role_fcoe_uplinks_loop : [
    for s in v.port_list : merge(v, {
      link_control_policy = { name = lookup(v, "link_control_policy", "UNUSED"), org = "UNUSED" }
      port_id             = s
  })]]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
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
  port_role_servers_loop = flatten([for key, value in local.port : [
    for v in value.port_role_servers : merge(v, {
      port_list = flatten(
        [for s in compact(length(regexall("-", v.port_list)) > 0 ? tolist(split(",", v.port_list)
          ) : length(regexall(",", v.port_list)) > 0 ? tolist(split(",", v.port_list)) : [v.port_list]
          ) : length(regexall("-", s)) > 0 ? [for v in range(tonumber(element(split("-", s), 0)
      ), (tonumber(element(split("-", s), 1)) + 1)) : tonumber(v)] : [s]])
      port_policy = key
      tags        = value.tags
    })
  ]])
  # Loop 2 will take the port_list created in Loop 1 and expand this out to a list of port_id's.
  port_role_servers = { for i in flatten([for v in local.port_role_servers_loop : [
    for s in v.port_list : merge(v, { port_id = s })
  ]]) : "${i.port_policy}:${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }

  #_________________________________________________________________________
  #
  # Intersight SAN Connectivity
  # GUI Location: Configure > Policies > Create Policy > SAN Connectivity
  #_________________________________________________________________________
  scp = local.defaults.san_connectivity
  san_connectivity = { for v in lookup(local.policies, "san_connectivity", []) : v.name => merge(local.scp, v, {
    name         = "${local.npfx.san_connectivity}${v.name}${local.nsfx.san_connectivity}"
    organization = local.organization
    tags         = lookup(v, "tags", var.policies.global_settings.tags)
    wwnn_pool    = { name = lookup(v, "wwnn_pool", "UNUSED"), org = local.organization }
    vhbas = [
      for e in lookup(v, "vhbas", []) : merge(local.scp.vhbas, e, {
        names     = e.names
        placement = merge(local.scp.vhbas.placement, lookup(v, "placement", {}))
      })
    ]
    })
  }
  vhbas = { for i in flatten([
    for key, value in local.san_connectivity : [
      for v in value.vhbas : [
        for s in range(length(v.names)) : merge(v, {
          fc_zone_policies = length(v.fc_zone_policies) > 0 ? element(chunklist(v.fc_zone_policies, 2), s) : []
          fibre_channel_adapter_policy = {
            name = v.fibre_channel_adapter_policy, org = local.organization
          }
          fibre_channel_network_policy = length(v.fibre_channel_network_policies) == 2 ? {
            name = element(v.fibre_channel_network_policies, s), org = value.organization
            } : length(v.fibre_channel_network_policies) == 1 ? {
            name = element(v.fibre_channel_network_policies, 0), org = value.organization
          } : { name = "UNUSED", org = value.organization }
          fibre_channel_qos_policy = { name = v.fibre_channel_qos_policy, org = value.organization }
          name                     = element(v.names, s)
          organization             = value.organization
          placement = [for e in [v.placement] : {
            pci_link    = length(e.pci_links) == 1 ? element(e.pci_links, 0) : element(e.pci_links, s)
            pci_order   = length(e.pci_order) == 1 ? element(e.pci_order, 0) : element(e.pci_order, s)
            slot_id     = length(e.slot_ids) == 1 ? element(e.slot_ids, 0) : element(e.slot_ids, s)
            switch_id   = length(e.switch_ids) == 1 ? element(e.switch_ids, 0) : element(e.switch_ids, s)
            uplink_port = length(e.uplink_ports) == 1 ? element(e.uplink_ports, 0) : element(e.uplink_ports, s)
          }][0]
          san_connectivity = key
          wwpn_pool = length(v.wwpn_pools) == 2 ? { name = element(v.wwpn_pools, s), org = local.organization
            } : length(v.wwpn_pools) == 2 ? { name = element(v.wwpn_pools, s), org = local.organization
          } : { name = "UNUSED", org = "UNUSED" }
          wwpn_static_address = length(v.wwpn_static_addresses) > 0 ? element(v.wwpn_static_addresses, s) : ""
        })
      ]
    ]
  ]) : "${i.san_connectivity}:${i.name}" => i }

  #_________________________________________________________________________
  #
  # Intersight SNNMP Policy
  # GUI Location: Configure > Policies > Create Policy > SNMP
  #_________________________________________________________________________
  lsnmp = local.defaults.snmp
  snmp = {
    for v in lookup(local.policies, "snmp", []) : v.name => merge(local.lsnmp, v, {
      name         = "${local.npfx.snmp}${v.name}${local.nsfx.snmp}"
      organization = local.organization
      snmp_trap_destinations = [
        for e in lookup(v, "snmp_trap_destinations", []) : merge(local.lsnmp.snmp_trap_destinations, e)
      ]
      snmp_users = [for e in lookup(v, "snmp_users", []) : merge(local.lsnmp.snmp_users, e)]
      v2_enabled = compact(flatten([[
        for k in keys(local.ps.snmp.access_community_string) : local.ps.snmp.access_community_string[k] if length(
        local.ps.snmp.access_community_string[k]) > 0], [
        for k in keys(local.ps.snmp.trap_community_string) : local.ps.snmp.trap_community_string[k] if length(
        local.ps.snmp.trap_community_string[k]) > 0
      ]]))
      tags = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }

  #_________________________________________________________________________
  #
  # Intersight Storage Policy
  # GUI Location: Configure > Policies > Create Policy > Storage
  #_________________________________________________________________________
  dga = local.defaults.storage.drive_groups.automatic_drive_group
  dgm = local.defaults.storage.drive_groups.manual_drive_group
  dgv = local.defaults.storage.drive_groups.virtual_drives
  sdr = local.defaults.storage.single_drive_raid0_configuration
  storage = {
    for v in lookup(local.policies, "storage", []) : v.name => merge(local.defaults.storage, v, {
      drive_groups = lookup(v, "drive_groups", [])
      m2_raid_configuration = length(lookup(v, "m2_raid_configuration", {})
      ) > 0 ? [lookup(v, "m2_raid_configuration", {})] : []
      name         = "${local.npfx.storage}${v.name}${local.nsfx.storage}"
      organization = local.organization
      single_drive_raid0_configuration = [
        for e in lookup(v, "single_drive_raid0_configuration", {}) : merge(local.sdr, e)
      ]
      tags = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }
  drive_groups = { for i in flatten([
    for key, value in local.storage : [
      for v in value.drive_groups : {
        automatic_drive_group = length(lookup(v, "automatic_drive_group", {})
        ) > 0 ? [lookup(v, "automatic_drive_group", {})] : []
        manual_drive_group = length(lookup(v, "manual_drive_group", {})
        ) > 0 ? [lookup(v, "manual_drive_group", {})] : []
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
  # Intersight System QoS Policy
  # GUI Location: Configure > Policies > Create Policy > System QoS
  #_________________________________________________________________________
  qos = local.defaults.system_qos
  system_qos = {
    for v in lookup(local.policies, "system_qos", []) : v.name => merge(local.qos, v, {
      classes = length(regexall(true, lookup(v, "use_recommendations", local.qos.use_recommendations))
        ) > 0 ? local.qos.recommended_classes : length(compact(lookup(v, "classes", []))
      ) == 0 ? local.qos.classes : { for v in v.classes : v.priority => v }
      name         = "${local.npfx.system_qos}${v.name}${local.nsfx.system_qos}"
      organization = local.organization
      tags         = lookup(v, "tags", var.policies.global_settings.tags)
    })
  }

  #_________________________________________________________________________
  #
  # Intersight VLAN Policy
  # GUI Location: Configure > Policies > Create Policy > VLAN
  #_________________________________________________________________________
  vlan = {
    for v in lookup(local.policies, "vlan", []) : v.name => merge(local.defaults.vlan, v, {
      name         = "${local.npfx.vlan}${v.name}${local.nsfx.vlan}"
      organization = local.organization
      tags         = lookup(v, "tags", var.policies.global_settings.tags)
      vlans = [
        for e in lookup(v, "vlans", []) : merge(local.defaults.vlan.vlans, e, {
          multicast_policy = e.multicast_policy
          vlan_list        = e.vlan_list
        })
      ]
    })
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
  vlans = { for i in flatten([for v in local.vlans_loop : [
    for s in v.vlan_list : {
      auto_allow_on_uplinks = v.auto_allow_on_uplinks
      multicast_policy      = { name = v.multicast_policy, org = local.organization }
      name                  = v.name
      name_prefix           = v.name_prefix
      native_vlan           = v.native_vlan
      organization          = v.organization
      primary_vlan_id       = v.primary_vlan_id
      sharing_type          = v.sharing_type
      vlan_id               = s
      vlan_policy           = v.vlan_policy
    }
  ]]) : "${i.vlan_policy}:${i.vlan_id}" => i }

  #_________________________________________________________________________
  #
  # Intersight VSAN Policy
  # GUI Location: Configure > Policies > Create Policy > VSAN
  #_________________________________________________________________________
  vsan = {
    for v in lookup(local.policies, "vsan", []) : v.name => merge(local.defaults.vsan, v, {
      name         = "${local.npfx.vsan}${v.name}${local.nsfx.vsan}"
      organization = local.organization
      tags         = lookup(v, "tags", var.policies.global_settings.tags)
      vsans        = lookup(v, "vsans", [])
    })
  }
  vsans = { for i in flatten([for key, value in local.vsan : [
    for v in value.vsans : merge(local.defaults.vsan.vsans, v, {
      fcoe_vlan_id = lookup(v, "fcoe_vlan_id", v.vsan_id)
      organization = value.organization
      vsan_policy  = key
    })
  ]]) : "${i.vsan_policy}:${i.vsan_id}" => i }
}
