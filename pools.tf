#__________________________________________________________________
#
# Pool Data Objects
#__________________________________________________________________

resource "intersight_ippool_pool" "data" {
  for_each = {
    for v in local.pp.ip_pool : v => v if lookup(lookup(lookup(local.pools, element(split(":", v), 0), {}), "ip", {}), element(split(":", v), 0), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, assigned, assignment_order, create_time, description, domain_group_moid,
      ip_v4_blocks, ip_v4_config, ip_v6_blocks, ip_v6_config, mod_time, owners, parent, permission_resources, reservations, reserved,
      shadow_pools, shared_scope, size, tags, v4_assigned, v4_size, v6_assigned, v6_size, version_context
    ]
    prevent_destroy = true
  }
}

resource "intersight_iqnpool_pool" "data" {
  for_each = {
    for v in local.pp.iqn_pool : v => v if lookup(lookup(lookup(local.pools, element(split(":", v), 0), {}), "iqn", {}), element(split(":", v), 0), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, assigned, assignment_order, block_heads, create_time, description, domain_group_moid,
      iqn_suffix_blocks, mod_time, owners, parent, permission_resources, prefix, reservations, reserved, shared_scope, size, tags, version_context
    ]
    prevent_destroy = true
  }
}

resource "intersight_macpool_pool" "data" {
  for_each = {
    for v in local.pp.mac_pool : v => v if lookup(lookup(lookup(local.pools, element(split(":", v), 0), {}), "mac", {}), element(split(":", v), 0), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, assigned, assignment_order, block_heads, create_time, description, domain_group_moid,
      mac_blocks, mod_time, owners, parent, permission_resources, reservations, reserved, shared_scope, size, tags, version_context
    ]
    prevent_destroy = true
  }
}

resource "intersight_fcpool_pool" "wwnn" {
  for_each = {
    for v in local.pp.wwnn_pool : v => v if lookup(lookup(lookup(local.pools, element(split(":", v), 0), {}), "wwnn", {}), element(split(":", v), 0), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  pool_purpose = "WWNN"
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, assigned, assignment_order, block_heads, create_time, description, domain_group_moid,
      id_blocks, mod_time, owners, parent, permission_resources, reservations, reserved, shared_scope, size, tags, version_context
    ]
    prevent_destroy = true
  }
}

resource "intersight_fcpool_pool" "wwpn" {
  for_each = {
    for v in local.pp.wwpn_pool : v => v if lookup(lookup(lookup(local.pools, element(split(":", v), 0), {}), "wwpn", {}), element(split(":", v), 0), "#NOEXIST") == "#NOEXIST"
  }
  name = element(split(":", each.value), 1)
  organization {
    moid = local.orgs[element(split(":", each.value), 0)]
  }
  pool_purpose = "WWPN"
  lifecycle {
    ignore_changes = [
      account_moid, additional_properties, ancestors, assigned, assignment_order, block_heads, create_time, description, domain_group_moid,
      id_blocks, mod_time, owners, parent, permission_resources, reservations, reserved, shared_scope, size, tags, version_context
    ]
    prevent_destroy = true
  }
}

