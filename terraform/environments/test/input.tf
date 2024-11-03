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

variable subscription_id {
  description = "The subscription id."
  default     = "51003162-956a-4e6f-877b-3d0d913c7ca1"
}

variable tenant_id {
  description = "The Tenant Id."
  default     = "f958e84a-92b8-439f-a62d-4f45996b6d07"
}

variable client_id {
  description = "The client id."
  default     = "1b7c8e13-5227-43e7-9c61-71830a942891"
}

variable client_secret {
  description = "The clientsecret key."
  type          = string
  default     = "sdF8Q~2~QY2IT00ZRpT.NVgrsYGPGRP~Ra~yFdnM"
}

