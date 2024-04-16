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
  pp = merge({ for i in local.network_policies : i => distinct(compact(concat(
    flatten([for v in local.port_channel_appliances : [for e in lookup(v, "${i}_policy", { name = "UNUSED", org = "UNUSED" }) : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
    flatten([for v in local.port_channel_ethernet_uplinks : [for e in [lookup(v, "${i}_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
    flatten([for v in local.port_channel_fcoe_uplinks : [for e in [lookup(v, "${i}_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
    flatten([for v in local.port_role_appliances : [for e in [lookup(v, "${i}_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
    flatten([for v in local.port_role_ethernet_uplinks : [for e in [lookup(v, "${i}_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
    flatten([for v in local.port_role_fcoe_uplinks : [for e in [lookup(v, "${i}_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
    flatten([for v in local.vnics : [for e in [lookup(v, "${i}_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]])
    )))
    }, {
    ethernet_adapter = distinct(compact(concat(
      flatten([for v in local.vnics : [for e in [v.ethernet_adapter_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
      flatten([for v in local.vnics : [for s in [v.usnic_settings] : [
        for e in [lookup(s, "usnic_adapter_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]]
      ),
      flatten([for v in local.vnics : [for s in [v.usnic_settings] : [
        for e in [lookup(s, "vmmq_adapter_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]]
      )
    )))
    ethernet_network      = distinct(compact(flatten([for v in local.vnics : [for e in [v.ethernet_network_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    ethernet_qos          = distinct(compact(flatten([for v in local.vnics : [for e in [v.ethernet_qos_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    fc_zone               = distinct(compact(flatten([for v in local.vhbas : [for e in v.fc_zone_policies : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    fibre_channel_adapter = distinct(compact(flatten([for v in local.vhbas : [for e in [v.fibre_channel_adapter_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    fibre_channel_network = distinct(compact(flatten([for v in local.vhbas : [for e in [v.fibre_channel_network_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    fibre_channel_qos     = distinct(compact(flatten([for v in local.vhbas : [for e in [v.fibre_channel_qos_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    ip = distinct(compact(concat(
      flatten([for v in local.imc_access : [for e in [v.inband_ip_pool] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
      flatten([for v in local.imc_access : [for e in [v.out_of_band_ip_pool] : "${e.org}/${e.name}" if e.name != "UNUSED"]]),
      flatten([for v in local.iscsi_boot : [for e in [v.initiator_ip_pool] : "${e.org}/${e.name}" if e.name != "UNUSED"]])
    )))
    iqn           = distinct(compact(flatten([for v in local.lan_connectivity : [for e in [v.iqn_pool] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    iscsi_adapter = distinct(compact(flatten([for v in local.iscsi_boot : [for e in [v.iscsi_adapter_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    iscsi_boot    = distinct(compact(flatten([for v in local.vnics : [for e in [v.iscsi_boot_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    iscsi_static_target = distinct(compact(flatten([[for s in ["primary", "secondary"] : [
      for k, v in local.iscsi_boot : [for e in [lookup(v, "${s}_target_policy", { name = "UNUSED", org = "UNUSED" })] : "${e.org}/${e.name}" if e.name != "UNUSED"]]
    ]])))
    mac       = distinct(compact(flatten([for v in local.vnics : [for e in [v.mac_address_pool] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    multicast = distinct(compact(flatten([for v in local.vlans : [for e in [v.multicast_policy] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    wwnn      = distinct(compact(flatten([for v in local.san_connectivity : [for e in [v.wwnn_pool] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
    wwpn      = distinct(compact(flatten([for v in local.vhbas : [for e in [v.wwpn_pool] : "${e.org}/${e.name}" if e.name != "UNUSED"]])))
  })
  pools = {
    ip   = { moids = lookup(lookup(var.pools, "map", {}), "ip", []), object = "ippool.Pool" }
    iqn  = { moids = lookup(lookup(var.pools, "map", {}), "iqn", []), object = "iqnpool.Pool" }
    mac  = { moids = lookup(lookup(var.pools, "map", {}), "mac", []), object = "macpool.Pool" }
    wwnn = { moids = lookup(lookup(var.pools, "map", {}), "wwnn", []), object = "fcpool.Pool" }
    wwpn = { moids = lookup(lookup(var.pools, "map", {}), "wwpn", []), object = "fcpool.Pool" }
  }
  policies = {
    ethernet_adapter         = { keys = keys(local.ethernet_adapter), object = "vnic.EthAdapterPolicy" }
    ethernet_network         = { keys = keys(local.ethernet_network), object = "vnic.EthNetworkPolicy" }
    ethernet_network_control = { keys = keys(local.ethernet_network_control), object = "fabric.EthNetworkControlPolicy" }
    ethernet_network_group   = { keys = keys(local.ethernet_network_group), object = "fabric.EthNetworkGroupPolicy" }
    ethernet_qos             = { keys = keys(local.ethernet_qos), object = "vnic.EthQosPolicy" }
    fc_zone                  = { keys = keys(local.fc_zone), object = "fabric.FcZonePolicy" }
    fibre_channel_adapter    = { keys = keys(local.fibre_channel_adapter), object = "vnic.FcAdapterPolicy" }
    fibre_channel_network    = { keys = keys(local.fibre_channel_network), object = "vnic.FcNetworkPolicy" }
    fibre_channel_qos        = { keys = keys(local.fibre_channel_qos), object = "vnic.FcQosPolicy" }
    flow_control             = { keys = keys(local.flow_control), object = "fabric.FlowControlPolicy" }
    iscsi_adapter            = { keys = keys(local.iscsi_adapter), object = "vnic.IscsiAdapterPolicy" }
    iscsi_boot               = { keys = keys(local.iscsi_boot), object = "vnic.IscsiBootPolicy" }
    iscsi_static_target      = { keys = keys(local.iscsi_static_target), object = "vnic.IscsiStaticTargetPolicy" }
    link_aggregation         = { keys = keys(local.link_aggregation), object = "fabric.LinkAggregationPolicy" }
    link_control             = { keys = keys(local.link_control), object = "fabric.LinkControlPolicy" }
    multicast                = { keys = keys(local.multicast), object = "fabric.MulticastPolicy" }
  }
  policy_types = [
    "ethernet_adapter", "ethernet_network", "ethernet_network_control", "ethernet_network_group", "ethernet_qos",
    "fc_zone", "fibre_channel_adapter", "fibre_channel_network", "fibre_channel_qos", "flow_control",
    "iscsi_adapter", "iscsi_boot", "iscsi_static_target", "link_aggregation", "link_control", "multicast"
  ]
  pool_types = ["ip", "iqn", "mac", "wwnn", "wwpn"]
  data_policies = { for e in local.policy_types : e => [for v in local.pp[e] : element(split("/", v), 1
  ) if contains(local.policies[e].keys, v) == false] }
  data_pools = { for e in local.pool_types : e => [for v in local.pp[e] : element(split("/", v), 1
  ) if contains(keys(local.pools[e].moids), v) == false] }
  #
  # Local Defaults, no local loop
  cert_mgmt = local.defaults.certificate_management
  eng       = local.defaults.ethernet_network_group
  fcn       = local.defaults.fibre_channel_network
  fw        = local.defaults.firmware
  lds       = local.defaults.drive_security
  vmedia    = local.defaults.virtual_media
  #
  # Global Settings
  org_moids = { for k, v in var.orgs : v => k }
  ps        = var.policies_sensitive
  #
  # Naming Prefixes and Suffixes
  name_prefix = local.defaults.name_prefix
  name_suffix = local.defaults.name_suffix
  npfx = { for org in sort(keys(var.model)) : org => merge(
    { for e in local.policy_names : e => lookup(lookup(var.model[org], "name_prefix", local.name_prefix), e, local.name_prefix[e]) },
    { organization = org })
  }
  nsfx = { for org in sort(keys(var.model)) : org => merge(
    { for e in local.policy_names : e => lookup(lookup(var.model[org], "name_suffix", local.name_suffix), e, local.name_suffix[e]) },
    { organization = org })
  }

  #_________________________________________________________________
  #
  # Intersight Adapter Configuration Policy
  # GUI Location: Policies > Create Policy > Adapter Configuration
  #_________________________________________________________________
  ladapter = local.defaults.adapter_configuration
  laddvic  = local.ladapter.add_vic_adapter_configuration
  fecmode  = local.laddvic.dce_interface_settings.dce_interface_fec_modes
  adapter_configuration = { for i in flatten([for org in sort(keys(var.model)) : [
    for value in lookup(lookup(var.model[org], "policies", {}), "adapter_configuration", []) : {
      add_vic_adapter_configuration = [for v in value.add_vic_adapter_configuration : merge(local.laddvic, v, {
        dce_interface_settings = [
          for int in range(4) : {
            additional_properties = "", class_id = "adapter.DceInterfaceSettings"
            fec_mode = length(lookup(lookup(v, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode)
              ) == 4 ? element(lookup(lookup(v, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode), int
            ) : element(lookup(lookup(v, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode), 0)
            interface_id = int, object_type = "adapter.DceInterfaceSettings"
          }
        ]
      })]
      description  = lookup(value, "description", "")
      key          = value.name
      name         = "${local.npfx[org].adapter_configuration}${value.name}${local.nsfx[org].adapter_configuration}"
      organization = org
      tags         = lookup(value, "tags", var.global_settings.tags)
    }
  ] if length(lookup(lookup(var.model[org], "policies", {}), "adapter_configuration", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight BIOS Policy
  # GUI Location: Policies > Create Policy > BIOS
  #__________________________________________________________________
  bios = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "bios", []) : lookup(v, "bios_template", "UNUSED") != "UNUSED" ? merge(
      local.defaults.bios, local.defaults.bios_templates[replace(v.bios_template, "-tpm", "")],
      local.defaults.bios_templates[length(regexall("-tpm$", v.bios_template)) > 0 ? "tpm" : "tpm_disabled"], v, {
        key          = v.name
        name         = "${local.npfx[org].bios}${v.name}${local.nsfx[org].bios}"
        organization = org
        tags         = lookup(v, "tags", var.global_settings.tags)
      }
      ) : merge(
      local.defaults.bios, v, {
        key          = v.name
        name         = "${local.npfx[org].bios}${v.name}${local.nsfx[org].bios}"
        organization = org
        tags         = lookup(v, "tags", var.global_settings.tags)
      }
    )
  ] if length(lookup(lookup(var.model[org], "policies", {}), "bios", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Boot Order Policy
  # GUI Location: Policies > Create Policy > Boot Order
  #__________________________________________________________________
  boot_arg_convert = {
    bootloader  = "Bootloader", description = "Description", device_name = "Name", device_type = "ObjectType", enabled = "Enabled", dns_ip = "DnsIp",
    gateway_ip  = "GatewayIp", interface_name = "InterfaceName", interface_source = "InterfaceSource", ip_config_type = "IpConfigType", ip_type = "IpType",
    ipv4_config = "StaticIpV4Settings", ipv6_config = "StaticIpV6Settings", lun = "Lun", mac_address = "MacAddress", network_mask = "NetworkMask",
    path        = "Path", port = "Port", prefix_length = "PrefixLength", protocol = "Protocol", slot = "Slot", static_ip = "Ip", subtype = "Subtype",
    target_wwpn = "Wwpn", uri = "Uri",
  }
  boot_arguments = {
    flex_mmc = { Subtype = "flexmmc-mapped-dvd" }
    http_boot = { InterfaceName = "", InterfaceSource = "name", IpConfigType = "DHCP", IpType = "IPv4", MacAddress = "", Port = -1,
      Protocol = "HTTPS", Slot = "MLOM", Uri = ""
    }
    iscsi_boot    = { InterfaceName = "", Port = 0, Slot = "MLOM" }
    local_disk    = { Slot = "MSTOR-RAID" }
    nvme          = {}
    pch_storage   = { Lun = 0 }
    pxe_boot      = { InterfaceName = "", InterfaceSource = "name", IpType = "IPv4", MacAddress = "", Port = -1, Slot = "MLOM" }
    san_boot      = { InterfaceName = "", Lun = 0, Slot = "MLOM", Wwpn = "20:00:00:25:B5:00:00:00" }
    sd_card       = { Subtype = "SDCARD", Lun = 0 }
    uefi_shell    = {}
    usb           = { Subtype = "usb-cd" }
    virtual_media = { Subtype = "kvm-mapped-dvd" }
  }
  boot_loader = {
    ClassId    = "boot.Bootloader", Description = "", Name = "BOOTx64.EFI",
    ObjectType = "boot.Bootloader", Path = "\\EFI\\BOOT\\"
  }
  boot_loader_keys = { description = "Description", name = "Name", path = "Path" }
  boot_object_types = {
    flex_mmc   = "boot.FlexMmc", http_boot = "boot.Http", iscsi_boot = "boot.Iscsi", local_cdd = "boot.LocalCdd", local_disk = "boot.LocalDisk",
    nvme       = "boot.Nvme", pch_storage = "boot.PchStorage", pxe_boot = "boot.Pxe", san_boot = "boot.San", sd_card = "boot.SdCard",
    uefi_shell = "boot.UefiShell", usb = "boot.Usb", virtual_media = "boot.VirtualMedia"
  }
  boot_static_ipv4 = {
    ClassId    = "boot.StaticIpV4Settings", DnsIp = "", GatewayIp = "", Ip = "",
    ObjectType = "boot.StaticIpV4Settings", NetworkMask = ""
  }
  boot_static_ipv6 = {
    ClassId    = "boot.StaticIpV6Settings", DnsIp = "", GatewayIp = "", Ip = "",
    ObjectType = "boot.StaticIpV6Settings", PrefixLength = 1
  }
  boot_order = { for i in flatten([for org in sort(keys(var.model)) : [
    for e in lookup(lookup(var.model[org], "policies", {}), "boot_order", []) : merge(local.defaults.boot_order, e, {
      boot_devices = [
        for v in lookup(e, "boot_devices", []) : {
          additional_properties = e.boot_mode == "Uefi" && length(regexall("^(iscsi|san)_boot|local_disk|nvme|pch_storage|sd_card$", v.device_type)
            ) > 0 && length(lookup(v, "boot_loader", {})) > 0 ? jsonencode(merge(
              { Bootloader = merge(local.boot_loader, { for key, value in lookup(v, "boot_loader", {}) : local.boot_loader_keys[key] => value }) },
              merge(local.boot_arguments[v.device_type], { for key, value in v : local.boot_arg_convert[key] => value if contains(
            keys(local.boot_arguments[v.device_type]), local.boot_arg_convert[key]) }))
            ) : v.device_type == "http_boot" ? jsonencode(merge(
              { StaticIpV4Settings = merge(local.boot_static_ipv4, { for key, value in lookup(v, "ipv4_config", {}) : local.boot_arg_convert[key] => value }) },
              { StaticIpV6Settings = merge(local.boot_static_ipv6, { for key, value in lookup(v, "ipv6_config", {}) : local.boot_arg_convert[key] => value }) },
              merge(local.boot_arguments[v.device_type], { for key, value in v : local.boot_arg_convert[key] => value if contains(
            keys(local.boot_arguments[v.device_type]), local.boot_arg_convert[key]) }))
            ) : jsonencode(merge(local.boot_arguments[v.device_type], {
              for key, value in v : local.boot_arg_convert[key] => value if contains(keys(local.boot_arguments[v.device_type]), local.boot_arg_convert[key])
          }))
          enabled     = lookup(v, "enabled", true)
          name        = v.device_name
          object_type = local.boot_object_types[v.device_type]
        }
      ]
      key          = e.name
      name         = "${local.npfx[org].boot_order}${e.name}${local.nsfx[org].boot_order}"
      organization = org
      tags         = lookup(e, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "boot_order", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Certificate Management Policy
  # GUI Location: Policies > Create Policy > Certificate Management
  #__________________________________________________________________
  certificate_management = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "certificate_management", []) : merge(local.cert_mgmt, v, {
      certificates = [for e in lookup(v, "certificates", []) : merge(local.cert_mgmt.certificates, e)]
      key          = v.name
      name         = "${local.npfx[org].certificate_management}${v.name}${local.nsfx[org].certificate_management}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    }) if lookup(v, "assigned_sensitive_data", false) == true
  ] if length(lookup(lookup(var.model[org], "policies", {}), "certificate_management", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Device Connector Policy
  # GUI Location: Policies > Create Policy > Device Connector
  #__________________________________________________________________
  device_connector = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "device_connector", []) : merge(local.defaults.device_connector, v, {
      key          = v.name
      name         = "${local.npfx[org].device_connector}${v.name}${local.nsfx[org].device_connector}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "device_connector", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Drive Security Policy
  # GUI Location: Policies > Create Policy > Drive Security
  #__________________________________________________________________
  drive_security = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "drive_security", []) : merge(local.lds, v, {
      key              = v.name
      name             = "${local.npfx[org].drive_security}${v.name}${local.nsfx[org].drive_security}"
      organization     = org
      primary_server   = merge(local.lds.primary_server, lookup(v, "primary_server", {}))
      secondary_server = merge(local.lds.secondary_server, lookup(v, "secondary_server", {}))
      tags             = lookup(v, "tags", var.global_settings.tags)
    }) if lookup(v, "assigned_sensitive_data", local.lds.assigned_sensitive_data) == true
  ] if length(lookup(lookup(var.model[org], "policies", {}), "drive_security", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Ethernet Adapter Policy
  # GUI Location: Policies > Create Policy > Ethernet Adapter
  #__________________________________________________________________
  eth_adapter = local.defaults.ethernet_adapter
  eth_adapter_templates = {
    "16RxQs-4G" = {
      description        = "Recommended adapter settings for 16RxQs-4G."
      completion         = { queue_count = 9 }
      interrupt_settings = { interrupts = 19 }
      receive            = { queue_count = 8, ring_size = 4096 }
      transmit           = { queue_count = 1, ring_size = 4096 }
    }
    "16RxQs-5G" = {
      description        = "Recommended adapter settings for 16RxQs-5G."
      completion         = { queue_count = 9 }
      interrupt_settings = { interrupts = 19 }
      receive            = { queue_count = 16, ring_size = 16384 }
      transmit           = { queue_count = 1, ring_size = 16384 }
    }
    EMPTY = {}
    Linux = {
      description        = "Recommended adapter settings for linux."
      completion         = { queue_count = 2 }
      interrupt_settings = { interrupts = 4 }
      receive            = { queue_count = 1 }
      receive_side_scaline = {
        enable_receive_side_scaling = false
        enable_ipv4_hash            = false
        enable_ipv6_hash            = false
        enable_tcp_and_ipv4_hash    = false
        enable_tcp_and_ipv6_hash    = false
      }
    }
    Linux-NVMe-RoCE = {
      description        = "Recommended adapter settings for NVMe using RDMA."
      completion         = { queue_count = 2 }
      interrupt_settings = { interrupts = 256 }
      receive            = { queue_count = 1 }
      roce_settings      = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 1024, resource_groups = 8, version = 2 }
    }
    Linux-v2 = {
      description        = "Recommended adapter settings for linux Version 2."
      completion         = { queue_count = 9 }
      interrupt_settings = { interrupts = 11 }
      receive            = { queue_count = 8, ring_size = 4096 }
      roce_settings      = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 1024, resource_groups = 8, version = 2 }
      transmit           = { queue_count = 1, ring_size = 4096 }
    }
    MQ = {
      description        = "Recommended adapter settings for VM Multi Queue Connection with no RDMA."
      completion         = { queue_count = 576, ring_size = 4 }
      interrupt_settings = { interrupts = 256 }
      receive            = { queue_count = 512 }
      transmit           = { queue_count = 64 }
    }
    MQ-SMBd = {
      description        = "Recommended adapter settings for MultiQueue with RDMA."
      completion         = { queue_count = 576 }
      interrupt_settings = { interrupts = 512 }
      receive            = { queue_count = 512, ring_size = 512 }
      roce_settings      = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 65536, queue_pairs = 256, resource_groups = 2, version = 2 }
      transmit           = { queue_count = 64, ring_size = 256 }
    }
    SMBClient = {
      description   = "Recommended adapter settings for SMB Client.",
      roce_settings = { enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 256, resource_groups = 32 }
    }
    SMBServer = {
      description   = "Recommended adapter settings for SMB server."
      roce_settings = { enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 2048, resource_groups = 32 }
    }
    Solaris = {
      description        = "Recommended adapter settings for Solaris.",
      completion         = { queue_count = 2 }
      interrupt_settings = { interrupts = 4 }
      receive_side_scaling = {
        enable_receive_side_scaling = false
        enable_ipv4_hash            = false
        enable_ipv6_hash            = false
        enable_tcp_and_ipv4_hash    = false
        enable_tcp_and_ipv6_hash    = false
      }
    }
    SRIOV-HPN = {
      description        = "Recommended adapter settings for SRIOV high performance and networking."
      interrupt_settings = { interrupts = 32 }
    }
    usNIC = {
      description             = "Recommended adapter settings for usNIC Connection."
      completion              = { queue_count = 12 }
      receive                 = { queue_count = 6 }
      transmit                = { queue_count = 6 }
      uplink_fallback_timeout = 0
    }
    usNICOracleRAC = {
      description              = "Recommended adapter settings for usNIC Oracle RAC Connection."
      enable_interrupt_scaling = true
      completion               = { queue_count = 2000, ring_size = 4 }
      interrupt_settings       = { interrupts = 1024 }
      receive                  = { queue_count = 1000 }
      transmit                 = { queue_count = 1000 }
      uplink_fallback_timeout  = 0
    }
    VMware = {
      description        = "Recommended adapter settings for VMware."
      completion         = { queue_count = 2 }
      interrupt_settings = { interrupts = 4 }
      receive            = { queue_count = 4 }
      receive_side_scaling = {
        enable_receive_side_scaling = false
        enable_ipv4_hash            = false
        enable_ipv6_hash            = false
        enable_tcp_and_ipv4_hash    = false
        enable_tcp_and_ipv6_hash    = false
      }
    }
    VMware-High-Trf = {
      description        = "Recommended adapter settings for VMware High Traffic."
      completion         = { queue_count = 9 }
      interrupt_settings = { interrupts = 11 }
      receive            = { queue_count = 8, ring_size = 4096 }
      transmit           = { queue_count = 1, ring_size = 4096 }
    }
    VMware-v2 = {
      description        = "Recommended adapter settings for VMware Version 2."
      completion         = { queue_count = 9 }
      interrupt_settings = { interrupts = 11 }
      receive            = { queue_count = 8, ring_size = 4096 }
      roce_settings      = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 1024, resource_groups = 8, version = 2 }
      transmit           = { queue_count = 1, ring_size = 4096 }
    }
    VMWareNVMeRoCEv2 = {
      description        = "Recommended adapter settings for VMware NVMe ROCEv2."
      completion         = { queue_count = 2 }
      interrupt_settings = { interrupts = 256 }
      receive            = { queue_count = 1, ring_size = 512 }
      roce_settings      = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 1024, resource_groups = 8, version = 2 }
      transmit           = { queue_count = 1, ring_size = 256 }
    }
    VMwarePassThru = {
      description        = "Recommended adapter settings for VMware pass-thru."
      completion         = { queue_count = 8 }
      interrupt_settings = { interrupts = 12 }
      transmit           = { queue_count = 4 }
    }
    Win-AzureStack = {
      description                   = "Recommended adapter settings for Azure Stack."
      enable_virtual_extensible_lan = true
      completion                    = { queue_count = 11, ring_size = 256 }
      interrupt_settings            = { interrupts = 256 }
      receive                       = { queue_count = 8, ring_size = 4096 }
      roce_settings                 = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 256, resource_groups = 2, version = 2 }
      transmit                      = { queue_count = 3, ring_size = 1024 }
    }
    Win-HPN = {
      description                   = "Recommended adapter settings for Windows high performance and networking."
      enable_virtual_extensible_lan = true
      interrupt_settings            = { interrupts = 512 }
    }
    Win-HPN-SMBd = {
      description                   = "Recommended adapter settings for Windows high performance and networking with RoCE V2."
      enable_virtual_extensible_lan = true
      interrupt_settings            = { interrupts = 512 }
      roce_settings                 = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 256, resource_groups = 2, version = 2 }
    }
    Win-HPN-v2 = {
      description        = "Recommended adapter settings for Windows high performance and networking v2."
      completion         = { queue_count = 9 }
      interrupt_settings = { interrupts = 16 }
      receive            = { queue_count = 8, ring_size = 4096 }
      roce_settings      = { class_of_service = 5, enable_rdma_over_converged_ethernet = true, memory_regions = 131072, queue_pairs = 1024, resource_groups = 8, version = 2 }
      transmit           = { queue_count = 1, ring_size = 4096 }
    }
    Windows = { description = "Recommended adapter settings for Windows." }
  }
  eth_adapter_l1 = flatten([for org in sort(keys(var.model)) : [for v in lookup(lookup(var.model[org], "policies", {}), "ethernet_adapter", []) : merge({ adapter_template = "EMPTY" }, v, {
    key          = v.name
    name         = "${local.npfx[org].ethernet_adapter}${v.name}${local.nsfx[org].ethernet_adapter}"
    organization = org
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ethernet_adapter", [])) > 0])
  ethernet_adapter = { for v in local.eth_adapter_l1 : "${v.organization}/${v.key}" => merge(local.eth_adapter, local.eth_adapter_templates[v.adapter_template], v, {
    completion = merge(local.eth_adapter.completion, lookup(local.eth_adapter_templates[v.adapter_template], "completion", {}), lookup(v, "completion", {}))
    interrupt_settings = merge(
      local.eth_adapter.interrupt_settings, lookup(local.eth_adapter_templates[v.adapter_template], "interrupt_settings", {}
    ), lookup(v, "interrupt_settings", {}))
    receive = merge(local.eth_adapter.receive, lookup(local.eth_adapter_templates[v.adapter_template], "receive", {}), lookup(v, "receive", {}))
    receive_side_scaling = merge(
      local.eth_adapter.receive_side_scaling, lookup(local.eth_adapter_templates[v.adapter_template], "receive_side_scaling", {}
    ), lookup(v, "receive_side_scaling", {}))
    roce_settings = merge(local.eth_adapter.roce_settings, lookup(local.eth_adapter_templates[v.adapter_template], "roce_settings", {}), lookup(v, "roce_settings", {}))
    tags          = lookup(v, "tags", var.global_settings.tags)
    tcp_offload   = merge(local.eth_adapter.tcp_offload, lookup(local.eth_adapter_templates[v.adapter_template], "tcp_offload", {}), lookup(v, "tcp_offload", {}))
    transmit      = merge(local.eth_adapter.transmit, lookup(local.eth_adapter_templates[v.adapter_template], "transmit", {}), lookup(v, "transmit", {}))
    })
  }


  #__________________________________________________________________
  #
  # Intersight Ethernet Network Policy
  # GUI Location: Policies > Create Policy > Ethernet Network
  #__________________________________________________________________
  ethernet_network = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ethernet_network", []) : merge(local.defaults.ethernet_network, v, {
      key          = v.name
      name         = "${local.npfx[org].ethernet_network}${v.name}${local.nsfx[org].ethernet_network}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ethernet_network", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Ethernet Network Control Policy
  # GUI Location: Policies > Create Policy > Ethernet Network Control
  #__________________________________________________________________
  ethernet_network_control = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ethernet_network_control", []) : merge(local.defaults.ethernet_network_control, v, {
      key          = v.name
      name         = "${local.npfx[org].ethernet_network_control}${v.name}${local.nsfx[org].ethernet_network_control}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ethernet_network_control", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Ethernet Network Group Policy
  # GUI Location: Policies > Create Policy > Ethernet Network Group
  #__________________________________________________________________
  ethernet_network_group = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ethernet_network_group", []) : merge(local.eng, v, {
      key          = v.name
      name         = "${local.npfx[org].ethernet_network_group}${v.name}${local.nsfx[org].ethernet_network_group}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ethernet_network_group", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Ethernet QoS Policy
  # GUI Location: Policies > Create Policy > Ethernet QoS
  #__________________________________________________________________
  ethernet_qos = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ethernet_qos", []) : merge(local.defaults.ethernet_qos, v, {
      key          = v.name
      name         = "${local.npfx[org].ethernet_qos}${v.name}${local.nsfx[org].ethernet_qos}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ethernet_qos", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight FC Zone Policy
  # GUI Location: Policies > Create Policy > FC Zone
  #__________________________________________________________________
  fc_zone = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "fc_zone", []) : merge(local.defaults.fc_zone, v, {
      key          = v.name
      name         = "${local.npfx[org].fc_zone}${v.name}${local.nsfx[org].fc_zone}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "fc_zone", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Fibre Channel Adapter Policy
  # GUI Location: Policies > Create Policy > Fibre Channel Adapter
  #__________________________________________________________________

  fca = local.defaults.fibre_channel_adapter
  fc_adapter_templates = {
    FCNVMeInitiator = {
      description    = "Recommended adapter settings for NVMe over FC Initiator."
      error_recovery = { port_down_timeout = 30000, port_down_io_retry = 30 }
    }
    FCNVMeTarget = {
      description    = "Recommended adapter settings for NVMe over FC Initiator."
      error_recovery = { port_down_timeout = 30000, port_down_io_retry = 30 }
    }
    EMPTY = {}
    Initiator = {
      description    = "Recommended adapter settings for SCSI Initiator."
      error_recovery = { port_down_timeout = 10000, port_down_io_retry = 30 }
    }
    Linux = {
      description    = "Recommended adapter settings for Linux."
      error_recovery = { port_down_timeout = 30000, port_down_io_retry = 30 }
    }
    Solaris = {
      description    = "Recommended adapter settings for Solaris."
      error_recovery = { port_down_timeout = 30000, port_down_io_retry = 30 }
      flogi          = { timeout = 20000 }
    }
    Target = {
      description    = "Recommended adapter settings for SCSI Target."
      error_recovery = { port_down_timeout = 30000, port_down_io_retry = 30 }
    }
    VMware = {
      description    = "Recommended adapter settings for VMware."
      error_recovery = { port_down_timeout = 10000, port_down_io_retry = 30 }
    }
    WindowsBoot = {
      description    = "Recommended adapter settings for Windows Boot.",
      error_recovery = { port_down_timeout = 5000, port_down_io_retry = 30 }
      plogi          = { timeout = 4000 }
    }
    Windows = {
      description    = "Recommended adapter settings for Windows."
      error_recovery = { port_down_timeout = 30000, port_down_io_retry = 30 }
    }
  }
  fc_adapter_l1 = flatten([for org in sort(keys(var.model)) : [for v in lookup(lookup(var.model[org], "policies", {}), "fibre_channel_adapter", []) : merge({ adapter_template = "EMPTY" }, v, {
    key          = v.name
    name         = "${local.npfx[org].fibre_channel_adapter}${v.name}${local.nsfx[org].fibre_channel_adapter}"
    organization = org
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "fibre_channel_adapter", [])) > 0])
  fibre_channel_adapter = { for v in local.fc_adapter_l1 : "${v.organization}/${v.key}" => merge(local.fca, local.fc_adapter_templates[v.adapter_template], v, {
    error_recovery = merge(local.fca.error_recovery, lookup(local.fc_adapter_templates[v.adapter_template], "error_recovery", {}), lookup(v, "error_recovery", {}))
    flogi          = merge(local.fca.flogi, lookup(local.fc_adapter_templates[v.adapter_template], "flogi", {}), lookup(v, "flogi", {}))
    interrupt      = merge(local.fca.interrupt, lookup(local.fc_adapter_templates[v.adapter_template], "interrupt", {}), lookup(v, "interrupt", {}))
    plogi          = merge(local.fca.plogi, lookup(local.fc_adapter_templates[v.adapter_template], "plogi", {}), lookup(v, "plogi", {}))
    receive        = merge(local.fca.receive, lookup(local.fc_adapter_templates[v.adapter_template], "receive", {}), lookup(v, "receive", {}))
    scsi_io        = merge(local.fca.scsi_io, lookup(local.fc_adapter_templates[v.adapter_template], "scsi_io", {}), lookup(v, "scsi_io", {}))
    tags           = lookup(v, "tags", var.global_settings.tags)
    transmit       = merge(local.fca.transmit, lookup(local.fc_adapter_templates[v.adapter_template], "transmit", {}), lookup(v, "transmit", {}))
    })
  }

  #__________________________________________________________________
  #
  # Intersight Fibre Channel Network Policy
  # GUI Location: Policies > Create Policy > Fibre Channel Network
  #__________________________________________________________________
  fibre_channel_network = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "fibre_channel_network", []) : merge(local.fcn, v, {
      key          = v.name
      name         = "${local.npfx[org].fibre_channel_network}${v.name}${local.nsfx[org].fibre_channel_network}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "fibre_channel_network", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Fibre Channel QoS Policy
  # GUI Location: Policies > Create Policy > Fibre Channel QoS
  #__________________________________________________________________
  fibre_channel_qos = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "fibre_channel_qos", []) : merge(local.defaults.fibre_channel_qos, v, {
      key          = v.name
      name         = "${local.npfx[org].fibre_channel_qos}${v.name}${local.nsfx[org].fibre_channel_qos}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "fibre_channel_qos", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Firmware Policy
  # GUI Location: Policies > Create Policy > Firmware
  #__________________________________________________________________
  firmware = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "firmware", []) : merge(local.fw, v, {
      advanced_mode = merge(local.fw.advanced_mode, lookup(v, "advanced_mode", {}))
      key           = v.name
      model_bundle_versions = { for i in flatten([
        for e in lookup(v, "model_bundle_version", []) : [
          for m in e.server_models : {
            model   = m
            version = e.firmware_version
          }
        ]
      ]) : "${i.version}/${i.model}" => i }
      name         = "${local.npfx[org].firmware}${v.name}${local.nsfx[org].firmware}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "firmware", [])) > 0]) : "${i.organization}/${i.key}" => i }
  firmware_authenticate = flatten([for org in sort(keys(var.model)) : [lookup(lookup(var.model[org], "policies", {}), "firmware_authenticate", [])
  ] if length(lookup(lookup(var.model[org], "policies", {}), "firmware_authenticate", [])) > 0])

  #__________________________________________________________________
  #
  # Intersight Flow Control Policy
  # GUI Location: Policies > Create Policy > Flow Control
  #__________________________________________________________________
  flow_control = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "flow_control", []) : merge(local.defaults.flow_control, v, {
      key          = v.name
      name         = "${local.npfx[org].flow_control}${v.name}${local.nsfx[org].flow_control}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "flow_control", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight IMC Access Policy
  # GUI Location: Policies > Create Policy > IMC Access
  #__________________________________________________________________
  imc_access = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "imc_access", []) : merge(local.defaults.imc_access, v, {
      inband_ip_pool = {
        name = length(regexall("/", lookup(v, "inband_ip_pool", "UNUSED"))) > 0 ? element(split("/", v.inband_ip_pool), 1) : lookup(v, "inband_ip_pool", "UNUSED")
        org  = length(regexall("/", lookup(v, "inband_ip_pool", "UNUSED"))) > 0 ? element(split("/", v.inband_ip_pool), 0) : org
      }
      key          = v.name
      name         = "${local.npfx[org].imc_access}${v.name}${local.nsfx[org].imc_access}"
      organization = org
      out_of_band_ip_pool = {
        name = length(regexall("/", lookup(v, "out_of_band_ip_pool", "UNUSED"))) > 0 ? element(split("/", v.out_of_band_ip_pool), 1) : lookup(v, "out_of_band_ip_pool", "UNUSED")
        org  = length(regexall("/", lookup(v, "out_of_band_ip_pool", "UNUSED"))) > 0 ? element(split("/", v.out_of_band_ip_pool), 0) : org
      }
      tags = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "imc_access", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight IPMI over LAN Policy
  # GUI Location: Policies > Create Policy > IPMI over LAN
  #__________________________________________________________________
  ipmi_over_lan = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ipmi_over_lan", []) : merge(local.defaults.ipmi_over_lan, v, {
      key          = v.name
      name         = "${local.npfx[org].ipmi_over_lan}${v.name}${local.nsfx[org].ipmi_over_lan}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ipmi_over_lan", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight iSCSI Adapter Policy
  # GUI Location: Policies > Create Policy > iSCSI Adapter
  #__________________________________________________________________
  iscsi_adapter = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "iscsi_adapter", []) : merge(local.defaults.iscsi_adapter, v, {
      key          = v.name
      name         = "${local.npfx[org].iscsi_adapter}${v.name}${local.nsfx[org].iscsi_adapter}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "iscsi_adapter", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight iSCSI Boot Policy
  # GUI Location: Policies > Create Policy > iSCSI Boot
  #__________________________________________________________________
  iboot             = local.defaults.iscsi_boot
  lookup_iscsi_boot = ["initiator_ip_pool", "iscsi_adapter_policy", "primary_target_policy", "secondary_target_policy"]
  iscsi_boot = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "iscsi_boot", []) : merge(local.iboot, v, {
      initiator_static_ipv4_config = merge(
      local.iboot.initiator_static_ipv4_config, lookup(v, "initiator_static_ipv4_config", {}))
      key          = v.name
      name         = "${local.npfx[org].iscsi_boot}${v.name}${local.nsfx[org].iscsi_boot}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
      }, { for e in local.lookup_iscsi_boot : e => { name = lookup(v, e, "UNUSED"), org = org }
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "iscsi_boot", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight iSCSI Static Target Policy
  # GUI Location: Policies > Create Policy > iSCSI Static Target
  #__________________________________________________________________
  iscsi_static_target = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "iscsi_static_target", []) : merge(local.defaults.iscsi_static_target, v, {
      key          = v.name
      name         = "${local.npfx[org].iscsi_static_target}${v.name}${local.nsfx[org].iscsi_static_target}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "iscsi_static_target", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight LAN Connectivity
  # GUI Location: Configure > Policies > Create Policy > LAN Connectivity
  #_________________________________________________________________________
  lcp = local.defaults.lan_connectivity
  lan_connectivity = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "lan_connectivity", []) : merge(local.lcp, v, {
      iqn_pool = {
        name = length(regexall("/", lookup(v, "iqn_pool", "UNUSED"))) > 0 ? element(split("/", lookup(v, "iqn_pool", "UNUSED")), 1) : lookup(v, "iqn_pool", "UNUSED")
        org  = length(regexall("/", lookup(v, "iqn_pool", "UNUSED"))) > 0 ? element(split("/", lookup(v, "iqn_pool", "UNUSED")), 0) : org
      }
      iqn_static_identifier = lookup(v, "iqn_static_identifier", "")
      key                   = v.name
      name                  = "${local.npfx[org].lan_connectivity}${v.name}${local.nsfx[org].lan_connectivity}"
      organization          = org
      tags                  = lookup(v, "tags", var.global_settings.tags)
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
  ] if length(lookup(lookup(var.model[org], "policies", {}), "lan_connectivity", [])) > 0]) : "${i.organization}/${i.key}" => i }
  vnics = { for i in flatten([
    for key, value in local.lan_connectivity : [
      for v in value.vnics : [
        for s in range(length(v.names)) : merge(v, {
          cdn_value = length(v.cdn_values) > 0 ? element(v.cdn_values, s) : ""
          enable_failover = length(compact([v.enable_failover])
          ) > 0 ? v.enable_failover : length(v.names) == 1 ? true : false
          ethernet_adapter_policy = {
            name = length(regexall("/", v.ethernet_adapter_policy)) > 0 ? element(split("/", v.ethernet_adapter_policy), 1) : v.ethernet_adapter_policy
            org  = length(regexall("/", v.ethernet_adapter_policy)) > 0 ? element(split("/", v.ethernet_adapter_policy), 0) : value.organization
          }
          ethernet_network_control_policy = {
            name = length(regexall("/", v.ethernet_network_control_policy)) > 0 ? element(split("/", v.ethernet_network_control_policy), 1) : v.ethernet_network_control_policy
            org  = length(regexall("/", v.ethernet_network_control_policy)) > 0 ? element(split("/", v.ethernet_network_control_policy), 0) : value.organization
          }
          ethernet_network_group_policy = length(v.ethernet_network_group_policies) == 2 ? {
            name = length(regexall("/", element(v.ethernet_network_group_policies, s))
            ) > 0 ? element(split("/", element(v.ethernet_network_group_policies, s)), 1) : element(v.ethernet_network_group_policies, s)
            org = length(regexall("/", element(v.ethernet_network_group_policies, s))
            ) > 0 ? element(split("/", element(v.ethernet_network_group_policies, s)), 0) : value.organization
            } : length(v.ethernet_network_group_policies) == 1 ? {
            name = length(regexall("/", element(v.ethernet_network_group_policies, 0))
            ) > 0 ? element(split("/", element(v.ethernet_network_group_policies, 0)), 1) : element(v.ethernet_network_group_policies, 0)
            org = length(regexall("/", element(v.ethernet_network_group_policies, 0))
            ) > 0 ? element(split("/", element(v.ethernet_network_group_policies, 0)), 0) : value.organization
          } : { name = "UNUSED", org = value.organization }
          ethernet_network_policy = {
            name = length(regexall("/", v.ethernet_network_policy)) > 0 ? element(split("/", v.ethernet_network_policy), 1) : v.ethernet_network_policy
            org  = length(regexall("/", v.ethernet_network_policy)) > 0 ? element(split("/", v.ethernet_network_policy), 0) : value.organization
          }
          ethernet_qos_policy = {
            name = length(regexall("/", v.ethernet_qos_policy)) > 0 ? element(split("/", v.ethernet_qos_policy), 1) : v.ethernet_qos_policy
            org  = length(regexall("/", v.ethernet_qos_policy)) > 0 ? element(split("/", v.ethernet_qos_policy), 0) : value.organization
          }
          iscsi_boot_policy = length(v.iscsi_boot_policies) > 0 ? {
            name = length(regexall("/", element(v.iscsi_boot_policies, s))) > 0 ? element(split("/", element(v.iscsi_boot_policies, s)), 1) : element(v.iscsi_boot_policies, s)
            org  = length(regexall("/", element(v.iscsi_boot_policies, s))) > 0 ? element(split("/", element(v.iscsi_boot_policies, s)), 0) : value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          lan_connectivity            = key
          mac_address_allocation_type = v.mac_address_allocation_type
          mac_address_pool = length(v.mac_address_pools) == 2 ? {
            name = length(regexall("/", element(v.mac_address_pools, s))) > 0 ? element(split("/", element(v.mac_address_pools, s)), 1) : element(v.mac_address_pools, s)
            org  = length(regexall("/", element(v.mac_address_pools, s))) > 0 ? element(split("/", element(v.mac_address_pools, s)), 0) : value.organization
            } : length(v.mac_address_pools) == 1 ? {
            name = length(regexall("/", element(v.mac_address_pools, 0))) > 0 ? element(split("/", element(v.mac_address_pools, 0)), 1) : element(v.mac_address_pools, s)
            org  = length(regexall("/", element(v.mac_address_pools, 0))) > 0 ? element(split("/", element(v.mac_address_pools, 0)), 0) : value.organization
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
              name = length(regexall("/", e.usnic_adapter_policy)) > 0 ? element(split("/", e.usnic_adapter_policy), 1) : e.usnic_adapter_policy
              org  = length(regexall("/", e.usnic_adapter_policy)) > 0 ? element(split("/", e.usnic_adapter_policy), 0) : value.organization
            } : { name = "UNUSED", org = "UNUSED" }
          })][0]
          vmq_settings = [for e in [lookup(v, "vmq_settings", {})] : merge(e, {
            vmmq_adapter_policy = length(compact([lookup(e, "vmmq_adapter_policy", "")])) > 0 ? {
              name = length(regexall("/", e.vmmq_adapter_policy)) > 0 ? element(split("/", e.vmmq_adapter_policy), 1) : e.vmmq_adapter_policy
              org  = length(regexall("/", e.vmmq_adapter_policy)) > 0 ? element(split("/", e.vmmq_adapter_policy), 0) : value.organization
            } : { name = "UNUSED", org = "UNUSED" }
          })][0]
        })
      ]
    ]
  ]) : "${i.lan_connectivity}/${i.name}" => i }

  #__________________________________________________________________
  #
  # Intersight LDAP Policy
  # GUI Location: Policies > Create Policy > LDAP
  #__________________________________________________________________
  lldap = local.defaults.ldap
  ldap = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ldap", []) : merge(local.lldap, v, {
      base_settings = merge(local.lldap.base_settings, lookup(v, "base_settings", {}), {
        base_dn = length(compact([lookup(v.base_settings, "base_dn", "")])
        ) == 0 ? "DC=${join(",DC=", split(".", v.base_settings.domain))}" : v.base_settings.base_dn
        domain = v.base_settings.domain
      })
      binding_parameters = merge(local.lldap.binding_parameters, lookup(v, "binding_parameters", {}))
      key                = v.name
      ldap_from_dns      = merge(local.lldap.ldap_from_dns, lookup(v, "ldap_from_dns", {}))
      ldap_groups        = lookup(v, "ldap_groups", [])
      ldap_providers     = lookup(v, "ldap_providers", [])
      name               = "${local.npfx[org].ldap}${v.name}${local.nsfx[org].ldap}"
      organization       = org
      search_parameters  = merge(local.lldap.search_parameters, lookup(v, "search_parameters", {}))
      tags               = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ldap", [])) > 0]) : "${i.organization}/${i.key}" => i }
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
  ]) : "${i.ldap_policy}/${i.name}" => i }
  ldap_providers = { for i in flatten([
    for key, value in local.ldap : [
      for v in value.ldap_providers : {
        ldap_policy = key
        port        = lookup(v, "port", local.lldap.ldap_providers.port)
        server      = v.server
      }
    ]
  ]) : "${i.ldap_policy}/${i.server}" => i }
  roles = distinct(concat(
    [for v in local.ldap_groups : v.role],
    [for v in local.users : v.role],
  ))

  #__________________________________________________________________
  #
  # Intersight Link Aggregation Policy
  # GUI Location: Policies > Create Policy > Link Aggregation
  #__________________________________________________________________
  link_aggregation = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "link_aggregation", []) : merge(local.defaults.link_aggregation, v, {
      key          = v.name
      name         = "${local.npfx[org].link_aggregation}${v.name}${local.nsfx[org].link_aggregation}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "link_aggregation", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Link Control Policy
  # GUI Location: Policies > Create Policy > Link Control
  #__________________________________________________________________
  link_control = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "link_control", []) : merge(local.defaults.link_control, v, {
      key          = v.name
      name         = "${local.npfx[org].link_control}${v.name}${local.nsfx[org].link_control}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "link_control", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Local User Policy
  # GUI Location: Policies > Create Policy > Local User
  #__________________________________________________________________
  local_user = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "local_user", []) : merge(local.defaults.local_user, v, {
      key                 = v.name
      name                = "${local.npfx[org].local_user}${v.name}${local.nsfx[org].local_user}"
      organization        = org
      password_properties = merge(local.defaults.local_user.password_properties, lookup(v, "password_properties", {}))
      tags                = lookup(v, "tags", var.global_settings.tags)
      users               = lookup(v, "users", [])
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "local_user", [])) > 0]) : "${i.organization}/${i.key}" => i }
  users = { for i in flatten([for key, value in local.local_user : [
    for v in value.users : merge(local.defaults.local_user.users, v, {
      local_user   = key
      name         = v.username
      organization = value.organization
      tags         = value.tags
    })
  ]]) : "${i.local_user}/${i.name}" => i }

  #__________________________________________________________________
  #
  # Intersight Multicast Policy
  # GUI Location: Policies > Create Policy > Multicast
  #__________________________________________________________________
  multicast = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "multicast", []) : merge(local.defaults.multicast, v, {
      key          = v.name
      name         = "${local.npfx[org].multicast}${v.name}${local.nsfx[org].multicast}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "multicast", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Network Connectivity Policy
  # GUI Location: Policies > Create Policy > Network Connectivity
  #__________________________________________________________________
  network_connectivity = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "network_connectivity", []) : merge(local.defaults.network_connectivity, v, {
      key          = v.name
      name         = "${local.npfx[org].network_connectivity}${v.name}${local.nsfx[org].network_connectivity}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "network_connectivity", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight NTP Policy
  # GUI Location: Policies > Create Policy > NTP
  #__________________________________________________________________
  ntp = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ntp", []) : merge(local.defaults.ntp, v, {
      key          = v.name
      name         = "${local.npfx[org].ntp}${v.name}${local.nsfx[org].ntp}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ntp", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Persistent Memory Policy
  # GUI Location: Policies > Create Policy > Persistent Memory
  #__________________________________________________________________
  persistent_memory = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "persistent_memory", []) : merge(local.defaults.persistent_memory, v, {
      key  = v.name
      name = "${local.npfx[org].persistent_memory}${v.name}${local.nsfx[org].persistent_memory}"
      namespaces = [for e in lookup(v, "namespaces", []) : merge(local.defaults.persistent_memory.namespaces, e)
      ]
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "persistent_memory", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Port Policy
  # GUI Location: Policies > Create Policy > Port
  #__________________________________________________________________
  lport = local.defaults.port
  port = { for s in flatten([for org in sort(keys(var.model)) : [
    for value in lookup(lookup(var.model[org], "policies", {}), "port", []) : [
      for i in range(length(value.names)) : merge(local.defaults.port, value, {
        key          = element(value.names, i)
        name         = "${local.npfx[org].port}${element(value.names, i)}${local.nsfx[org].port}"
        organization = org
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
        tags = lookup(value, "tags", var.global_settings.tags)
      })
    ]
    #]]) : "${s.organization}/${s.key}" => s }
  ] if length(lookup(lookup(var.model[org], "policies", {}), "port", [])) > 0]) : "${s.organization}/${s.key}" => s }
  port_channel_appliances = { for i in flatten([for key, value in local.port : [
    for v in value.port_channel_appliances : merge(v, {
      ethernet_network_control_policy = {
        name = length(regexall("/", lookup(v, "ethernet_network_control_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_control_policy", "UNUSED")), 1) : lookup(v, "ethernet_network_control_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "ethernet_network_control_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_control_policy", "UNUSED")), 0) : value.organization
      }
      ethernet_network_group_policy = {
        name = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 1) : lookup(v, "ethernet_network_group_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 0) : value.organization
      }
      link_aggregation_policy = {
        name = length(regexall("/", lookup(v, "link_aggregation_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "link_aggregation_policy", "UNUSED")), 1) : lookup(v, "link_aggregation_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "link_aggregation_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_aggregation_policy", "UNUSED")), 0) : value.organization
      }
      organization = value.organization,
      port_policy  = key
      tags         = value.tags
    })]
  ]) : "${i.port_policy}/${i.pc_id}" => i }
  port_channel_ethernet_uplinks = { for i in flatten([for key, value in local.port : [
    for v in value.port_channel_ethernet_uplinks : merge(v, {
      ethernet_network_group_policy = {
        name = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 1) : lookup(v, "ethernet_network_group_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 0) : value.organization
      }
      flow_control_policy = {
        name = length(regexall("/", lookup(v, "flow_control_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "flow_control_policy", "UNUSED")), 1) : lookup(v, "flow_control_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "flow_control_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "flow_control_policy", "UNUSED")), 0) : value.organization
      }
      link_aggregation_policy = {
        name = length(regexall("/", lookup(v, "link_aggregation_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "link_aggregation_policy", "UNUSED")), 1) : lookup(v, "link_aggregation_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "link_aggregation_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_aggregation_policy", "UNUSED")), 0) : value.organization
      }
      link_control_policy = {
        name = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 1) : lookup(v, "link_control_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 0) : value.organization
      }
      organization = value.organization
      port_policy  = key
      tags         = value.tags
    })]
  ]) : "${i.port_policy}/${i.pc_id}" => i }
  port_channel_fc_uplinks = { for i in flatten([
    for key, value in local.port : [
      for v in value.port_channel_fc_uplinks : merge(v, { port_policy = key, tags = value.tags })
    ]
  ]) : "${i.port_policy}/${i.pc_id}" => i }
  port_channel_fcoe_uplinks = { for i in flatten([for key, value in local.port : [
    for v in value.port_channel_fcoe_uplinks : merge(v, {
      link_aggregation_policy = {
        name = length(regexall("/", lookup(v, "link_aggregation_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "link_aggregation_policy", "UNUSED")), 0) : lookup(v, "link_aggregation_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "link_aggregation_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_aggregation_policy", "UNUSED")), 0) : value.organization
      }
      link_control_policy = {
        name = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 0) : lookup(v, "link_control_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 0) : value.organization
      }
      organization = value.organization
      port_policy  = key
      tags         = value.tags
    })]
  ]) : "${i.port_policy}/${i.pc_id}" => i }

  port_modes = { for i in flatten([for key, value in local.port : [for v in value.port_modes : merge(local.lport.port_modes, v, {
    port_policy = key
    tags        = value.tags
    })]
  ]) : "${i.port_policy}/${i.slot_id}-${element(i.port_list, 0)}" => i }

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
        name = length(regexall("/", lookup(v, "ethernet_network_control_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_control_policy", "UNUSED")), 1) : lookup(v, "ethernet_network_control_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "ethernet_network_control_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_control_policy", "UNUSED")), 0) : v.organization
      }
      ethernet_network_group_policy = {
        name = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 1) : lookup(v, "ethernet_network_group_policy", "UNUSED")
        org = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
        ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 0) : v.organization
      }
      port_id = s
    })]
  ]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
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
          name = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
          ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 1) : lookup(v, "ethernet_network_group_policy", "UNUSED")
          org = length(regexall("/", lookup(v, "ethernet_network_group_policy", "UNUSED"))
          ) > 0 ? element(split("/", lookup(v, "ethernet_network_group_policy", "UNUSED")), 0) : v.organization
        }
        flow_control_policy = {
          name = length(regexall("/", lookup(v, "flow_control_policy", "UNUSED"))
          ) > 0 ? element(split("/", lookup(v, "flow_control_policy", "UNUSED")), 1) : lookup(v, "flow_control_policy", "UNUSED")
          org = length(regexall("/", lookup(v, "flow_control_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "flow_control_policy", "UNUSED")), 0) : v.organization
        }
        link_control_policy = {
          name = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))
          ) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 1) : lookup(v, "link_control_policy", "UNUSED")
          org = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 0) : v.organization
        }
        port_id = s
      })
    ]
  ]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
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
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
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
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
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
      link_control_policy = {
        name = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 1) : lookup(v, "link_control_policy", "UNUSED")
        org  = length(regexall("/", lookup(v, "link_control_policy", "UNUSED"))) > 0 ? element(split("/", lookup(v, "link_control_policy", "UNUSED")), 0) : v.organization
      }
      port_id = s
  })]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
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
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }

  #__________________________________________________________________
  #
  # Intersight Power Policy
  # GUI Location: Policies > Create Policy > Power
  #__________________________________________________________________
  power = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "power", []) : merge(local.defaults.power, v, {
      key          = v.name
      name         = "${local.npfx[org].power}${v.name}${local.nsfx[org].power}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "power", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight SAN Connectivity
  # GUI Location: Configure > Policies > Create Policy > SAN Connectivity
  #_________________________________________________________________________
  scp = local.defaults.san_connectivity
  san_connectivity = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "san_connectivity", []) : merge(local.scp, v, {
      key          = v.name
      name         = "${local.npfx[org].san_connectivity}${v.name}${local.nsfx[org].san_connectivity}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
      wwnn_pool = {
        name = length(regexall("/", lookup(v, "wwnn_pool", "UNUSED"))) > 0 ? element(split("/", lookup(v, "wwnn_pool", "UNUSED")), 1) : lookup(v, "wwnn_pool", "UNUSED")
        org  = length(regexall("/", lookup(v, "wwnn_pool", "UNUSED"))) > 0 ? element(split("/", lookup(v, "wwnn_pool", "UNUSED")), 0) : org
      }
      vhbas = [
        for e in lookup(v, "vhbas", []) : merge(local.scp.vhbas, e, {
          names     = e.names
          placement = merge(local.scp.vhbas.placement, lookup(e, "placement", {}))
        })
      ]
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "san_connectivity", [])) > 0]) : "${i.organization}/${i.key}" => i }
  vhbas = { for i in flatten([
    for key, value in local.san_connectivity : [
      for v in value.vhbas : [
        for s in range(length(v.names)) : merge(v, {
          fc_zone_policies = length(v.fc_zone_policies) > 0 ? element(chunklist(v.fc_zone_policies, 2), s) : []
          fibre_channel_adapter_policy = {
            name = length(regexall("/", v.fibre_channel_adapter_policy)) > 0 ? element(split("/", v.fibre_channel_adapter_policy), 1) : v.fibre_channel_adapter_policy
            org  = length(regexall("/", v.fibre_channel_adapter_policy)) > 0 ? element(split("/", v.fibre_channel_adapter_policy), 0) : value.organization
          }
          fibre_channel_network_policy = length(v.fibre_channel_network_policies) == 2 ? {
            name = length(regexall("/", element(v.fibre_channel_network_policies, s))
            ) > 0 ? element(split("/", element(v.fibre_channel_network_policies, s)), 1) : element(v.fibre_channel_network_policies, s)
            org = length(regexall("/", element(v.fibre_channel_network_policies, s))
            ) > 0 ? element(split("/", element(v.fibre_channel_network_policies, s)), 0) : value.organization
            } : length(v.fibre_channel_network_policies) == 1 ? {
            name = length(regexall("/", element(v.fibre_channel_network_policies, 0))
            ) > 0 ? element(split("/", element(v.fibre_channel_network_policies, 0)), 1) : element(v.fibre_channel_network_policies, 0)
            org = length(regexall("/", element(v.fibre_channel_network_policies, 0))
            ) > 0 ? element(split("/", element(v.fibre_channel_network_policies, 0)), 0) : value.organization
          } : { name = "UNUSED", org = value.organization }
          fibre_channel_qos_policy = {
            name = length(regexall("/", v.fibre_channel_qos_policy)) > 0 ? element(split("/", v.fibre_channel_qos_policy), 1) : v.fibre_channel_qos_policy
            org  = length(regexall("/", v.fibre_channel_qos_policy)) > 0 ? element(split("/", v.fibre_channel_qos_policy), 0) : value.organization
          }
          name         = element(v.names, s)
          organization = value.organization
          placement = [for e in [v.placement] : {
            pci_link    = length(e.pci_links) == 1 ? element(e.pci_links, 0) : element(e.pci_links, s)
            pci_order   = length(e.pci_order) == 1 ? element(e.pci_order, 0) : element(e.pci_order, s)
            slot_id     = length(e.slot_ids) == 1 ? element(e.slot_ids, 0) : element(e.slot_ids, s)
            switch_id   = length(e.switch_ids) == 1 ? element(e.switch_ids, 0) : element(e.switch_ids, s)
            uplink_port = length(e.uplink_ports) == 1 ? element(e.uplink_ports, 0) : element(e.uplink_ports, s)
          }][0]
          san_connectivity = key
          wwpn_pool = length(v.wwpn_pools) == 2 ? {
            name = length(regexall("/", element(v.wwpn_pools, s))) > 0 ? element(split("/", element(v.wwpn_pools, s)), 1) : element(v.wwpn_pools, s)
            org  = length(regexall("/", element(v.wwpn_pools, s))) > 0 ? element(split("/", element(v.wwpn_pools, s)), 0) : value.organization
            } : length(v.wwpn_pools) == 1 ? {
            name = length(regexall("/", element(v.wwpn_pools, 0))) > 0 ? element(split("/", element(v.wwpn_pools, 0)), 1) : element(v.wwpn_pools, s)
            org  = length(regexall("/", element(v.wwpn_pools, 0))) > 0 ? element(split("/", element(v.wwpn_pools, 0)), 0) : value.organization
          } : { name = "UNUSED", org = "UNUSED" }
          wwpn_static_address = length(v.wwpn_static_addresses) > 0 ? element(v.wwpn_static_addresses, s) : ""
        })
      ]
    ]
  ]) : "${i.san_connectivity}/${i.name}" => i }

  #__________________________________________________________________
  #
  # Intersight SD Card Policy
  # GUI Location: Policies > Create Policy > SD Card
  #__________________________________________________________________
  sd_card = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "sd_card", []) : merge(local.defaults.sd_card, v, {
      key          = v.name
      name         = "${local.npfx[org].sd_card}${v.name}${local.nsfx[org].sd_card}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "sd_card", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Serial over LAN Policy
  # GUI Location: Policies > Create Policy > Serial over LAN
  #__________________________________________________________________
  serial_over_lan = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "serial_over_lan", []) : merge(local.defaults.serial_over_lan, v, {
      key          = v.name
      name         = "${local.npfx[org].serial_over_lan}${v.name}${local.nsfx[org].serial_over_lan}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "serial_over_lan", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight SMTP Policy
  # GUI Location: Policies > Create Policy > SMTP
  #__________________________________________________________________
  smtp = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "smtp", []) : merge(local.defaults.smtp, v, {
      key          = v.name
      name         = "${local.npfx[org].smtp}${v.name}${local.nsfx[org].smtp}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "smtp", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight SNNMP Policy
  # GUI Location: Configure > Policies > Create Policy > SNMP
  #_________________________________________________________________________
  lsnmp = local.defaults.snmp
  snmp = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "snmp", []) : merge(local.lsnmp, v, {
      key          = v.name
      name         = "${local.npfx[org].snmp}${v.name}${local.nsfx[org].snmp}"
      organization = org
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
      tags = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "snmp", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight SSH Policy
  # GUI Location: Policies > Create Policy > SSH
  #__________________________________________________________________
  ssh = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "ssh", []) : merge(local.defaults.ssh, v, {
      key          = v.name
      name         = "${local.npfx[org].ssh}${v.name}${local.nsfx[org].ssh}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "ssh", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight Storage Policy
  # GUI Location: Configure > Policies > Create Policy > Storage
  #_________________________________________________________________________
  dga = local.defaults.storage.drive_groups.automatic_drive_group
  dgm = local.defaults.storage.drive_groups.manual_drive_group
  dgv = local.defaults.storage.drive_groups.virtual_drives
  sdr = local.defaults.storage.single_drive_raid0_configuration
  storage = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "storage", []) : merge(local.defaults.storage, v, {
      drive_groups = lookup(v, "drive_groups", [])
      m2_raid_configuration = length(lookup(v, "m2_raid_configuration", {})
      ) > 0 ? [lookup(v, "m2_raid_configuration", {})] : []
      key          = v.name
      name         = "${local.npfx[org].storage}${v.name}${local.nsfx[org].storage}"
      organization = org
      single_drive_raid0_configuration = [
        for e in lookup(v, "single_drive_raid0_configuration", {}) : merge(local.sdr, e)
      ]
      tags = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "storage", [])) > 0]) : "${i.organization}/${i.key}" => i }
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
    ]) : "${i.storage_policy}/${i.name}" => i
  }

  #__________________________________________________________________
  #
  # Intersight Switch Control Policy
  # GUI Location: Policies > Create Policy > Switch Control
  #__________________________________________________________________
  switch_control = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "switch_control", []) : merge(local.defaults.switch_control, v, {
      key          = v.name
      name         = "${local.npfx[org].switch_control}${v.name}${local.nsfx[org].switch_control}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "switch_control", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Syslog Policy
  # GUI Location: Policies > Create Policy > Syslog
  #__________________________________________________________________
  syslog = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "syslog", []) : merge(local.defaults.syslog, v, {
      key            = v.name
      name           = "${local.npfx[org].syslog}${v.name}${local.nsfx[org].syslog}"
      organization   = org
      remote_logging = lookup(v, "remote_logging", [])
      tags           = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "syslog", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight System QoS Policy
  # GUI Location: Configure > Policies > Create Policy > System QoS
  #_________________________________________________________________________
  qos = local.defaults.system_qos
  system_qos_loop_1 = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "system_qos", []) : merge(local.qos, v, {
      classes = length(regexall(true, lookup(v, "configure_default_classes", local.qos.configure_default_classes))
        ) > 0 ? { for v in local.qos.classes_default : v.priority => v } : length(
        regexall(true, lookup(v, "configure_recommended_classes", local.qos.configure_recommended_classes))
        ) > 0 ? { for v in local.qos.classes_recommended : v.priority => v } : length(lookup(v, "classes", [])
      ) == 0 ? local.qos.classes : { for v in v.classes : v.priority => v }
      key          = v.name
      name         = "${local.npfx[org].system_qos}${v.name}${local.nsfx[org].system_qos}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "system_qos", [])) > 0]) : "${i.organization}/${i.key}" => i }
  system_qos = {
    for k, v in local.system_qos_loop_1 : k => merge(v,
      { bandwidth_total = sum([for e in v.classes : e.weight if e.state == "Enabled"]) }
    )
  }

  #__________________________________________________________________
  #
  # Intersight Thermal Policy
  # GUI Location: Policies > Create Policy > Thermal
  #__________________________________________________________________
  thermal = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "thermal", []) : merge(local.defaults.thermal, v, {
      key          = v.name
      name         = "${local.npfx[org].thermal}${v.name}${local.nsfx[org].thermal}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "thermal", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Virtual KVM Policy
  # GUI Location: Policies > Create Policy > Virtual KVM
  #__________________________________________________________________
  virtual_kvm = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "virtual_kvm", []) : merge(local.defaults.virtual_kvm, v, {
      key          = v.name
      name         = "${local.npfx[org].virtual_kvm}${v.name}${local.nsfx[org].virtual_kvm}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "virtual_kvm", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #__________________________________________________________________
  #
  # Intersight Virtual Media Policy
  # GUI Location: Policies > Create Policy > Virtual Media
  #__________________________________________________________________
  virtual_media = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "virtual_media", []) : merge(local.vmedia, v, {
      add_virtual_media = [for e in lookup(v, "add_virtual_media", {}) : merge(local.vmedia.add_virtual_media, e)]
      key               = v.name
      name              = "${local.npfx[org].virtual_media}${v.name}${local.nsfx[org].virtual_media}"
      organization      = org
      tags              = lookup(v, "tags", var.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "virtual_media", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight VLAN Policy
  # GUI Location: Configure > Policies > Create Policy > VLAN
  #_________________________________________________________________________
  vlan = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "vlan", []) : merge(local.defaults.vlan, v, {
      key          = v.name
      name         = "${local.npfx[org].vlan}${v.name}${local.nsfx[org].vlan}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
      vlans = [
        for e in lookup(v, "vlans", []) : merge(local.defaults.vlan.vlans, e, {
          multicast_policy = e.multicast_policy
          vlan_list        = e.vlan_list
        })
      ]
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "vlan", [])) > 0]) : "${i.organization}/${i.key}" => i }
  vlans_loop = flatten([
    for key, value in local.vlan : [
      for v in value.vlans : {
        auto_allow_on_uplinks = v.auto_allow_on_uplinks
        multicast_policy      = v.multicast_policy
        name                  = v.name
        name_prefix           = length(regexall("(,|-)", jsonencode(v.vlan_list))) > 0 && v.name_prefix == true ? true : false
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
      multicast_policy = {
        name = length(regexall("/", v.multicast_policy)) > 0 ? element(split("/", v.multicast_policy), 1) : v.multicast_policy,
        org  = length(regexall("/", v.multicast_policy)) > 0 ? element(split("/", v.multicast_policy), 0) : v.organization
      }
      name            = v.name
      name_prefix     = v.name_prefix
      native_vlan     = v.native_vlan
      organization    = v.organization
      primary_vlan_id = v.primary_vlan_id
      sharing_type    = v.sharing_type
      vlan_id         = s
      vlan_policy     = v.vlan_policy
    }
  ]]) : "${i.vlan_policy}/${i.vlan_id}" => i }
  #_________________________________________________________________________
  #
  # Intersight VSAN Policy
  # GUI Location: Configure > Policies > Create Policy > VSAN
  #_________________________________________________________________________
  vsan = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "vsan", []) : merge(local.defaults.vsan, v, {
      key          = v.name
      name         = "${local.npfx[org].vsan}${v.name}${local.nsfx[org].vsan}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
      vsans        = lookup(v, "vsans", [])
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "vsan", [])) > 0]) : "${i.organization}/${i.key}" => i }
  vsans = { for i in flatten([for key, value in local.vsan : [
    for v in value.vsans : merge(local.defaults.vsan.vsans, v, {
      fcoe_vlan_id = lookup(v, "fcoe_vlan_id", v.vsan_id)
      organization = value.organization
      vsan_policy  = key
    })
  ]]) : "${i.vsan_policy}/${i.vsan_id}" => i }
}
