#__________________________________________________________________
#
# Intersight iSCSI Boot Policy
# GUI Location: Policies > Create Policy > iSCSI Boot
#__________________________________________________________________

resource "intersight_vnic_iscsi_boot_policy" "map" {
  depends_on = [
    intersight_vnic_iscsi_adapter_policy.map,
    intersight_vnic_iscsi_static_target_policy.map
  ]
  for_each               = local.iscsi_boot
  auto_targetvendor_name = each.value.dhcp_vendor_id_iqn
  chap = each.value.authentication == "chap" && each.value.target_source_type == "Static" ? [
    {
      additional_properties = ""
      class_id              = "vnic.IscsiAuthProfile"
      is_password_set       = null
      object_type           = "vnic.IscsiAuthProfile"
      password              = local.ps.iscsi_boot.password[each.value.password]
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
  description         = coalesce(each.value.description, "${each.value.name} iSCSI Boot Policy.")
  initiator_ip_source = each.value.target_source_type == "Auto" ? "DHCP" : each.value.initiator_ip_source
  initiator_static_ip_v4_address = length(regexall("Static", each.value.initiator_ip_source)
  ) > 0 ? each.value.initiator_static_ip_v4_config.ip_address : ""
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
      password              = local.ps.iscsi_boot.password[each.value.password]
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
  organization { moid = var.orgs[each.value.organization] }
  dynamic "initiator_ip_pool" {
    for_each = { for v in [each.value.initiator_ip_pool] : "${v.org}/${v.name}" => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.pools["ip"].moids), "${initiator_ip_pool.value.org}/${initiator_ip_pool.value.name}"
        ) == true ? local.pools.ip.moids["${initiator_ip_pool.value.org}/${initiator_ip_pool.value.name}"] : [for i in data.intersight_search_search_item.pools["ip"
          ].results : i.moid if jsondecode(i.additional_properties).Name == initiator_ip_pool.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[initiator_ip_pool.value.org]][0]
      object_type = "ippool.Pool"
    }
  }
  dynamic "iscsi_adapter_policy" {
    for_each = { for v in [each.value.iscsi_adapter_policy] : "${v.org}/${v.name}" => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.iscsi_adapter), "${iscsi_adapter_policy.value.org}/${iscsi_adapter_policy.value.name}"
        ) == true ? intersight_vnic_iscsi_adapter_policy.map["${iscsi_adapter_policy.value.org}/${iscsi_adapter_policy.value.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["iscsi_adapter"
          ].results : i.moid if jsondecode(i.additional_properties).Name == iscsi_adapter_policy.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[iscsi_adapter_policy.value.org]][0]
    }
  }
  dynamic "primary_target_policy" {
    for_each = { for v in [each.value.primary_target_policy] : "${v.org}/${v.name}" => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.iscsi_static_target), "${primary_target_policy.value.org}/${primary_target_policy.value.name}"
        ) == true ? intersight_vnic_iscsi_static_target_policy.map["${primary_target_policy.value.org}/${primary_target_policy.value.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["iscsi_static_target"
          ].results : i.moid if jsondecode(i.additional_properties).Name == primary_target_policy.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[primary_target_policy.value.org]][0]
    }
  }
  dynamic "secondary_target_policy" {
    for_each = { for v in [each.value.secondary_target_policy] : "${v.org}/${v.name}" => v if v.name != "UNUSED" }
    content {
      moid = contains(keys(local.iscsi_static_target), "${secondary_target_policy.value.org}/${secondary_target_policy.value.name}"
        ) == true ? intersight_vnic_iscsi_static_target_policy.map["${secondary_target_policy.value.org}/${secondary_target_policy.value.name}"
        ].moid : [for i in data.intersight_search_search_item.policies["iscsi_static_target"
          ].results : i.moid if jsondecode(i.additional_properties).Name == secondary_target_policy.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[secondary_target_policy.value.org]][0]
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
