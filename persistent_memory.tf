#__________________________________________________________________
#
# Intersight Persistent Memory Policy
# GUI Location: Policies > Create Policy > Persistent Memory
#__________________________________________________________________
resource "intersight_memory_persistent_memory_policy" "map" {
  for_each          = local.persistent_memory
  description       = coalesce(each.value.description, "${each.value.name} Persistent Memory Policy.")
  management_mode   = each.value.management_mode
  name              = each.value.name
  retain_namespaces = each.value.retain_namespaces
  goals {
    memory_mode_percentage = each.value.memory_mode_percentage
    object_type            = "memory.PersistentMemoryGoal"
    persistent_memory_type = each.value.persistent_memory_type
    socket_id              = "All Sockets"
  }
  organization { moid = var.orgs[each.value.org] }
  dynamic "local_security" {
    for_each = {
      for v in compact([each.value.name]
      ) : each.value.name => v if length(local.ps.persistent_memory.passphrase[each.value.passphrase]) > 0
    }
    content {
      object_type       = "memory.PersistentMemoryLocalSecurity"
      enabled           = length(local.ps.persistent_memory.passphrase[each.value.passphrase]) > 0 ? true : false
      secure_passphrase = local.ps.persistent_memory.passphrase[each.value.passphrase]
    }
  }
  dynamic "logical_namespaces" {
    for_each = { for v in each.value.namespaces : v.name => v }
    content {
      capacity         = logical_namespaces.value.capacity
      mode             = logical_namespaces.value.mode
      name             = logical_namespaces.key
      object_type      = "memory.PersistentMemoryLocalSecurity"
      socket_id        = logical_namespaces.value.socket_id
      socket_memory_id = logical_namespaces.value.socket_memory_id
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
