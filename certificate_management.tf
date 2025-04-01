#__________________________________________________________________
#
# Intersight Certificate Management Policy
# GUI Location: Policies > Create Policy > Certificate Management
#__________________________________________________________________
resource "intersight_certificatemanagement_policy" "map" {
  for_each    = local.certificate_management
  description = coalesce(each.value.description, "${each.value.name} Certificate Management Policy.")
  name        = each.value.name
  organization { moid = var.orgs[each.value.org] }
  dynamic "certificates" {
    for_each = { for k, v in each.value.certificates : k => v }
    content {
      certificate { additional_properties = jsonencode({
        PemCertificate = base64encode(local.ps.certificate_management.certificate[certificates.value.variable_id])
      }) }
      additional_properties = certificates.value.type == "IMC" ? jsonencode({
        CertType   = lookup(certificates.value, "cert_type", "None")
        Privatekey = base64encode(local.ps.certificate_management.private_key[certificates.value.variable_id])
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
