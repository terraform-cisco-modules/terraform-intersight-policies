#__________________________________________________________________
#
# Intersight Certificate Management Policy
# GUI Location: Policies > Create Policy > Certificate Management
#__________________________________________________________________

resource "intersight_certificatemanagement_policy" "certificate_management" {
  for_each    = local.certificate_management
  description = lookup(each.value, "description", "${each.value.name} Certificate Management Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[var.organization]
    object_type = "organization.Organization"
  }
  certificates {
    certificate {
      pem_certificate = length(
        regexall("1", tostring(each.value.certificate))) > 0 ? base64encode(var.cert_mgmt_certificate_1) : length(
        regexall("2", tostring(each.value.certificate))) > 0 ? base64encode(var.cert_mgmt_certificate_2) : length(
        regexall("3", tostring(each.value.certificate))) > 0 ? base64encode(var.cert_mgmt_certificate_3) : length(
        regexall("4", tostring(each.value.certificate))) > 0 ? base64encode(var.cert_mgmt_certificate_4) : length(
      regexall("5", tostring(each.value.certificate))) > 0 ? base64encode(var.cert_mgmt_certificate_5) : null
    }
    enabled = true
    privatekey = length(
      regexall("1", tostring(each.value.private_key))) > 0 ? base64encode(var.cert_mgmt_private_key_1) : length(
      regexall("2", tostring(each.value.private_key))) > 0 ? base64encode(var.cert_mgmt_private_key_2) : length(
      regexall("3", tostring(each.value.private_key))) > 0 ? base64encode(var.cert_mgmt_private_key_3) : length(
      regexall("4", tostring(each.value.private_key))) > 0 ? base64encode(var.cert_mgmt_private_key_4) : length(
    regexall("5", tostring(each.value.private_key))) > 0 ? base64encode(var.cert_mgmt_private_key_5) : null
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
