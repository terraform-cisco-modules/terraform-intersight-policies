<!-- BEGIN_TF_DOCS -->
# Terraform Intersight Pools Module

A Terraform module to configure Intersight Pools.

This module is part of the Cisco [*Intersight as Code*](https://cisco.com/go/intersightascode) project. Its goal is to allow users to instantiate network fabrics in minutes using an easy to use, opinionated data model. It takes away the complexity of having to deal with references, dependencies or loops. By completely separating data (defining variables) from logic (infrastructure declaration), it allows the user to focus on describing the intended configuration while using a set of maintained and tested Terraform Modules without the need to understand the low-level Intersight object model.

A comprehensive example using this module is available here: https://github.com/terraform-cisco-modules/iac-intersight-comprehensive-example

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.32 |
## Providers

No providers.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_model"></a> [model](#input\_model) | Model data. | `any` | n/a | yes |
| <a name="input_domains"></a> [domains](#input\_domains) | Domain Moids. | `any` | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | Pool Moids. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domains"></a> [domains](#output\_domains) | output "ip\_pools" { description = "Moid of the IP Pools." value = lookup(local.modules, "pools\_ip", true) ? { for v in sort( keys(module.ip\_pools) ) : v => module.ip\_pools[v] } : {} }  output "iqn\_pools" { description = "Moid of the IQN Pools." value = lookup(local.modules, "pools\_iqn", true) ? { for v in sort( keys(module.iqn\_pools) ) : v => module.iqn\_pools[v] } : {} }  output "mac\_pools" { description = "Moid of the MAC Pools." value = lookup(local.modules, "pools\_mac", true) ? { for v in sort( keys(module.mac\_pools) ) : v => module.mac\_pools[v] } : {} }  output "resource\_pools" { description = "Moid of the Resource Pools." value = lookup(local.modules, "pools\_resource", true) ? { for v in sort( keys(module.resource\_pools) ) : v => module.resource\_pools[v] } : {} }  output "uuid\_pools" { description = "Moid of the UUID Pools." value = lookup(local.modules, "pools\_uuid", true) ? { for v in sort( keys(module.uuid\_pools) ) : v => module.uuid\_pools[v] } : {} }  output "wwnn\_pools" { description = "Moid of the WWNN Pools." value = lookup(local.modules, "pools\_wwnn", true) ? { for v in sort( keys(module.wwnn\_pools) ) : v => module.wwnn\_pools[v] } : {} }  output "wwpn\_pools" { description = "Moid of the WWPN Pools." value = lookup(local.modules, "pools\_wwpn", true) ? { for v in sort( keys(module.wwpn\_pools) ) : v => module.wwpn\_pools[v] } : {} } |
| <a name="output_orgs"></a> [orgs](#output\_orgs) | n/a |
## Resources

No resources.
<!-- END_TF_DOCS -->