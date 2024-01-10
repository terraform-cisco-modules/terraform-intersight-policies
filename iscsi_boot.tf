#__________________________________________________________________
#
# Intersight iSCSI Boot Policy
# GUI Location: Policies > Create Policy > iSCSI Boot
#__________________________________________________________________

resource "intersight_vnic_iscsi_boot_policy" "map" {
  depends_on = [
    intersight_ippool_pool.data,
    intersight_vnic_iscsi_adapter_policy.data,
    intersight_vnic_iscsi_adapter_policy.map,
    intersight_vnic_iscsi_static_target_policy.data,
    intersight_vnic_iscsi_static_target_policy.map
  ]
  for_each               = { for k, v in local.iscsi_boot : k => v }
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
  organization {
    moid        = local.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "initiator_ip_pool" {
    for_each = { for v in [each.value.initiator_ip_pool] : v.name => v if v.name != "UNUSED" }
    content {
      moid = length(regexall("#EXIST", lookup(lookup(lookup(local.pools, initiator_ip_pool.value.org, {}), "ip", {}), initiator_ip_pool.value.name, "#EXIST"))
        ) == 0 ? local.pools[initiator_ip_pool.value.org].ip[initiator_ip_pool.value.name
      ] : intersight_ippool_pool.data["${initiator_ip_pool.value.org}:${initiator_ip_pool.value.name}"].moid
      object_type = "ippool.Pool"
    }
  }
  dynamic "iscsi_adapter_policy" {
    for_each = { for v in [each.value.iscsi_adapter_policy] : v => v }
    content {
      moid = lookup(local.iscsi_adapter, iscsi_adapter_policy.value.name, "#NOEXIST"
        ) != "#NOEXIST" ? intersight_vnic_iscsi_adapter_policy.map[iscsi_adapter_policy.value.name
      ].moid : intersight_vnic_iscsi_adapter_policy.data["${iscsi_adapter_policy.value.org}:${iscsi_adapter_policy.value.name}"].moid
    }
  }
  dynamic "primary_target_policy" {
    for_each = { for v in [each.value.primary_target_policy] : v.name => v }
    content {
      moid = lookup(local.iscsi_static_target, primary_target_policy.value.name, "#NOEXIST"
        ) != "#NOEXIST" ? intersight_vnic_iscsi_static_target_policy.map[primary_target_policy.value.name
      ].moid : intersight_vnic_iscsi_static_target_policy.data["${primary_target_policy.value.org}:${primary_target_policy.value.name}"].moid
    }
  }
  dynamic "secondary_target_policy" {
    for_each = { for v in [each.value.secondary_target_policy] : v.name => v }
    content {
      moid = lookup(local.iscsi_static_target, secondary_target_policy.value.name, "#NOEXIST"
        ) != "#NOEXIST" ? intersight_vnic_iscsi_static_target_policy.map[secondary_target_policy.value.name
      ].moid : intersight_vnic_iscsi_static_target_policy.data["${secondary_target_policy.value.org}:${secondary_target_policy.value.name}"].moid
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

resource "intersight_vnic_iscsi_boot_policy" "data" {
  depends_on = [intersight_vnic_iscsi_boot_policy.map]
  for_each = {
    for v in local.pp.iscsi_boot : v => v if lookup(local.iscsi_boot, element(split(":", v), 1), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, auto_targetvendor_name, chap, create_time, description, domain_group_moid,
      initiator_ip_pool, initiator_ip_source, initiator_static_ip_v4_address, initiator_static_ip_v4_config, iscsi_adapter_policy,
      mod_time, mutual_chap, owners, parent, permission_resources, primary_target_policy, secondary_target_policy, shared_scope,
      tags, target_source_type, version_context
    ]
    prevent_destroy = true
  }
}
