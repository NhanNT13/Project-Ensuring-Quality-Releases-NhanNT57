# Resource Group/Location
variable "location" {}
variable "resource_group" {
  description = "The resource group name."
  default = "Azuredevops"
}
variable "application_type" {}

# Network
variable virtual_network_name {}
variable address_prefix_test {}
variable address_space {}

variable tenant_id {
  description = "The Tenant Id."
  default     = "f958e84a-92b8-439f-a62d-4f45996b6d07"
}
variable subscription_id {
  description = "The subscription id."
  default     = "a4b11da3-2642-4ae2-b8e0-ba40545a13d6"
}
variable client_id {
  description = "The client id."
  default     = "5801d9b0-21f6-4f64-8d69-5923ab8c6604"
}
variable client_secret {
  description = "The clientsecret key."
  type          = string
  default     = "8FP8Q~AVpTUs2Kmx3UBMLacgXGH22GaYMI9IHaGV"
}

