#__________________________________________________________________
#
# Intersight iSCSI Boot Policy
# GUI Location: Policies > Create Policy > iSCSI Boot
#__________________________________________________________________

resource "intersight_vnic_iscsi_boot_policy" "iscsi_boot" {
  depends_on = [
    intersight_vnic_iscsi_adapter_policy.iscsi_adapter,
    intersight_vnic_iscsi_static_target_policy.iscsi_static_target
  ]
  for_each               = { for v in lookup(local.policies, "iscsi_boot", []) : v.name => v }
  auto_targetvendor_name = lookup(each.value, "dhcp_vendor_id_iqn", local.liboot.dhcp_vendor_id_iqn)
  chap = lookup(each.value, "authentication", local.liboot.authentication
    ) == "chap" && lookup(each.value, "target_source_type", local.liboot.target_source_type) == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = var.iscsi_boot_password
      user_id               = lookup(each.value, "username", "")
    }
    ] : lookup(each.value, "target_source_type", local.liboot.target_source_type) == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = ""
      user_id               = ""
    }
  ] : null
  description = lookup(each.value, "description", "${each.value.name} iSCSI Boot Policy.")
  initiator_ip_source = lookup(each.value, "target_source_type", local.liboot.target_source_type
  ) == "Auto" ? "DHCP" : lookup(each.value, "initiator_ip_source", local.liboot.initiator_ip_source)
  initiator_static_ip_v4_address = length(regexall("Static", lookup(
    each.value, "initiator_ip_source", local.liboot.initiator_ip_source))
  ) > 0 ? each.value.initiator_static_ipv4_config.ip_address : ""
  initiator_static_ip_v4_config = lookup(each.value, "target_source_type", local.liboot.target_source_type) == "Static" ? [
    {
      additional_properties = ""
      class_id              = "ippool.IpV4Config"
      gateway = length(regexall("Static", lookup(each.value, "initiator_ip_source", local.liboot.initiator_ip_source))
      ) > 0 ? each.value.initiator_static_ipv4_config.default_gateway : ""
      netmask = length(regexall("Static", lookup(each.value, "initiator_ip_source", local.liboot.initiator_ip_source))
      ) > 0 ? each.value.initiator_static_ipv4_config.subnet_mask : ""
      object_type = "ippool.IpV4Config"
      primary_dns = length(regexall("Static", lookup(each.value, "initiator_ip_source", local.liboot.initiator_ip_source))
      ) > 0 ? lookup(lookup(each.value, "initiator_static_ipv4_config", {}), "primary_dns", "") : ""
      secondary_dns = length(regexall("Static", lookup(each.value, "initiator_ip_source", local.liboot.initiator_ip_source))
      ) > 0 ? lookup(lookup(each.value, "initiator_static_ipv4_config", {}), "secondary_dns", "") : ""
    }
  ] : null
  mutual_chap = lookup(each.value, "authentication", local.liboot.authentication
    ) == "mutual_chap" && lookup(each.value, "target_source_type", local.liboot.target_source_type) == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = each.value.iscsi_boot_password
      user_id               = lookup(each.value, "username", "")
    }
    ] : lookup(each.value, "target_source_type", local.liboot.target_source_type) == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = ""
      user_id               = ""
    }
  ] : null
  name               = "${each.key}${local.defaults.intersight.policies.ethernet_qos.name_suffix}"
  target_source_type = lookup(each.value, "target_source_type", local.liboot.target_source_type)
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  dynamic "initiator_ip_pool" {
    for_each = { for v in compact([lookup(each.value, "initiator_ip_pool", "")]
    ) : v => v if lookup(each.value, "target_source_type", local.liboot.target_source_type) != "Auto" }
    content {
      moid = var.pools.ip[each.value.initiator_ip_pool].moid
    }
  }
  dynamic "iscsi_adapter_policy" {
    for_each = { for v in compact([lookup(each.value, "iscsi_adapter_policy", "")]) : v => v }
    content {
      moid = intersight_vnic_iscsi_adapter_policy.iscsi_adapter[iscsi_adapter_policy.value].moid
    }
  }
  dynamic "primary_target_policy" {
    for_each = { for v in compact([lookup(each.value, "primary_target_policy", "")]
    ) : v => v if each.value.target_source_type != "Auto" }
    content {
      moid = intersight_vnic_iscsi_static_target_policy.iscsi_static_target[primary_target_policy.value].moid
    }
  }
  dynamic "secondary_target_policy" {
    for_each = { for v in compact([lookup(each.value, "secondary_target_policy", "")]
    ) : v => v if each.value.target_source_type != "Auto" }
    content {
      moid = intersight_vnic_iscsi_static_target_policy.iscsi_static_target[secondary_target_policy.value].moid
    }
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
