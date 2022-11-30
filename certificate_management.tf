#__________________________________________________________________
#
# Intersight Certificate Management Policy
# GUI Location: Policies > Create Policy > Certificate Management
#__________________________________________________________________

resource "intersight_certificatemanagement_policy" "certificate_management" {
  for_each    = { for v in lookup(local.policies, "certificate_management", []) : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Certificate Management Policy.")
  name        = "${each.key}${local.defaults.intersight.policies.certificate_management.name_suffix}"
  organization {
    moid        = local.orgs[lookup(each.value, "organization", var.organization)]
    object_type = "organization.Organization"
  }
  certificates {
    certificate {
      pem_certificate = length(
        regexall("1", lookup(each.value, "base64_certificate", 1))
        ) > 0 ? var.base64_certificate_1 : length(
        regexall("2", lookup(each.value, "base64_certificate", 1))
        ) > 0 ? var.base64_certificate_2 : length(
        regexall("3", lookup(each.value, "base64_certificate", 1))
        ) > 0 ? var.base64_certificate_3 : length(
        regexall("4", lookup(each.value, "base64_certificate", 1))
        ) > 0 ? var.base64_certificate_4 : length(
        regexall("5", lookup(each.value, "base64_certificate", 1))
      ) > 0 ? var.base64_certificate_5 : null
    }
    enabled = lookup(each.value, "enabled", local.defaults.intersight.policies.certificate_management.enabled)
    privatekey = length(
      regexall("1", lookup(each.value, "base64_private_key", 1))
      ) > 0 ? var.base64_private_key_1 : length(
      regexall("2", lookup(each.value, "base64_private_key", 1))
      ) > 0 ? var.base64_private_key_2 : length(
      regexall("3", lookup(each.value, "base64_private_key", 1))
      ) > 0 ? var.base64_private_key_3 : length(
      regexall("4", lookup(each.value, "base64_private_key", 1))
      ) > 0 ? var.base64_private_key_4 : length(
      regexall("5", lookup(each.value, "base64_private_key", 1))
    ) > 0 ? var.base64_private_key_5 : null
  }
  dynamic "tags" {
    for_each = lookup(each.value, "tags", var.tags)
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
