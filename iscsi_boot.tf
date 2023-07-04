#__________________________________________________________________
#
# Intersight iSCSI Boot Policy
# GUI Location: Policies > Create Policy > iSCSI Boot
#__________________________________________________________________

resource "intersight_vnic_iscsi_boot_policy" "iscsi_boot" {
  depends_on = [
    data.intersight_search_search_item.ip,
    data.intersight_search_search_item.iscsi_adapter,
    data.intersight_search_search_item.iscsi_static_target,
    intersight_vnic_iscsi_adapter_policy.iscsi_adapter,
    intersight_vnic_iscsi_static_target_policy.iscsi_static_target
  ]
  for_each               = { for k, v in local.iscsi_boot : k => v }
  auto_targetvendor_name = each.value.dhcp_vendor_id_iqn
  chap = each.value.authentication == "chap" && each.value.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = var.iscsi_boot_password
      user_id               = each.value.username
    }
    ] : each.value.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = ""
      user_id               = ""
    }
  ] : null
  description         = lookup(each.value, "description", "${each.value.name} iSCSI Boot Policy.")
  initiator_ip_source = each.value.target_source_type == "Auto" ? "DHCP" : each.value.initiator_ip_source
  initiator_static_ip_v4_address = length(regexall("Static", each.value.initiator_ip_source)
  ) > 0 ? each.value.ip_address : ""
  initiator_static_ip_v4_config = each.value.initiator_ip_source == "Static" ? [
    {
      additional_properties = ""
      class_id              = "ippool.IpV4Config"
      gateway               = each.value.gateway
      netmask               = each.value.netmask
      object_type           = "ippool.IpV4Config"
      primary_dns           = each.value.primary_dns
      secondary_dns         = each.value.secondary_dns
    }
  ] : null
  mutual_chap = each.value.authentication == "mutual_chap" && each.value.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = var.iscsi_boot_password
      user_id               = each.value.username
    }
    ] : each.value.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = ""
      user_id               = ""
    }
  ] : null
  name               = each.value.name
  target_source_type = each.value.target_source_type
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "initiator_ip_pool" {
    for_each = {
      for v in [each.value.initiator_ip_pool.name] : v => v if each.value.initiator_ip_pool.name != "UNUSED"
    }
    content {
      moid = length(regexall(false, var.moids_pools)) > 0 ? var.pools[each.value.initiator_ip_pool.org].ip[
        each.value.initiator_ip_pool.name
        ] : [for i in data.intersight_search_search_item.ip[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.initiator_ip_pool.org
      ] && jsondecode(i.additional_properties).Name == each.value.initiator_ip_pool.name][0]
      object_type = "ippool.Pool"
    }
  }
  dynamic "iscsi_adapter_policy" {
    for_each = {
      for v in [each.value.iscsi_adapter_policy.name
      ] : v => v if each.value.iscsi_adapter_policy.name != "UNUSED"
    }
    content {
      moid = length(regexall(each.value.iscsi_adapter_policy.org, each.value.organization)
        ) > 0 ? intersight_vnic_iscsi_adapter_policy.iscsi_adapter[each.value.iscsi_adapter_policy.name
        ].moid : [for i in data.intersight_search_search_item.iscsi_adapter[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.iscsi_adapter_policy.org
      ] && jsondecode(i.additional_properties).Name == each.value.iscsi_adapter_policy.name][0]
    }
  }
  dynamic "primary_target_policy" {
    for_each = {
      for v in [each.value.primary_target_policy.name
      ] : v => v if each.value.primary_target_policy.name != "UNUSED"
    }
    content {
      moid = length(regexall(each.value.primary_target_policy.org, each.value.organization)
        ) > 0 ? intersight_vnic_iscsi_static_target_policy.iscsi_static_target[each.value.primary_target_policy.name
        ].moid : [for i in data.intersight_search_search_item.iscsi_static_target[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.primary_target_policy.org
      ] && jsondecode(i.additional_properties).Name == each.value.primary_target_policy.name][0]
    }
  }
  dynamic "secondary_target_policy" {
    for_each = {
      for v in [each.value.secondary_target_policy.name
      ] : v => v if each.value.secondary_target_policy.name != "UNUSED"
    }
    content {
      moid = length(regexall(each.value.secondary_target_policy.org, each.value.organization)
        ) > 0 ? intersight_vnic_iscsi_static_target_policy.iscsi_static_target[each.value.secondary_target_policy.name
        ].moid : [for i in data.intersight_search_search_item.iscsi_static_target[0].results : i.moid if jsondecode(
          i.additional_properties).Organization.Moid == local.orgs[each.value.secondary_target_policy.org
      ] && jsondecode(i.additional_properties).Name == each.value.secondary_target_policy.name][0]
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
