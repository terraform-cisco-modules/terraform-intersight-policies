locals {
    keys = [1, 2, 3, 4]
    loop = [for e in local.keys: var.certificate_management.certificates[e]]
}

variable "certificate_management" {
  default = {
    certificates = {}
    private_keys = {}
  }
  description = "Certificates and Private Keys in PEM Format."
  sensitive = true
  type = object({
    certificates = map(string)
    private_keys = map(string)
  })
}

output "loop" {
  value = local.loop
  sensitive = true
}