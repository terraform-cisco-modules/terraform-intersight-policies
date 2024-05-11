locals {
  defaults         = yamldecode(file("${path.module}/defaults.yaml")).policies
  network_policies = ["ethernet_network_control", "ethernet_network_group", "flow_control", "link_aggregation", "link_control"]
  policy_names = [
    "adapter_configuration", "bios", "boot_order", "certificate_management", "device_connector", "ethernet_adapter",
    "ethernet_network", "ethernet_network_control", "ethernet_network_group", "ethernet_qos", "fc_zone",
    "fibre_channel_adapter", "fibre_channel_network", "fibre_channel_qos", "firmware", "flow_control", "imc_access",
    "ipmi_over_lan", "iscsi_adapter", "iscsi_boot", "iscsi_static_target", "lan_connectivity", "ldap", "link_aggregation",
    "link_control", "local_user", "multicast", "network_connectivity", "ntp", "persistent_memory", "port",
    "power", "san_connectivity", "sd_card", "serial_over_lan", "smtp", "snmp", "ssh", "storage",
    "switch_control", "syslog", "system_qos", "thermal", "vhba_template", "virtual_kvm", "virtual_media", "vlan", "vnic_template", "vsan"
  ]
  pp = merge({ for i in local.network_policies : i => distinct(compact(concat(
    flatten([for v in local.port_channel_appliances : v["${i}_policy"] if element(split("/", v["${i}_policy"]), 1) != "UNUSED"]),
    flatten([for v in local.port_channel_ethernet_uplinks : v["${i}_policy"] if element(split("/", v["${i}_policy"]), 1) != "UNUSED"]),
    flatten([for v in local.port_channel_fcoe_uplinks : v["${i}_policy"] if element(split("/", v["${i}_policy"]), 1) != "UNUSED"]),
    flatten([for v in local.port_role_appliances : v["${i}_policy"] if element(split("/", v["${i}_policy"]), 1) != "UNUSED"]),
    flatten([for v in local.port_role_ethernet_uplinks : v["${i}_policy"] if element(split("/", v["${i}_policy"]), 1) != "UNUSED"]),
    flatten([for v in local.port_role_fcoe_uplinks : v["${i}_policy"] if element(split("/", v["${i}_policy"]), 1) != "UNUSED"]),
    flatten([for v in local.vnics : v["${i}_policy"] if element(split("/", lookup(v, "${i}_policy", "default/UNUSED")), 1) != "UNUSED"]),
    flatten([for v in local.vnic_template : v["${i}_policy"] if element(split("/", lookup(v, "${i}_policy", "default/UNUSED")), 1) != "UNUSED"])
    )))
    }, {
    ethernet_adapter = distinct(compact(concat(
      flatten([for v in local.vnics : v.ethernet_adapter_policy if element(split("/", v.ethernet_adapter_policy), 1) != "UNUSED"]),
      flatten([for v in local.vnics : [for e in [v.usnic] : e.usnic_adapter_policy if element(split("/", e.usnic_adapter_policy), 1) != "UNUSED"]]),
      flatten([for v in local.vnics : [for e in [v.vmq] : e.vmmq_adapter_policy if element(split("/", e.vmmq_adapter_policy), 1) != "UNUSED"]]),
      flatten([for v in local.vnic_template : v.ethernet_adapter_policy if element(split("/", v.ethernet_adapter_policy), 1) != "UNUSED"]),
      flatten([for v in local.vnic_template : [for e in [v.usnic] : e.usnic_adapter_policy if element(split("/", e.usnic_adapter_policy), 1) != "UNUSED"]]),
      flatten([for v in local.vnic_template : [for e in [v.vmq] : e.vmmq_adapter_policy if element(split("/", e.vmmq_adapter_policy), 1) != "UNUSED"]])
    )))
    ethernet_network = distinct(compact(flatten([for v in local.vnics : v.ethernet_network_policy if element(split("/", v.ethernet_network_policy), 1) != "UNUSED"])))
    ethernet_qos = distinct(compact(concat(
      flatten([for v in local.vnics : v.ethernet_qos_policy if element(split("/", v.ethernet_qos_policy), 1) != "UNUSED"]),
      flatten([for v in local.vnic_template : v.ethernet_qos_policy if element(split("/", v.ethernet_qos_policy), 1) != "UNUSED"])
    )))
    fc_zone = distinct(compact(concat(
      flatten([for v in local.vhbas : [for e in v.fc_zone_policies : e if element(split("/", e), 1) != "UNUSED"]]),
      flatten([for v in local.vhba_template : [for e in v.fc_zone_policies : e if element(split("/", e), 1) != "UNUSED"]])
    )))
    fibre_channel_adapter = distinct(compact(concat(
      flatten([for v in local.vhbas : v.fibre_channel_adapter_policy if element(split("/", v.fibre_channel_adapter_policy), 1) != "UNUSED"]),
      flatten([for v in local.vhba_template : v.fibre_channel_adapter_policy if element(split("/", v.fibre_channel_adapter_policy), 1) != "UNUSED"])
    )))
    fibre_channel_network = distinct(compact(concat(
      flatten([for v in local.vhbas : [for e in [v.fibre_channel_network_policy] : e if element(split("/", e), 1) != "UNUSED"]]),
      flatten([for v in local.vhba_template : v.fibre_channel_network_policy if element(split("/", v.fibre_channel_network_policy), 1) != "UNUSED"])
    )))
    fibre_channel_qos = distinct(compact(concat(
      flatten([for v in local.vhbas : v.fibre_channel_qos_policy if element(split("/", v.fibre_channel_qos_policy), 1) != "UNUSED"]),
      flatten([for v in local.vhba_template : v.fibre_channel_qos_policy if element(split("/", v.fibre_channel_qos_policy), 1) != "UNUSED"])
    )))
    ip = distinct(compact(concat(
      flatten([for v in local.imc_access : v.inband_ip_pool if element(split("/", v.inband_ip_pool), 1) != "UNUSED"]),
      flatten([for v in local.imc_access : v.out_of_band_ip_pool if element(split("/", v.out_of_band_ip_pool), 1) != "UNUSED"]),
      flatten([for v in local.iscsi_boot : v.initiator_ip_pool if element(split("/", v.initiator_ip_pool), 1) != "UNUSED"])
    )))
    iqn           = distinct(compact(flatten([for v in local.lan_connectivity : v.iqn_pool if element(split("/", v.iqn_pool), 1) != "UNUSED"])))
    iscsi_adapter = distinct(compact(flatten([for v in local.iscsi_boot : v.iscsi_adapter_policy if element(split("/", v.iscsi_adapter_policy), 1) != "UNUSED"])))
    iscsi_boot = distinct(compact(concat(
      flatten([for v in local.vnics : v.iscsi_boot_policy if element(split("/", v.iscsi_boot_policy), 1) != "UNUSED"]),
      flatten([for v in local.vnic_template : v.iscsi_boot_policy if element(split("/", v.iscsi_boot_policy), 1) != "UNUSED"])
    )))
    iscsi_static_target = distinct(compact(flatten([[for i in ["primary", "secondary"] : [
      for k, v in local.iscsi_boot : v["${i}_target_policy"] if element(split("/", v["${i}_target_policy"]), 1) != "UNUSED"
    ]]])))
    mac = distinct(compact(concat(
      flatten([for v in local.vnics : v.mac_address_pool if element(split("/", v.mac_address_pool), 1) != "UNUSED"]),
      flatten([for v in local.vnic_template : v.mac_address_pool if element(split("/", v.mac_address_pool), 1) != "UNUSED"])
    )))
    multicast     = distinct(compact(flatten([for v in local.vlans : v.multicast_policy if element(split("/", v.multicast_policy), 1) != "UNUSED"])))
    vhba_template = distinct(compact(flatten([for v in local.vhbas_from_template : v.vhba_template if element(split("/", v.vhba_template), 1) != "UNUSED"])))
    vnic_template = distinct(compact(flatten([for v in local.vnics_from_template : v.vnic_template if element(split("/", v.vnic_template), 1) != "UNUSED"])))
    wwnn          = distinct(compact(flatten([for v in local.san_connectivity : v.wwnn_pool if element(split("/", v.wwnn_pool), 1) != "UNUSED"])))
    wwpn = distinct(compact(concat(
      flatten([for v in local.vhbas : v.wwpn_pool if element(split("/", v.wwpn_pool), 1) != "UNUSED"]),
      flatten([for v in local.vhba_template : v.wwpn_pool if element(split("/", v.wwpn_pool), 1) != "UNUSED"])
    )))
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
    vhba_template            = { keys = keys(local.vhba_template), object = "vnic.VhbaTemplate" }
    vnic_template            = { keys = keys(local.vnic_template), object = "vnic.VnicTemplate" }
  }
  policy_types = [
    "ethernet_adapter", "ethernet_network", "ethernet_network_control", "ethernet_network_group", "ethernet_qos",
    "fc_zone", "fibre_channel_adapter", "fibre_channel_network", "fibre_channel_qos", "flow_control", "iscsi_adapter",
    "iscsi_boot", "iscsi_static_target", "link_aggregation", "link_control", "multicast", "vhba_template", "vnic_template"
  ]
  pool_types    = ["ip", "iqn", "mac", "wwnn", "wwpn"]
  data_policies = { for e in local.policy_types : e => [for v in local.pp[e] : element(split("/", v), 1) if contains(local.policies[e].keys, v) == false] }
  data_pools    = { for e in local.pool_types : e => [for v in local.pp[e] : element(split("/", v), 1) if contains(keys(local.pools[e].moids), v) == false] }
  policies_data = { for k in keys(data.intersight_search_search_item.policies) : k => {
    for e in lookup(data.intersight_search_search_item.policies[k], "results", []
      ) : "${local.org_names[jsondecode(e.additional_properties).Organization.Moid]}/${jsondecode(e.additional_properties).Name}" => merge({
        additional_properties = jsondecode(e.additional_properties)
        moid                  = e.moid
    })
  } }
  pools_data = { for k in keys(data.intersight_search_search_item.pools) : k => {
    for e in lookup(data.intersight_search_search_item.pools[k], "results", []
      ) : "${local.org_names[jsondecode(e.additional_properties).Organization.Moid]}/${jsondecode(e.additional_properties).Name}" => merge({
        additional_properties = jsondecode(e.additional_properties)
        moid                  = e.moid
    })
  } }
  data_vhba_template = {
    for e in lookup(lookup(data.intersight_vnic_vhba_template.map, "0", {}), "results", []) : "${local.org_names[e.organization[0].moid]}/${e.name}" => e
  }
  data_vnic_template = {
    for e in lookup(lookup(data.intersight_vnic_vnic_template.map, "0", {}), "results", []) : "${local.org_names[e.organization[0].moid]}/${e.name}" => e
  }
  vnic_condition_check = merge({ for k, v in local.data_vnic_template : k => {
    proceed = v.sriov_settings[0].enabled == true ? false : v.usnic_settings[0].nr_count > 0 ? false : v.vmq_settings[0].enabled == true ? false : true
    } }, { for k, v in local.vnic_template : k => {
    proceed = v.sr_iov.enabled == true ? false : v.usnic.number_of_usnics > 0 ? false : v.vmq_settings.enabled == true ? false : true
  } })
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
  org_names = { for k, v in var.orgs : v => k }
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
    for v in lookup(lookup(var.model[org], "policies", {}), "adapter_configuration", []) : {
      add_vic_adapter_configuration = [for e in v.add_vic_adapter_configuration : merge(local.laddvic, e, {
        dce_interface_settings = [
          for x in range(4) : {
            additional_properties = "", class_id = "adapter.DceInterfaceSettings"
            fec_mode = length(lookup(lookup(e, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode)
              ) == 4 ? element(lookup(lookup(e, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode), x
            ) : element(lookup(lookup(e, "dce_interface_settings", {}), "dce_interface_fec_modes", local.fecmode), 0)
            interface_id = x, object_type = "adapter.DceInterfaceSettings"
          }
        ]
      })]
      description  = lookup(v, "description", "")
      key          = v.name
      name         = "${local.npfx[org].adapter_configuration}${v.name}${local.nsfx[org].adapter_configuration}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
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
    for v in lookup(lookup(var.model[org], "policies", {}), "boot_order", []) : merge(local.defaults.boot_order, v, {
      boot_devices = [
        for e in lookup(v, "boot_devices", []) : {
          additional_properties = v.boot_mode == "Uefi" && length(regexall("^(iscsi|san)_boot|local_disk|nvme|pch_storage|sd_card$", e.device_type)
            ) > 0 && length(lookup(e, "boot_loader", {})) > 0 ? jsonencode(merge(
              { Bootloader = merge(local.boot_loader, { for a, b in lookup(e, "boot_loader", {}) : local.boot_loader_keys[a] => b }) },
              merge(local.boot_arguments[v.device_type], { for a, b in v : local.boot_arg_convert[a] => b if contains(
            keys(local.boot_arguments[e.device_type]), local.boot_arg_convert[b]) }))
            ) : e.device_type == "http_boot" ? jsonencode(merge(
              { StaticIpV4Settings = merge(local.boot_static_ipv4, { for a, b in lookup(e, "ipv4_config", {}) : local.boot_arg_convert[a] => b }) },
              { StaticIpV6Settings = merge(local.boot_static_ipv6, { for a, b in lookup(e, "ipv6_config", {}) : local.boot_arg_convert[a] => b }) },
              merge(local.boot_arguments[e.device_type], { for a, b in e : local.boot_arg_convert[a] => b if contains(
            keys(local.boot_arguments[e.device_type]), local.boot_arg_convert[a]) }))
            ) : jsonencode(merge(local.boot_arguments[e.device_type], {
              for a, b in e : local.boot_arg_convert[a] => b if contains(keys(local.boot_arguments[e.device_type]), local.boot_arg_convert[a])
          }))
          enabled     = lookup(v, "enabled", true)
          name        = e.device_name
          object_type = local.boot_object_types[e.device_type]
        }
      ]
      key          = v.name
      name         = "${local.npfx[org].boot_order}${v.name}${local.nsfx[org].boot_order}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
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
      inband_ip_pool      = length(regexall("/", lookup(v, "inband_ip_pool", "UNUSED"))) > 0 ? v.inband_ip_pool : "${org}/${lookup(v, "inband_ip_pool", "UNUSED")}"
      key                 = v.name
      name                = "${local.npfx[org].imc_access}${v.name}${local.nsfx[org].imc_access}"
      organization        = org
      out_of_band_ip_pool = length(regexall("/", lookup(v, "out_of_band_ip_pool", "UNUSED"))) > 0 ? v.inband_ip_pool : "${org}/${lookup(v, "out_of_band_ip_pool", "UNUSED")}"
      tags                = lookup(v, "tags", var.global_settings.tags)
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
      }, { for e in local.lookup_iscsi_boot : e => length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? v[e] : "${org}/${lookup(v, e, "UNUSED")}"
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
  lcp        = local.defaults.lan_connectivity
  lvsingle   = ["ethernet_adapter_policy", "ethernet_network_control_policy", "ethernet_network_policy", "ethernet_qos_policy"]
  lvdual     = ["ethernet_network_group_policies", "iscsi_boot_policies", "mac_address_pools"]
  lvtemplate = ["ethernet_adapter_policy", "iscsi_boot_policy", "mac_address_pool"]
  lan_connectivity = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "lan_connectivity", []) : merge(local.lcp, v, {
      iqn_pool              = length(regexall("/", lookup(v, "iqn_pool", "UNUSED"))) > 0 ? v.iqn_pool : "${org}/${lookup(v, "iqn_pool", "UNUSED")}"
      iqn_static_identifier = lookup(v, "iqn_static_identifier", "")
      key                   = v.name
      name                  = "${local.npfx[org].lan_connectivity}${v.name}${local.nsfx[org].lan_connectivity}"
      organization          = org
      tags                  = lookup(v, "tags", var.global_settings.tags)
      vnics = flatten([for e in lookup(v, "vnics", []) : merge(local.lcp.vnics, e, {
        enable_failover = length(regexall(true, lookup(e, "enable_failover", false))
        ) > 0 ? e.enable_failover : length(e.names) == 1 ? true : false
        lan_connectivity = "${org}/${v.name}"
        sr_iov           = merge(local.lcp.vnics.sr_iov, lookup(e, "sr_iov", {}))
        tags             = lookup(v, "tags", var.global_settings.tags)
        usnic = [for d in [merge(local.lcp.vnics.usnic, lookup(e, "usnic", {}))] : merge(d, {
          usnic_adapter_policy = length(regexall("/", lookup(d, "usnic_adapter_policy", "UNUSED"))
          ) > 0 ? d.usnic_adapter_policy : "${org}/${lookup(d, "usnic_adapter_policy", "UNUSED")}"
        })][0]
        vmq = [for d in [merge(local.lcp.vnics.vmq, lookup(e, "vmq", {}))] : merge(d, {
          vmmq_adapter_policy = length(regexall("/", lookup(d, "vmmq_adapter_policy", "UNUSED"))
          ) > 0 ? d.vmmq_adapter_policy : "${org}/${lookup(d, "vmmq_adapter_policy", "UNUSED")}"
        })][0]
        }, { for d in local.lvsingle : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}" }, {
        for d in local.lvdual : d => [for c in lookup(e, d, local.lcp.vnics[d]) : length(regexall("/", c)) > 0 ? c : "${org}/${c}"]
        })
      ])
      vnics_from_template = flatten([
        for e in lookup(v, "vnics_from_template", []) : merge(local.lcp.vnics_from_template, e, {
          lan_connectivity = "${org}/${v.name}"
          name             = e.name
          placement = [for d in [merge(local.lcp.vnics.placement, lookup(e, "placement", {}))] : {
            automatic_pci_link_assignment = d.pci_link != null ? false : true
            automatic_slot_id_assignment  = d.slot_id != "" ? false : true
            pci_link                      = d.pci_link != null ? d.pci_link : 0
          }][0]
          sr_iov = merge(local.lcp.vnics.sr_iov, lookup(e, "sr_iov", {}))
          tags   = lookup(v, "tags", var.global_settings.tags)
          usnic = [for d in [merge(local.lcp.vnics.usnic, lookup(e, "usnic", {}))] : merge(d, {
            usnic_adapter_policy = length(regexall("/", d.usnic_adapter_policy)) > 0 ? d.usnic_adapter_policy : "${org}/${d.usnic_adapter_policy}"
          })][0]
          vmq = [for d in [merge(local.lcp.vnics.vmq, lookup(e, "vmq", {}))] : merge(d, {
            vmmq_adapter_policy = length(regexall("/", d.vmmq_adapter_policy)) > 0 ? d.vmmq_adapter_policy : "${org}/${d.vmmq_adapter_policy}"
          })][0]
          vnic_template = length(regexall("/", e.vnic_template)) > 0 ? e.vnic_template : "${org}/${e.vnic_template}"
        }, { for d in local.lvtemplate : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}" })
      ])
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "lan_connectivity", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight LAN Connectivity - vNIC / vNIC from Template
  # GUI Location: Configure > Policies > Create Policy > LAN Connectivity
  #_________________________________________________________________________
  vnics = { for i in flatten([for k, v in local.lan_connectivity : [
    for e in v.vnics : [for x in range(length(e.names)) : merge(e, {
      cdn_value = length(e.cdn_values) == length(e.names) ? element(e.cdn_values, x) : ""
      ethernet_network_group_policy = length(e.ethernet_network_group_policies
      ) >= 2 ? element(e.ethernet_network_group_policies, x) : element(e.ethernet_network_group_policies, 0)
      iscsi_boot_policy    = length(e.iscsi_boot_policies) >= 2 ? element(e.iscsi_boot_policies, x) : element(e.iscsi_boot_policies, 0)
      mac_address_pool     = length(e.mac_address_pools) >= 2 ? element(e.mac_address_pools, x) : element(e.mac_address_pools, 0)
      mac_addresses_static = length(lookup(e, "mac_addresses_static", [])) == length(e.names) ? element(e.mac_addresses_static, x) : ""
      name                 = element(e.names, x)
      placement = [for d in [merge(local.lcp.vnics.placement, lookup(e, "placement", {}))] : {
        automatic_pci_link_assignment = length(d.pci_links) > 0 ? false : true
        automatic_slot_id_assignment  = length(d.slot_ids) > 0 ? false : true
        pci_link                      = length(d.pci_links) == 2 ? element(d.pci_links, x) : length(d.pci_links) == 1 ? element(d.pci_links, 0) : 0
        pci_order                     = length(d.pci_order) == 2 ? element(d.pci_order, x) : element(d.pci_order, 0)
        slot_id                       = length(d.slot_ids) == 2 ? element(d.slot_ids, x) : length(d.slot_ids) == 1 ? element(d.slot_ids, 0) : ""
        switch_id                     = length(d.switch_ids) == 2 ? element(d.switch_ids, x) : element(d.switch_ids, 0)
        uplink_port                   = length(d.uplink_ports) == 2 ? element(d.uplink_ports, x) : element(d.uplink_ports, 0)
      }][0]
    })]
  ]]) : "${i.lan_connectivity}/${i.name}" => i }
  vnics_from_template = { for i in flatten([
    for k, v in local.lan_connectivity : [for e in v.vnics_from_template : merge(e, {
      template_source = contains(keys(local.vnic_templates), e.vnic_template) ? "local" : "data"
    })]
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
  lport  = local.defaults.port
  pcethp = ["ethernet_network_control_policy", "ethernet_network_group_policy", "flow_control_policy", "link_aggregation_policy", "link_control_policy"]
  prethp = setsubtract(local.pcethp, ["link_aggregation_policy"])
  port = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "port", []) : [
      for x in range(length(v.names)) : merge(local.defaults.port, v, {
        key          = element(v.names, x)
        name         = "${local.npfx[org].port}${element(v.names, x)}${local.nsfx[org].port}"
        organization = org
        port_channel_appliances = [for e in lookup(v, "port_channel_appliances", []) : merge(local.lport.port_channel_appliances, e, {
          for d in local.pcethp : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}"
          }, {
          interfaces  = [for d in lookup(e, "interfaces", []) : merge(local.lport.pc_interfaces, d)]
          pc_id       = length(e.pc_ids) >= 2 ? element(e.pc_ids, x) : element(e.pc_ids, 0)
          port_policy = "${org}/${element(v.names, x)}"
        })]
        port_channel_ethernet_uplinks = [for e in lookup(v, "port_channel_ethernet_uplinks", []) : merge(local.lport.port_channel_ethernet_uplinks, e, {
          for d in local.pcethp : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}"
          }, {
          interfaces  = [for d in lookup(e, "interfaces", []) : merge(local.lport.pc_interfaces, d)]
          pc_id       = length(e.pc_ids) >= 2 ? element(e.pc_ids, x) : element(e.pc_ids, 0)
          port_policy = "${org}/${element(v.names, x)}"
        })]
        port_channel_fc_uplinks = [for e in lookup(v, "port_channel_fc_uplinks", []) : merge(local.lport.port_channel_fc_uplinks, e, {
          interfaces  = [for d in lookup(e, "interfaces", []) : merge(local.lport.pc_interfaces, d)]
          pc_id       = length(e.pc_ids) >= 2 ? element(e.pc_ids, x) : element(e.pc_ids, 0)
          port_policy = "${org}/${element(v.names, x)}"
          vsan_id     = length(e.vsan_ids) >= 2 ? element(e.vsan_ids, x) : element(e.vsan_ids, 0)
        })]
        port_channel_fcoe_uplinks = [for e in lookup(v, "port_channel_fcoe_uplinks", []) : merge(local.lport.port_channel_fcoe_uplinks, e, {
          for d in local.pcethp : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}"
          }, {
          port_policy = "${org}/${element(v.names, x)}"
          interfaces  = [for d in lookup(e, "interfaces", []) : merge(local.lport.pc_interfaces, d)]
          pc_id       = length(e.pc_ids) >= 2 ? element(e.pc_ids, x) : element(e.pc_ids, 0)
          tags        = lookup(v, "tags", var.global_settings.tags)
        })]
        port_modes = [for e in lookup(v, "port_modes", []) : merge(local.lport.port_modes, e, { port_list = e.port_list, port_policy = "${org}/${element(v.names, x)}" })]
        port_role_appliances = [for e in lookup(v, "port_role_appliances", []) : merge(local.lport.port_role_appliances, e, {
          for d in local.prethp : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}"
          }, {
          port_list = flatten([for d in compact(length(regexall("-", e.port_list)) > 0 ? tolist(split(",", e.port_list)
            ) : length(regexall(",", e.port_list)) > 0 ? tolist(split(",", e.port_list)) : [e.port_list]
            ) : length(regexall("-", d)) > 0 ? [for y in range(tonumber(element(split("-", d), 0)
          ), (tonumber(element(split("-", d), 1)) + 1)) : tonumber(y)] : [d]])
        })]
        port_role_ethernet_uplinks = [for e in lookup(v, "port_role_ethernet_uplinks", []) : merge(local.lport.port_role_ethernet_uplinks, e, {
          for d in local.prethp : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}"
          }, {
          port_list = flatten([for d in compact(length(regexall("-", e.port_list)) > 0 ? tolist(split(",", e.port_list)
            ) : length(regexall(",", e.port_list)) > 0 ? tolist(split(",", e.port_list)) : [e.port_list]
            ) : length(regexall("-", d)) > 0 ? [for y in range(tonumber(element(split("-", d), 0)
          ), (tonumber(element(split("-", d), 1)) + 1)) : tonumber(y)] : [d]])
        })]
        port_role_fc_storage = [for e in lookup(v, "port_role_fc_storage", []) : merge(local.lport.port_role_fc_storage, e, {
          port_list = flatten([for d in compact(length(regexall("-", e.port_list)) > 0 ? tolist(split(",", e.port_list)
            ) : length(regexall(",", e.port_list)) > 0 ? tolist(split(",", e.port_list)) : [e.port_list]
            ) : length(regexall("-", d)) > 0 ? [for y in range(tonumber(element(split("-", d), 0)
          ), (tonumber(element(split("-", d), 1)) + 1)) : tonumber(y)] : [d]])
          vsan_id = length(e.vsan_ids) >= 2 ? element(e.vsan_ids, x) : element(e.vsan_ids, 0)
        })]
        port_role_fc_uplinks = [for e in lookup(v, "port_role_fc_uplinks", []) : merge(local.lport.port_role_fc_uplinks, e, {
          port_list = flatten([for d in compact(length(regexall("-", e.port_list)) > 0 ? tolist(split(",", e.port_list)
            ) : length(regexall(",", e.port_list)) > 0 ? tolist(split(",", e.port_list)) : [e.port_list]
            ) : length(regexall("-", d)) > 0 ? [for y in range(tonumber(element(split("-", d), 0)
          ), (tonumber(element(split("-", d), 1)) + 1)) : tonumber(y)] : [d]])
          vsan_id = length(e.vsan_ids) >= 2 ? element(e.vsan_ids, x) : element(e.vsan_ids, 0)
        })]
        port_role_fcoe_uplinks = [for e in lookup(v, "port_role_fcoe_uplinks", []) : merge(local.lport.port_role_fcoe_uplinks, e, {
          for d in local.prethp : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}"
          }, {
          port_list = flatten([for d in compact(length(regexall("-", e.port_list)) > 0 ? tolist(split(",", e.port_list)
            ) : length(regexall(",", e.port_list)) > 0 ? tolist(split(",", e.port_list)) : [e.port_list]
            ) : length(regexall("-", d)) > 0 ? [for y in range(tonumber(element(split("-", d), 0)
          ), (tonumber(element(split("-", d), 1)) + 1)) : tonumber(y)] : [d]])
        })]
        port_role_servers = [for e in lookup(v, "port_role_servers", []) : merge(local.lport.port_role_servers, v, {
          port_list = flatten([for d in compact(length(regexall("-", e.port_list)) > 0 ? tolist(split(",", e.port_list)
            ) : length(regexall(",", e.port_list)) > 0 ? tolist(split(",", e.port_list)) : [e.port_list]
            ) : length(regexall("-", d)) > 0 ? [for y in range(tonumber(element(split("-", d), 0)
          ), (tonumber(element(split("-", d), 1)) + 1)) : tonumber(y)] : [d]])
        })]
        tags = lookup(v, "tags", var.global_settings.tags)
      })
    ]
  ] if length(lookup(lookup(var.model[org], "policies", {}), "port", [])) > 0]) : "${i.organization}/${i.key}" => i }
  port_channel_appliances = { for i in flatten([for k, v in local.port : [for e in v.port_channel_appliances : merge(e, { tags = v.tags })]]
  ) : "${i.port_policy}/${i.pc_id}" => i }
  port_channel_ethernet_uplinks = { for i in flatten([for k, v in local.port : [for e in v.port_channel_ethernet_uplinks : merge(e, { tags = v.tags })]]
  ) : "${i.port_policy}/${i.pc_id}" => i }
  port_channel_fc_uplinks = { for i in flatten([for k, v in local.port : [for e in v.port_channel_fc_uplinks : merge(e, { tags = v.tags })]]
  ) : "${i.port_policy}/${i.pc_id}" => i }
  port_channel_fcoe_uplinks = { for i in flatten([for k, v in local.port : [for e in v.port_channel_fcoe_uplinks : merge(e, { tags = v.tags })]]
  ) : "${i.port_policy}/${i.pc_id}" => i }
  port_modes = { for i in flatten([for k, v in local.port : [
    for e in v.port_modes : merge(e, { tags = v.tags })
  ]]) : "${i.port_policy}/${i.slot_id}-${element(i.port_list, 0)}" => i }
  port_role_appliances = { for i in flatten([for k, v in local.port : [
    for e in v.port_role_appliances : [for d in e.port_list : merge(e, { port_id = d, port_policy = k, tags = v.tags })]
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  port_role_ethernet_uplinks = { for i in flatten([for k, v in local.port : [
    for e in v.port_role_ethernet_uplinks : [for d in e.port_list : merge(e, { port_id = d, port_policy = k, tags = v.tags })]
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  port_role_fc_storage = { for i in flatten([for k, v in local.port : [
    for e in v.port_role_fc_storage : [for d in e.port_list : merge(e, { port_id = d, port_policy = k, tags = v.tags })]
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  port_role_fc_uplinks = { for i in flatten([for k, v in local.port : [
    for e in v.port_role_fc_uplinks : [for d in e.port_list : merge(e, { port_id = d, port_policy = k, tags = v.tags })]
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  port_role_fcoe_uplinks = { for i in flatten([for k, v in local.port : [
    for e in v.port_role_fcoe_uplinks : [for d in e.port_list : merge(e, { port_id = d, port_policy = k, tags = v.tags })]
  ]]) : "${i.port_policy}/${i.slot_id}-${i.breakout_port_id}-${i.port_id}" => i }
  port_role_servers = { for i in flatten([for k, v in local.port : [
    for e in v.port_role_servers : [for d in e.port_list : merge(e, { port_id = d, port_policy = k, tags = v.tags })]
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
  scp        = local.defaults.san_connectivity
  svsingle   = ["fibre_channel_adapter_policy", "fibre_channel_qos_policy"]
  svdual     = ["fc_zone_policies", "fibre_channel_network_policies", "wwpn_pools"]
  svtemplate = ["fibre_channel_adapter_policy", "fibre_channel_network_policy", "wwpn_pool"]
  san_connectivity = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "san_connectivity", []) : merge(local.scp, v, {
      key          = v.name
      name         = "${local.npfx[org].san_connectivity}${v.name}${local.nsfx[org].san_connectivity}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
      wwnn_pool    = length(regexall("/", v.wwnn_pool)) > 0 ? v.wwnn_pool : "${org}/${v.wwnn_pool}"
      vhbas = flatten([for e in lookup(v, "vhbas", []) : merge(local.scp.vhbas, e, {
        san_connectivity = "${org}/${v.name}"
        organization     = org
        tags             = lookup(v, "tags", var.global_settings.tags)
        }, { for d in local.svsingle : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}" }, {
        for d in local.svdual : d => [for c in lookup(e, d, local.scp.vhbas[d]) : length(regexall("/", c)) > 0 ? c : "${org}/${c}"]
        })
      ])
      vhbas_from_template = flatten([for e in lookup(v, "vhbas_from_template", []) : merge(local.scp.vhbas_from_template, e, {
        fc_zone_policies = [for d in lookup(e, "fc_zone_policies", []) : length(regexall("/", d)) > 0 ? d : "${org}/${d}"]
        fibre_channel_adapter_policy = length(regexall("/", e.fibre_channel_adapter_policy)
        ) > 0 ? e.fibre_channel_adapter_policy : "${org}/${e.fibre_channel_adapter_policy}"
        fibre_channel_network_policy = length(regexall("/", e.fibre_channel_network_policy)
        ) > 0 ? e.fibre_channel_network_policy : "${org}/${e.fibre_channel_network_policy}"
        fibre_channel_qos_policy = length(regexall("/", e.fibre_channel_qos_policy)) > 0 ? e.fibre_channel_qos_policy : "${org}/${e.fibre_channel_qos_policy}"
        san_connectivity         = "${org}/${v.name}"
        name                     = e.name
        organization             = org
        placement = [for d in [merge(local.scp.vhbas.placement, lookup(e, "placement", {}))] : {
          automatic_pci_link_assignment = d.pci_link != null ? false : true
          automatic_slot_id_assignment  = d.slot_id != "" ? false : true
          pci_link                      = d.pci_link != null ? d.pci_link : 0
        }][0]
        tags          = lookup(v, "tags", var.global_settings.tags)
        wwpn_pool     = length(regexall("/", v.wwpn_pool)) > 0 ? v.wwpn_pool : "${org}/${v.wwpn_pool}"
        vhba_template = length(regexall("/", e.vhba_template)) > 0 ? e.vhba_template : "${org}/${e.vhba_template}"
        }, { for d in local.svtemplate : d => length(regexall("/", lookup(e, d, "UNUSED"))) > 0 ? e[d] : "${org}/${lookup(e, d, "UNUSED")}" })
      ])
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "san_connectivity", [])) > 0]) : "${i.organization}/${i.key}" => i }

  #_________________________________________________________________________
  #
  # Intersight SAN Connectivity - vHBA / vHBA from Template
  # GUI Location: Configure > Policies > Create Policy > SAN Connectivity
  #_________________________________________________________________________
  vhbas = { for i in flatten([for k, v in local.san_connectivity : [
    for e in v.vhbas : [for x in range(length(e.names)) : merge(e, {
      fc_zone_policies = length(e.fc_zone_policies) > 0 ? element(chunklist(e.fc_zone_policies, 2), x) : []
      fibre_channel_network_policy = length(e.fibre_channel_network_policies
      ) >= 2 ? element(e.fibre_channel_network_policies, x) : element(e.fibre_channel_network_policies, 0)
      name = element(e.names, x)
      placement = [for d in [merge(local.lcp.vnics.placement, lookup(e, "placement", {}))] : {
        automatic_pci_link_assignment = length(d.pci_links) > 0 ? false : true
        automatic_slot_id_assignment  = length(d.slot_ids) > 0 ? false : true
        pci_link                      = length(d.pci_links) == 2 ? element(d.pci_links, x) : length(d.pci_links) == 1 ? element(d.pci_links, 0) : 0
        pci_order                     = length(d.pci_order) == 2 ? element(d.pci_order, x) : element(d.pci_order, 0)
        slot_id                       = length(d.slot_ids) == 2 ? element(d.slot_ids, x) : length(d.slot_ids) == 1 ? element(d.slot_ids, 0) : ""
        switch_id                     = length(d.switch_ids) == 2 ? element(d.switch_ids, x) : element(d.switch_ids, 0)
        uplink_port                   = length(d.uplink_ports) == 2 ? element(d.uplink_ports, x) : element(d.uplink_ports, 0)
      }][0]
      wwpn_pool           = length(e.wwpn_pools) >= 2 ? element(e.wwpn_pools, x) : element(e.wwpn_pools, 0)
      wwpn_static_address = length(e.wwpn_static_addresses) > 0 ? element(e.wwpn_static_addresses, x) : ""
    })]
  ]]) : "${i.san_connectivity}/${i.name}" => i }
  vhbas_from_template = { for i in flatten([
    for k, v in local.san_connectivity : [for e in v.vhbas_from_template : merge(e, {
      template_source = contains(keys(local.vhba_templates), e.vhba_template) ? "local" : "data"
    })]
  ]) : "${i.lan_connectivity}/${i.name}" => i }

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

  #_________________________________________________________________________
  #
  # Intersight vHBA Templates
  # GUI Location: Templates > vHBA Templates > Create vHBA Template
  #_________________________________________________________________________
  vhba_templates = local.defaults.vhba_templates
  vhba_template = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "vnic_template", []) : merge(local.vhba_templates, v, {
      fc_zone_policies = length(v.fc_zone_policies) > 0 ? v.fc_zone_policies : []
      fibre_channel_adapter_policy = {
        name = length(regexall("/", v.fibre_channel_adapter_policy)) > 0 ? element(split("/", v.fibre_channel_adapter_policy), 1) : v.fibre_channel_adapter_policy
        org  = length(regexall("/", v.fibre_channel_adapter_policy)) > 0 ? element(split("/", v.fibre_channel_adapter_policy), 0) : org
      }
      fibre_channel_network_policy = {
        name = length(regexall("/", v.fibre_channel_network_policy)) > 0 ? element(split("/", v.fibre_channel_network_policy), 1) : v.fibre_channel_network_policies
        org  = length(regexall("/", v.fibre_channel_network_policy)) > 0 ? element(split("/", v.fibre_channel_network_policy), 0) : org
      }
      fibre_channel_qos_policy = {
        name = length(regexall("/", v.fibre_channel_qos_policy)) > 0 ? element(split("/", v.fibre_channel_qos_policy), 1) : v.fibre_channel_qos_policy
        org  = length(regexall("/", v.fibre_channel_qos_policy)) > 0 ? element(split("/", v.fibre_channel_qos_policy), 0) : org
      }
      name         = "${local.npfx[org].vnic_template}${v.name}${local.nsfx[org].vnic_template}"
      organization = org
      tags         = lookup(v, "tags", var.global_settings.tags)
      wwpn_pool = {
        name = length(regexall("/", v.wwpn_pool)) > 0 ? element(split("/", v.wwpn_pool), 1) : v.wwpn_pool
        org  = length(regexall("/", v.wwpn_pool)) > 0 ? element(split("/", v.wwpn_pool), 0) : org
      }
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "vnic_template", [])) > 0]) : "${i.organization}/${i.key}" => i }

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
  # Intersight vNIC Templates
  # GUI Location: Templates > vNIC Templates > Create vNIC Template
  #_________________________________________________________________________
  vnict          = ["ethernet_adapter_policy", "ethernet_network_control_policy", "ethernet_network_group_policy", "ethernet_qos_policy", "iscsi_boot_policy", "mac_address_pool"]
  vnic_templates = local.defaults.vnic_templates
  vnic_template = { for i in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "policies", {}), "vnic_template", []) : merge(local.vnic_templates, v, {
      for e in local.vnict : e => length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? v[e] : "${org}/${lookup(v, e, "UNUSED")}"
      }, {
      cdn_value    = length(lookup(v, "cdn_value", "")) > 0 ? v.cdn_value : ""
      key          = v.name
      name         = "${local.npfx[org].lan_connectivity}${v.name}${local.nsfx[org].lan_connectivity}"
      organization = org
      sr_iov       = merge(local.vnic_templates.sr_iov, lookup(v, "sr_iov", {}))
      tags         = lookup(v, "tags", var.global_settings.tags)
      usnic = [for e in [merge(local.vnic_templates.usnic, lookup(v, "usnic", {}))] : merge(e, {
        usnic_adapter_policy = length(regexall("/", lookup(e, "usnic_adapter_policy", "UNUSED"))
        ) > 0 ? e.usnic_adapter_policy : "${org}/${lookup(e, "usnic_adapter_policy", "UNUSED")}"
      })][0]
      vmq = [for e in [merge(local.vnic_templates.vmq, lookup(v, "vmq", {}))] : merge(e, {
        vmmq_adapter_policy = length(regexall("/", lookup(e, "vmmq_adapter_policy", "UNUSED"))
        ) > 0 ? e.vmmq_adapter_policy : "${org}/${lookup(e, "vmmq_adapter_policy", "UNUSED")}"
      })][0]
    })
  ] if length(lookup(lookup(var.model[org], "policies", {}), "vnic_template", [])) > 0]) : "${i.organization}/${i.key}" => i }

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
      multicast_policy      = length(regexall("/", v.multicast_policy)) > 0 ? v.multicast_policy : "${v.organization}/${v.multicast_policy}"
      name                  = v.name
      name_prefix           = v.name_prefix
      native_vlan           = v.native_vlan
      organization          = v.organization
      primary_vlan_id       = v.primary_vlan_id
      sharing_type          = v.sharing_type
      vlan_id               = s
      vlan_policy           = v.vlan_policy
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
