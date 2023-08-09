#__________________________________________________________________
#
# Intersight Certificate Management Policy
# GUI Location: Policies > Create Policy > Certificate Management
#__________________________________________________________________

resource "intersight_certificatemanagement_policy" "map" {
  for_each = {
    for v in lookup(local.policies, "certificate_management", []) : v.name => merge(local.cert_mgmt, v, {
      certificates = [for e in lookup(v, "certificates", []) : merge(local.cert_mgmt.certificates, e)]
      name         = "${local.npfx.certificate_management}${v.name}${local.nsfx.certificate_management}"
      organization = local.organization
      tags         = lookup(v, "tags", var.policies.global_settings.tags)
    }) if lookup(v, "assigned_sensitive_data", false) == true
  }
  description = coalesce(each.value.description, "${each.value.name} Certificate Management Policy.")
  name        = each.value.name
  organization {
    moid        = local.orgs[local.organization]
    object_type = "organization.Organization"
  }
  dynamic "certificates" {
    for_each = { for k, v in each.value.certificates : k => v }
    content {
      certificate { additional_properties = jsonencode({
        PemCertificate = base64encode(local.ps.certificate_management.certificate[certificates.value.id])
      }) }
      additional_properties = certificates.value.type == "IMC" ? jsonencode({
        CertType   = certificates.value.cert_type
        Privatekey = base64encode(local.ps.certificate_management.private_key[certificates.value.id])
      }) : jsonencode({ CertificateName = certificates.value.name })
      enabled = certificates.value.enabled
      object_type = length(regexall("RootCA", certificates.value.type)
      ) > 0 ? "certificatemanagement.RootCaCertificate" : "certificatemanagement.Imc"
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
